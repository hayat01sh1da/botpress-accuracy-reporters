# frozen_string_literal: true
# rbs_inline: enabled

require 'minitest/autorun'
require 'csv'
require 'json'
require_relative '../../src/lib/csv_chart_drawer'

class CSVChartDrawerTest < Minitest::Test
  def setup
    @path_to_test_data = File.join('..', 'csv', 'test_data.csv')
    path_to_res_bodies = File.join('..', 'json', 'res_bodies.json')
    @res_bodies        = File.read(path_to_res_bodies).then { |json| JSON.parse(json) }
  end

  def test_csv
    csv_chart = ::Lib::CsvChartDrawer.run(path_to_test_data:, res_bodies:)
    test_data = CSV.read(path_to_test_data)

    assert_equal test_data.length, csv_chart.split("\n").length
  end

  private

  attr_reader :path_to_test_data, :res_bodies
end
