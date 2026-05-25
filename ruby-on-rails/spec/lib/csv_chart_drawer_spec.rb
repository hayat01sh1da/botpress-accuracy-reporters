# frozen_string_literal: true
# rbs_inline: enabled

require 'rails_helper'

RSpec.describe CsvChartDrawer do
  let(:csv_chart)          { described_class.run(path_to_test_data:, res_bodies:) }
  let(:path_to_test_data)  { Rails.root.join('csv/test_data.csv') }
  let(:path_to_res_bodies) { Rails.root.join('json/res_bodies.json') }
  let(:test_data)          { CSV.read(path_to_test_data) }
  let(:res_bodies)         { File.read(path_to_res_bodies).then { |json| JSON.parse(json) } }

  it 'returns the same number of rows in the CSV chart as that in the test data' do
    expect(test_data.length).to eq(csv_chart.split("\n").length)
  end
end
