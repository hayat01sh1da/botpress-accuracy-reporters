# frozen_string_literal: true
# rbs_inline: enabled

# View helpers for rendering the accuracy score chart and its annotations.
module ScoreChartHelper
  ACCURACY_TIERS = [[70.0, 'excellent'], [50.0, 'good'], [30.0, 'bad']].freeze

  def accuracy(row:)
    return unless row.include?('%')
    return '' if row.to_f.zero?

    ACCURACY_TIERS.find { |threshold, _label| row.to_f >= threshold }&.last || 'useless'
  end
end
