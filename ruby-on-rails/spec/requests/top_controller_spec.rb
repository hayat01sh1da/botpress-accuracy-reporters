# frozen_string_literal: true
# rbs_inline: enabled

require 'rails_helper'

RSpec.describe TopController do
  describe '#new' do
    before do
      get top_path
    end

    it 'returns a successful status code' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns a page title' do
      expect(response.body).to include('<h1>Botpress Accuracy Checker</h1>')
    end

    it 'returns a list of linked pages' do
      expect(response.body).to include(
        '<li class="list-group-item"><a href="/training_data/new">Create JSON Training Data</a></li>',
        '<li class="list-group-item"><a href="/score_chart/new">Create Score Chart</a></li>'
      )
    end
  end
end
