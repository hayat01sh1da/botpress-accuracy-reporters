# frozen_string_literal: true

Rails.application.routes.draw do
  root 'top#index'
  get  '/top', to: 'top#index'

  # TrainingDataController
  resource :training_data, only: [:new]
  post '/training_data/download', to: 'training_data#download'
  get  '/training_data/download', to: redirect('/training_data/new')

  # ScoreChartController
  resource :score_chart, only: %i[new create], controller: :score_chart
  get '/score_chart/draw',     to: 'score_chart#draw'
  get '/score_chart/download', to: 'score_chart#download', default: { format: :csv }
  get '/score_chart',          to: redirect('/score_chart/new')
end
