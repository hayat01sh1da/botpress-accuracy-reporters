# frozen_string_literal: true
# rbs_inline: enabled

module Format
  # @rbs array: Array[untyped]
  # @rbs return: Hash[Symbol, untyped]
  def template(array: [])
    {
      id: '',
      data: {
        action: 'text',
        contexts: ['sample'],
        enabled: true,
        answers: {
          ja: array
        },
        questions: {
          ja: array.dup
        },
        redirectFlow: '',
        redirectNode: ''
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
      if format[:data][:answers][:ja].last == training_datum['Answer']
        format[:data][:questions][:ja] << training_datum['Question']
      else
        format      = template
        format[:id] = training_datum['ID']
        format[:data][:questions][:ja] << training_datum['Question']
        format[:data][:answers][:ja] << training_datum['Answer']
      end
      format[:data][:questions][:ja].uniq!
      result << format
    end

    JSON.pretty_generate({ qnas: result.uniq })
  end
end
