# frozen_string_literal: true
# rbs_inline: enabled

require 'rails_helper'
require 'csv'

RSpec.describe ScoreChartController, type: :request do
  describe '#new' do
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
      expect(response.body).to include('<form enctype="multipart/form-data" action="http://www.example.com/score_chart" accept-charset="UTF-8" method="post">')
      expect(response.body).to include('<p><select name="scheme" id="scheme"><option selected="selected" value="https">https</option>')
      expect(response.body).to include('<p><input size="50" placeholder="sample.com" type="text" name="host" id="host" /></p>')
      expect(response.body).to include('<p><input size="30" placeholder="sample-bot" type="text" name="bot_id" id="bot_id" /></p>')
      expect(response.body).to include('<p><input size="30" placeholder="sample-user" type="text" name="user_id" id="user_id" /></p>')
      expect(response.body).to include('<p><textarea placeholder="Bearer ..." name="access_token" id="access_token" cols="100" rows="5">')
      expect(response.body).to include('<p><input accept=".csv" type="file" name="test_data" id="test_data" /></p>')
      expect(response.body).to include('<p><input type="submit" name="commit" value="Create Score Chart" class="btn btn-primary" data-disable-with="Create Score Chart" /></p>')
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
          access_token: '1'.upto('10').to_a.then { it + 'A'.upto('Z').to_a }.then { it + 'a'.upto('z').to_a }.sample(64).join,
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

      it 'returns a successful status code' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders a test score data upload page with error messages for each param' do
        expect(response.body).to include('<div class="alert alert-danger">')
        expect(response.body).to include('<li>Scheme can&#39;t be blank</li>')
        expect(response.body).to include('<li>Host can&#39;t be blank</li>')
        expect(response.body).to include('<li>Bot can&#39;t be blank</li>')
        expect(response.body).to include('<li>User can&#39;t be blank</li>')
        expect(response.body).to include('<li>Access token can&#39;t be blank</li>')
        expect(response.body).to include('<li>Test data can&#39;t be blank</li>')
      end
    end
  end

  describe '#draw' do
    let(:source)      { Rails.root.join('csv/accuracy_score_chart_20211130220255.csv') }
    let(:dirname)     { Rails.root.join('tmp/downloads') }
    let(:destination) { Rails.root.join(dirname, 'accuracy_score_chart_20211130220255.csv') }

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
      expect(response.body).to include('<th class=>ID</th>')
      expect(response.body).to include('<th class=>Test_Data</th>')
      expect(response.body).to include('<th class=>QA001</th>')
      expect(response.body).to include('<th class=>GitHubとは何ぞや</th>')
      expect(response.body).to include('<th class=good>53.3%</th>')
      expect(response.body).to include('<h2>Annotation</h2>')
      expect(response.body).to include('<p class="excellent">Greater than or equal to 70.0%</p>')
      expect(response.body).to include('<p class="good">Greater than or equal to 50.0% and less than 70.0%</p>')
      expect(response.body).to include('<p class="bad">Greater than or equal to 30.0% and less than 50.0%</p>')
      expect(response.body).to include('<p class="useless">Greater than or equal to 0.1% and less than 30.0%</p>')
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
      expect(response.header['Content-Disposition']).to eq("attachment; filename=\"#{file_to_download}\"; filename*=UTF-8''#{file_to_download}")
    end
  end
end
