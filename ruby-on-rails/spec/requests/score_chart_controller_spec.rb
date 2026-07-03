# frozen_string_literal: true
# rbs_inline: enabled

require 'rails_helper'
require 'csv'

RSpec.describe ScoreChartController do
  describe '#new' do
    let(:upload_form_snippets) do
      [
        '<form enctype="multipart/form-data" action="http://www.example.com/score_chart" ' \
        'accept-charset="UTF-8" method="post">',
        '<p><select name="scheme" id="scheme"><option selected="selected" value="https">https</option>',
        '<p><input size="50" placeholder="sample.com" type="text" name="host" id="host" /></p>',
        '<p><input size="30" placeholder="sample-bot" type="text" name="bot_id" id="bot_id" /></p>',
        '<p><input size="30" placeholder="sample-user" type="text" name="user_id" id="user_id" /></p>',
        '<p><textarea placeholder="Bearer ..." name="access_token" id="access_token" cols="100" rows="5">',
        '<p><input accept=".csv" type="file" name="test_data" id="test_data" /></p>',
        '<p><input type="submit" name="commit" value="Create Score Chart" class="btn btn-primary" ' \
        'data-disable-with="Create Score Chart" /></p>'
      ]
    end

    before do
      get new_score_chart_path
    end

    it 'returns a successful status code' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns a page title' do
      expect(response.body).to include('<h1>Create Score Chart</h1>')
    end

    it 'returns a CSV test score data upload form' do
      expect(response.body).to include(*upload_form_snippets)
    end
  end

  describe '#create' do
    before do
      post score_chart_path, params: params
    end

    context 'when all required params are passed' do
      let(:params) do
        {
          scheme: 'https',
          host: 'sample.com',
          bot: 'sample_bot',
          user: 'sample_user',
          access_token: SecureRandom.alphanumeric(64),
          test_data: nil
        }
      end

      it 'returns a successful status code', skip: 'Pending until a Botpress test endpoint is available' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a CSV score data download modal', skip: 'Pending until a Botpress test endpoint is available' do
        expect(response.body).to include(nil)
      end
    end

    context 'when NO required params are passed' do
      let(:params) do
        {
          scheme: nil,
          host: nil,
          bot: nil,
          user: nil,
          access_token: nil,
          test_data: nil
        }
      end

      let(:error_message_snippets) do
        [
          '<div class="alert alert-danger">',
          '<li>Scheme can&#39;t be blank</li>',
          '<li>Host can&#39;t be blank</li>',
          '<li>Bot can&#39;t be blank</li>',
          '<li>User can&#39;t be blank</li>',
          '<li>Access token can&#39;t be blank</li>',
          '<li>Test data can&#39;t be blank</li>'
        ]
      end

      it 'returns a successful status code' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders a test score data upload page with error messages for each param' do
        expect(response.body).to include(*error_message_snippets)
      end
    end
  end

  describe '#draw' do
    let(:source)      { Rails.root.join('csv/accuracy_score_chart_20211130220255.csv') }
    let(:dirname)     { Rails.root.join('tmp/downloads') }
    let(:destination) { Rails.root.join(dirname, 'accuracy_score_chart_20211130220255.csv') }

    let(:score_table_snippets) do
      [
        '<th class=>ID</th>',
        '<th class=>Test_Data</th>',
        '<th class=>QA001</th>',
        '<th class=>GitHubとは何ぞや</th>',
        '<th class=good>53.3%</th>',
        '<h2>Annotation</h2>',
        '<p class="excellent">Greater than or equal to 70.0%</p>',
        '<p class="good">Greater than or equal to 50.0% and less than 70.0%</p>',
        '<p class="bad">Greater than or equal to 30.0% and less than 50.0%</p>',
        '<p class="useless">Greater than or equal to 0.1% and less than 30.0%</p>'
      ]
    end

    before do
      get score_chart_draw_path
    end

    around do |example|
      FileUtils.mkdir_p(dirname)
      FileUtils.copy(source, destination)
      example.run
      FileUtils.rm_rf(destination)
      FileUtils.rm_rf(dirname) if Dir[destination].empty?
    end

    it 'returns a successful status code' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns a page title' do
      expect(response.body).to include('<h1>Accuracy Score Chart</h1>')
    end

    it 'returns a CSV test score table and annotations' do
      expect(response.body).to include(*score_table_snippets)
    end
  end

  describe '#download' do
    let(:source)           { Rails.root.join('csv/accuracy_score_chart_20211130220255.csv') }
    let(:dirname)          { Rails.root.join('tmp/downloads') }
    let(:destination)      { Rails.root.join(dirname, 'accuracy_score_chart_20211130220255.csv') }
    let(:postfix)          { DateTime.current.strftime('%F%T').gsub(/[:-]/, '') }
    let(:file_to_download) { "accuracy_score_chart_#{postfix}.csv" }

    before do
      get score_chart_download_path
    end

    around do |example|
      FileUtils.mkdir_p(dirname)
      FileUtils.copy(source, destination)
      example.run
      FileUtils.rm_rf(destination)
      FileUtils.rm_rf(dirname) if Dir[destination].empty?
    end

    it 'returns a successful status code' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns a score data download modal' do
      expect(response.header['Content-Disposition'])
        .to eq("attachment; filename=\"#{file_to_download}\"; filename*=UTF-8''#{file_to_download}")
    end
  end
end
