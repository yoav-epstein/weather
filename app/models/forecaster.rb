# frozen_string_literal: true

class Forecaster
  def initialize(zip_code)
    @zip_code = zip_code
  end

  def forecast
    @current = false
    Rails.cache.fetch(forecast_cache_key, expires_in: 30.minutes) do
      @current = true
      open_weather_map_forecast
    end
  rescue Integrations::OpenWeatherMap::Error => e
    InvalidForecast.new(zip_code:, error_message: e.message)
  end

  def cached?
    @current.nil? ? nil : !@current
  end

  private

  attr_reader :zip_code

  def forecast_cache_key
    "forecast/#{zip_code}"
  end

  def open_weather_map_forecast
    Integrations::OpenWeatherMap.forecast_for(zip_code)
  end
end
