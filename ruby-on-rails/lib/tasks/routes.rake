# frozen_string_literal: true

namespace :routes do
  desc 'Export the index of all endpoints in markdown format'
  task export: :environment do
    Rails.application.reload_routes!
    require 'action_dispatch/routing/inspector'
    inspector = ActionDispatch::Routing::RoutesInspector.new(Rails.application.routes.routes)
    markdown  = inspector.format(MarkdownFormatter.new)
    File.open('docs/routes.md', 'w') do |f|
      f.puts "## Endpoints\n\n" << markdown
    end
  end
end
