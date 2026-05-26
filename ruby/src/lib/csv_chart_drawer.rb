# frozen_string_literal: true
# rbs_inline: enabled

require 'csv'

module Lib
  # Builds a CSV chart that pairs each test question with the confidence
  # scores returned by Botpress for every candidate answer.
  class CsvChartDrawer
    # @rbs path_to_test_data: String
    # @rbs res_bodies: Array[Hash[String, untyped]]
    # @rbs return: String
    def self.run(path_to_test_data:, res_bodies:)
      new(path_to_test_data:, res_bodies:).run
    end

    # @rbs path_to_test_data: String
    # @rbs res_bodies: Array[Hash[String, untyped]]
    # @rbs return: void
    def initialize(path_to_test_data:, res_bodies:)
      @test_data  = CSV.read(path_to_test_data, headers: true)
      @res_bodies = res_bodies
    end

    # @rbs return: String
    def run
      CSV.generate(headers:, write_headers: true) do |csv|
        rows.each_with_index do |row, index|
          csv << [test_data[index]['ID'], test_data[index]['Question']].concat(row)
        end
      end
    end

    private

    attr_reader :test_data, :res_bodies

    # @rbs return: Array[String]
    def headers
      %w[ID Test_Data].concat(test_data['ID'])
    end

    # @rbs return: Array[Hash[String, Float]]
    def score_tables
      res_bodies.map do |res_body|
        res_body['suggestions'].to_h do |suggestion|
          [suggestion['payloads'][0]['text'], suggestion['confidence']]
        end
      end
    end

    # @rbs return: Array[Array[String]]
    def rows
      score_tables.map { |score_table| score_row_for(score_table) }
    end

    # @rbs score_table: Hash[String, Float]
    # @rbs return: Array[String]
    def score_row_for(score_table)
      scores = Array.new(test_data['Answer'].length, '0.0%')
      score_table.each do |answer, score|
        index         = test_data['Answer'].find_index(answer)
        scores[index] = "#{format('%.1f', score * 100)}%"
      end
      scores
    end
  end
end
