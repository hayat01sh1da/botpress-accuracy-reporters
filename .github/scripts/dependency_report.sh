#!/usr/bin/env bash
# Generate the '2. Key Changes & Differences' table for daily dependency PRs.
#
# Usage:
#     dependency_report.sh <ecosystem> <lockfile> <manifest> <label>
#
#     ecosystem  pip | gem | pnpm
#     lockfile   path to requirements.lock / Gemfile.lock / pnpm-lock.yaml
#     manifest   path to requirements.txt / Gemfile / package.json
#     label      first column heading (Libraries / Gems / Packages)
#
# Parses `git diff` of the lockfile and prints a markdown table describing each
# changed dependency: the semver level of the change, the package's summary
# fetched from its registry (PyPI / RubyGems / npm), and whether it is a direct
# or transitive dependency. Each dependency name links to its page on the
# official registry (https://rubygems.org / https://pypi.org /
# https://www.npmjs.com) so reviewers can check release notes and changelogs.
# Package-manager updates are reported too: pip as a regular requirements.lock
# entry, bundler from the lockfile's BUNDLED WITH section, and pnpm from the
# manifest's packageManager field.
set -euo pipefail

ecosystem=$1
lockfile=$2
manifest=$3
label=$4

describe() {
  local name=$1 url filter
  case $ecosystem in
    pip)  url="https://pypi.org/pypi/${name}/json"           filter='.info.summary // empty' ;;
    gem)  url="https://rubygems.org/api/v1/gems/${name}.json" filter='.info // empty' ;;
    *)    url="https://registry.npmjs.org/${name}/latest"     filter='.description // empty' ;;
  esac
  curl -fsS --max-time 10 "$url" 2>/dev/null | jq -r "$filter" 2>/dev/null || true
}

clean() {
  local description sentence
  description=$(tr -d '\r' <<<"$1" | tr '\n\t' '  ' | sed -E 's/ +/ /g; s/^ +//; s/ +$//; s/\|/\\|/g')
  if [[ $description == *'. '* ]]; then
    sentence="${description%%. *}."
    if [ "${#sentence}" -ge 20 ]; then
      description=$sentence
    fi
  fi
  if [ "${#description}" -gt 200 ]; then
    description="$(sed -E 's/ +$//' <<<"${description:0:197}")..."
  fi
  if [[ -n $description && $description != *. ]]; then
    description+="."
  fi
  printf '%s' "$description"
}

level() {
  local old new i
  local -a olds news
  IFS=. read -ra olds <<<"$1"
  IFS=. read -ra news <<<"$2"
  for ((i = 0; i < ${#olds[@]} || i < ${#news[@]}; i++)); do
    old=${olds[i]:-0}
    new=${news[i]:-0}
    if [ "$old" != "$new" ]; then
      case $i in
        0) printf 'Major-level update' ;;
        1) printf 'Minor-level update' ;;
        *) printf 'Patch-level update' ;;
      esac
      return
    fi
  done
  printf 'Patch-level update'
}

declare -A before after direct

