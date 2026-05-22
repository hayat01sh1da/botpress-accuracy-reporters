## Supported Versions

- The `master` branch is the only branch that receives security fixes.
- Docs and samples under `ruby-on-rails/`, `ruby/`, and `python/` are intended to be consumed from the latest commit. Older tags are not maintained.

## Ecosystem & Compatibility

| Stack / Component       | Version(s) / Tooling               | Notes                                                                                                          |
| ----------------------- | ---------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| OS baseline             | WSL (Ubuntu 25.10)                 | Shared environment across tracks.                                                                              |
| Ruby on Rails exercises | Ruby 4.0.5 (`.ruby-version`)       | Bundler-managed gems per sample app; keep Rails/Botpress gems current.                                         |
| Ruby CLI helpers        | Ruby 4.0.5                         | Depend only on the Ruby standard library.                                                                      |
| Python automation       | CPython 3.14.5 (`.python-version`) | Scripts currently rely on the Python standard library; add new packages via per-folder requirements if needed. |

## Backward Compatibility

- Tutorials strive to keep helper scripts backward compatible across the same major runtime line (Ruby 4.0.x, Python 3.14.x). Breaking changes are announced in the docs prior to release.
- Older majors (Ruby 3.x, Python 3.13 and below) and historical tags are not patched; please upgrade to the versions listed above before reporting.

## Reporting a Vulnerability

Please report issues privately via **GitHub Security Advisory** (preferred) — open through the repository’s **Security → Report a vulnerability** workflow.

Acknowledgement occurs and status updates follow as soon as possible.  
After remediation we publish guidance alongside required dependency updates.
