# frozen_string_literal: true
# rbs_inline: enabled

# Handles the upload/draw/download flow for the Botpress accuracy score chart.
class ScoreChartController < ApplicationController
  include ChartManager

  before_action :clear_tmp_charts, only: [:new]
  before_action :redirect_to_new_score_chart_url, only: %i[draw download]

  # GET: /score_chart/new
  def new
    @score_chart_form = ScoreChartForm.new
  end

  # POST: /score_chart
  def create
    @score_chart_form = ScoreChartForm.new(test_params)
    return render(:new) unless @score_chart_form.valid?

    res_bodies = fetch_res_bodies or return
    csv_chart  = draw_chart(res_bodies) or return

    save_chart(filename:, csv_chart:)
    redirect_to score_chart_draw_url
  end

  # GET: /score_chart/draw
  def draw
    @chart = matrix_chart
  end

  # GET: /score_chart/download
  def download
    send_file(tmp_chart, filename:)
  end

  private

  def test_params
    params.permit(:scheme, :host, :bot_id, :user_id, :access_token, :test_data)
  end

  def filename
    "accuracy_score_chart_#{DateTime.current.strftime('%F%T').gsub(/[:-]/, '')}.csv"
  end

  def redirect_to_new_score_chart_url
    redirect_to new_score_chart_url and return unless tmp_chart
  end

  def fetch_res_bodies
    AccuracyCheckQuery.request!(
      scheme: @score_chart_form.scheme,
      host: @score_chart_form.host,
      bot_id: @score_chart_form.bot_id,
      user_id: @score_chart_form.user_id,
      access_token: @score_chart_form.access_token,
      test_data: @score_chart_form.test_data
    )
  rescue SocketError
    flash[:alert] = I18n.t('score_chart.errors.invalid_host')
    render :new
    nil
  end

  def draw_chart(res_bodies)
    CsvChartDrawer.run(path_to_test_data: @score_chart_form.test_data, res_bodies:)
  rescue NoMethodError
    flash[:alert] = I18n.t('score_chart.errors.invalid_credentials')
    render :new
    nil
  end
end
