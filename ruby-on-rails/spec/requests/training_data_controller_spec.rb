# frozen_string_literal: true
# rbs_inline: enabled

require 'rails_helper'
require 'csv'

RSpec.describe TrainingDataController, type: :request do
  describe '#new' do
    before do
      get new_training_data_path
    end

    it 'returns a successful status code' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns a page title' do
      expect(response.body).to include('<h1>Create JSON Training Data</h1>')
    end

    it 'returns a CSV training data upload form' do
      expect(response.body).to include('<form enctype="multipart/form-data" action="/training_data/download" accept-charset="UTF-8" method="post">')
      expect(response.body).to include('<p><input accept=".csv" type="file" name="training_data" id="training_data" /></p>')
      expect(response.body).to include('<p><input type="submit" name="commit" value="Export JSON" class="btn btn-primary" data-disable-with="Export JSON" /></p>')
    end
  end

  describe '#download' do
    before do
      post training_data_download_path, params: params
    end

    context 'if JSON training data file is selected' do
      let(:params)           { { training_data: nil } }
      let(:postfix)          { DateTime.current.strftime('%F%T').gsub(/[:-]/, '') }
      let(:file_to_download) { "training_data_#{postfix}.json" }

      xit 'returns a successful status code' do
        expect(response).to have_http_status(:ok)
      end

      xit 'returns a JSON training data download modal' do
        expect(response.header['Content-Disposition']).to eq("attachment; filename=\"#{file_to_download}\"; filename*=UTF-8''#{file_to_download}")
      end
    end

    context 'if NO JSON training data file is selected' do
      let(:params) { { training_data: nil } }

      it 'returns a successful status code' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders a CSV training data upload page with an error message' do
        expect(response.body).to include('<div class="alert alert-danger">')
        expect(response.body).to include('<li>Training data can&#39;t be blank</li>')
      end
    end
  end
end
