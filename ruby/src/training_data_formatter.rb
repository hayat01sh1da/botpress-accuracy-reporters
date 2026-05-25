# frozen_string_literal: true
# rbs_inline: enabled

require_relative 'lib/format'

# Reads a CSV training-data file, converts it through Lib::Format, and writes
# the result as a timestamped JSON file under the requested directory.
class TrainingDataFormatter
  include ::Lib::Format

  # @rbs path_to_csv_training_data: String
  # @rbs path_to_json_training_data: String
  # @rbs return: void
  def self.run(path_to_csv_training_data:, path_to_json_training_data:)
    new(path_to_csv_training_data:, path_to_json_training_data:).run
  end

  # @rbs path_to_csv_training_data: String
  # @rbs path_to_json_training_data: String
  # @rbs return: void
  def initialize(path_to_csv_training_data:, path_to_json_training_data:)
    @path_to_csv_training_data  = path_to_csv_training_data
    @path_to_json_training_data = path_to_json_training_data
  end

  # @rbs return: void
  def run
    File.write(filename, to_json(path_to_csv_training_data:))
  end

  private

  attr_reader :path_to_csv_training_data, :path_to_json_training_data

  # @rbs path_to_json_training_data: String
  # @rbs return: String
  def filename
    File.join(path_to_json_training_data, "training_data_#{Time.now.strftime('%F%T').gsub(/[:-]/, '')}.json")
  end
end
