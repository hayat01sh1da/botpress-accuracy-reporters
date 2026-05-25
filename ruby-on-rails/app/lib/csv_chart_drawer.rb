# frozen_string_literal: true
# rbs_inline: enabled

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

  # @rbs return: Array[Array[Hash[String, (String | Float)]]]
  def score_tables
    res_bodies.map do |res_body|
      (0...res_body['suggestions'].length).map do |index|
        score_table         = {}
        answer              = res_body['suggestions'][index]['payloads'][0]['text']
        score               = res_body['suggestions'][index]['confidence']
        score_table[answer] = score
        score_table
      end
    end
  end

  # @rbs return: Array[Array[String]]
  def rows
    score_tables.map do |score_table|
      scores = []
      scores.fill('0.0%', 0...test_data['Answer'].length)
      score_table.map do |score_mapping|
        score_mapping.each do |answer, score|
          index         = test_data['Answer'].find_index(answer)
          scores[index] = "#{format('%.1f', score * 100)}%"
        end
      end
      scores
    end
  end
end
