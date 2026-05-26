# frozen_string_literal: true

# Renders Rails route definitions as a markdown table, following the I/F of
# ActionDispatch::Routing::ConsoleFormatter so it can be passed to
# RoutesInspector#format.
#
# Reference: https://github.com/rails/rails/blob/63f0c04850dd0bcdc7d35266e81fa1a7778570a8/actionpack/lib/action_dispatch/routing/inspector.rb#L64
class MarkdownFormatter
  attr_reader :sections, :current_section

  def initialize
    @sections = []
    @current_section = ''
  end

  def header(_routes)
    sections << '|Prefix |Verb |URI Pattern |Controller#Action |'
    sections << '|:-|:-|:-|:-|'
  end

  def section(routes)
    routes.each do |route|
      sections << "|#{route[:name]} |#{route[:verb]} |#{route[:path]} |#{route[:reqs]} |"
    end
  end

  def result
    sections.join("\n")
  end

  def section_title(title)
    title
  end

  def no_routes
    sections << ''
  end
end
