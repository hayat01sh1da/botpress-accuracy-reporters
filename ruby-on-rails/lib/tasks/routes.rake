# frozen_string_literal: true

namespace :routes do
  desc 'Export the index of all endpoints in markdown format'
  task export: :environment do
    Rails.application.reload_routes!
    all_routes = Rails.application.routes.routes
    require 'action_dispatch/routing/inspector'
    inspector = ActionDispatch::Routing::RoutesInspector.new(all_routes)
    markdown = inspector.format(MarkdownFormatter.new)
    export('docs/routes.md', markdown)
  end

  private

  # https://github.com/rails/rails/blob/63f0c04850dd0bcdc7d35266e81fa1a7778570a8/actionpack/lib/action_dispatch/routing/inspector.rb#L64 のI/Fを踏襲

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

  def export(filepath, markdown)
    File.open(filepath, 'w') do |f|
      f.puts "## Endpoints\n\n" << markdown
    end
  end
end
