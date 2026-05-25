# frozen_string_literal: true
# rbs_inline: enabled

require 'csv'
require 'json'

module Lib
  # Converts a CSV of question/answer pairs into the JSON shape Botpress
  # expects for Q&A training data.
  module Format
    # @rbs array: Array[untyped]
    # @rbs return: Hash[Symbol, untyped]
    def template(array: [])
      {
        id: '',
        data: {
          action: 'text', contexts: ['sample'], enabled: true,
          answers: { ja: array }, questions: { ja: array.dup },
          redirectFlow: '', redirectNode: ''
        }
      }
    end

    # @rbs path_to_csv_training_data: String
    # @rbs array: Array[untyped]
    # @rbs return: String
    def to_json(path_to_csv_training_data:, array: [])
      result = array
      format = template(array: array.dup)
      CSV.foreach(path_to_csv_training_data, headers: true) do |training_datum|
        format = merge_training_datum(format, training_datum)
        format[:data][:questions][:ja].uniq!
        result << format
      end
      JSON.pretty_generate({ qnas: result.uniq })
    end

    private

    # @rbs format: Hash[Symbol, untyped]
    # @rbs training_datum: CSV::Row
    # @rbs return: Hash[Symbol, untyped]
    def merge_training_datum(format, training_datum)
      if format[:data][:answers][:ja].last == training_datum['Answer']
        format[:data][:questions][:ja] << training_datum['Question']
        format
      else
        start_new_format(training_datum)
      end
    end

    # @rbs training_datum: CSV::Row
    # @rbs return: Hash[Symbol, untyped]
    def start_new_format(training_datum)
      new_format      = template
      new_format[:id] = training_datum['ID']
      new_format[:data][:questions][:ja] << training_datum['Question']
      new_format[:data][:answers][:ja] << training_datum['Answer']
      new_format
    end
  end
end
