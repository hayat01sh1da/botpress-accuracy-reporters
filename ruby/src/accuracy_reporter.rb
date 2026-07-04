# frozen_string_literal: true
# rbs_inline: enabled

require_relative 'botpress_endpoint'
require_relative 'queries/accuracy_check_query'
require_relative 'lib/csv_chart_drawer'

# Exports an accuracy score chart by querying a Botpress endpoint with the
# rows of a test-data CSV and writing the per-question scores out as CSV.
class AccuracyReporter
  # @rbs endpoint: BotpressEndpoint
  # @rbs path_to_test_data: String
  # @rbs path_to_accuracy_score_chart: String
  # @rbs return: void
  def self.run(endpoint:, path_to_test_data:, path_to_accuracy_score_chart:)
    new(endpoint:, path_to_test_data:, path_to_accuracy_score_chart:).run
  end

  # @rbs endpoint: BotpressEndpoint
  # @rbs path_to_test_data: String
  # @rbs path_to_accuracy_score_chart: String
  # @rbs return: void
  def initialize(endpoint:, path_to_test_data:, path_to_accuracy_score_chart:)
    @endpoint                     = endpoint
    @path_to_test_data            = path_to_test_data
    @path_to_accuracy_score_chart = path_to_accuracy_score_chart
    @res_bodies                   = ::Queries::AccuracyCheckQuery.request!(endpoint:, path_to_test_data:)
  end

  # @rbs return: void
  def run
    csv_chart = ::Lib::CsvChartDrawer.run(path_to_test_data:, res_bodies:)
    File.open(filename, 'w') { |f| f.puts(csv_chart) }
  end

  private

  attr_reader :endpoint, :path_to_test_data, :path_to_accuracy_score_chart, :res_bodies

  # @rbs return: String
  def filename
    File.join(path_to_accuracy_score_chart, "accuracy_score_chart_#{Time.now.strftime('%F%T').gsub(/[:-]/, '')}.csv")
  end
end
