# frozen_string_literal: true
# rbs_inline: enabled

# Reads, writes, and cleans accuracy-score CSV charts under tmp/downloads.
module ChartManager
  PATH = Rails.root.join('tmp/downloads')

  def save_chart(filename:, csv_chart:)
    FileUtils.mkdir_p(PATH)
    File.open(PATH.join(filename), 'w') { |f| f.puts(csv_chart) }
  end

  def tmp_charts
    Dir[PATH.join('accuracy_score_chart*.csv')]
  end

  def tmp_chart
    tmp_charts.last
  end

  def matrix_chart
    CSV.open(tmp_chart, &:read) if tmp_chart
  end

  def clear_tmp_charts
    FileUtils.rm_rf(tmp_charts) if tmp_charts.any?
  end
end