while IFS= read -r line; do
  case $ecosystem in
    pip)
      [[ $line =~ ^([+-])([A-Za-z0-9][A-Za-z0-9._-]*)==([^[:space:]]+)$ ]] || continue
      ;;
    gem)
      [[ $line =~ ^([+-])\ {4}([^\ ]+)\ \(([0-9][^\)]*)\)$ ]] || continue
      ;;
    *)
      [[ $line == *'('* ]] && continue
      [[ $line =~ ^([+-])\ \ \'?(.+)@([0-9][^\':]*)\'?:?$ ]] || continue
      ;;
  esac
  if [ "${BASH_REMATCH[1]}" = '-' ]; then
    before[${BASH_REMATCH[2]}]=${BASH_REMATCH[3]}
  else
    after[${BASH_REMATCH[2]}]=${BASH_REMATCH[3]}
  fi
done < <(git diff --unified=0 -- "$lockfile")

# bundler and pnpm versions live outside the dependency stanzas parsed above:
# bundler in the lockfile's BUNDLED WITH section and pnpm in the manifest's
# packageManager field. pip needs no extra handling here because it is a
# regular requirements.lock entry.
bundled_with() {
  awk 'prev == "BUNDLED WITH" { print $1; exit } { prev = $0 }'
}

pinned_pnpm() {
  jq -r '.packageManager // empty' 2>/dev/null | sed -E 's/^[^@]+@//; s/\+.*$//'
}

manager_before=''
manager_after=''
case $ecosystem in
  pip)
    manager=pip
    ;;
  gem)
    manager=bundler
    if head_file=$(git show "HEAD:$lockfile" 2>/dev/null); then
      manager_before=$(bundled_with <<<"$head_file" || true)
      manager_after=$(bundled_with < "$lockfile" || true)
    fi
    ;;
  *)
    manager=pnpm
    if head_file=$(git show "HEAD:$manifest" 2>/dev/null); then
      manager_before=$(pinned_pnpm <<<"$head_file" || true)
      manager_after=$(pinned_pnpm < "$manifest" || true)
    fi
    ;;
esac
if [ "$manager_before" != "$manager_after" ]; then
  if [ -n "$manager_before" ]; then before[$manager]=$manager_before; fi
  if [ -n "$manager_after" ]; then after[$manager]=$manager_after; fi
fi

if [ -f "$manifest" ]; then
  case $ecosystem in
    pip)
      while IFS= read -r name; do
        direct[$name]=1
      done < <(sed -nE 's/^([A-Za-z0-9][A-Za-z0-9._-]*).*/\1/p' "$manifest" | tr 'A-Z_' 'a-z-')
      ;;
    gem)
      while IFS= read -r name; do
        direct[$name]=1
      done < <(sed -nE "s/^[[:space:]]*gem ['\"]([^'\"]+)['\"].*/\1/p" "$manifest")
      ;;
    *)
      while IFS= read -r name; do
        direct[$name]=1
      done < <(jq -r '((.dependencies // {}) + (.devDependencies // {})) | keys[]' "$manifest" 2>/dev/null | tr -d '\r' || true)
      ;;
  esac
fi

rows=''
while IFS= read -r name; do
  [ -n "$name" ] || continue
  old=${before[$name]:-}
  new=${after[$name]:-}
  [ "$old" = "$new" ] && continue
  if [ -n "$old" ] && [ -n "$new" ]; then
    what=$(level "$old" "$new")
  elif [ -n "$new" ]; then
    what='Newly added'
  else
    what='Removed'
  fi
  description=$(clean "$(describe "$name")")
  normalised=$name
  if [ "$ecosystem" = 'pip' ]; then
    normalised=$(tr 'A-Z_' 'a-z-' <<<"$name")
  fi
  if [ "$name" = "$manager" ]; then
    kind='Package manager.'
  elif [ -n "${direct[$normalised]:-}" ]; then
    kind='Direct dependency.'
  else
    kind='Transitive dependency.'
  fi
  notes="${what}. ${description:+$description }${kind}"
  case $ecosystem in
    pip) registry_url="https://pypi.org/project/${normalised}/" ;;
    gem) registry_url="https://rubygems.org/gems/${name}" ;;
    *)   registry_url="https://www.npmjs.com/package/${name}" ;;
  esac
  old_cell=${old:+\`$old\`}
  new_cell=${new:+\`$new\`}
  rows+="|[\`${name}\`](${registry_url}) |${old_cell:--} |${new_cell:--} |${notes} |"$'\n'
done < <(printf '%s\n' "${!before[@]}" "${!after[@]}" | sort -fu)

echo "|${label} |Before |After |Changes & Differences |"
echo '|:-|:-|:-|:-|'
if [ -n "$rows" ]; then
  printf '%s' "$rows"
else
  echo '| | | |No dependency changes detected |'
fi
