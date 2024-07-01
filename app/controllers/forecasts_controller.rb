class ForecastsController < ApplicationController
  def create
    forecaster = Forecaster.new(create_params[:zip_code])
    forecast = forecaster.forecast
    partial = forecast.is_a?(Forecast) ? "forecasts/forecast" : "forecasts/invalid_forecast"

    render turbo_stream: turbo_stream.update("forecast",
                                             partial:,
                                             locals: { forecaster:, forecast: })
  end

  private

  def create_params
    params.permit(:zip_code)
  end
end
