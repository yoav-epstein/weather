# frozen_string_literal: true

require "net/http"

module Integrations
  class OpenWeatherMap
    BASE_URL = "http://api.openweathermap.org/data/2.5/weather"
    API_KEY = Rails.application.credentials.open_weather_map_api_key

    class Error < StandardError; end

    class << self
      def forecast_for(zip_code)
        uri = URI("#{BASE_URL}?zip=#{zip_code},US&units=imperial&appid=#{API_KEY}")
        response = JSON.parse(Net::HTTP.get(uri))
        if response["cod"] == 200
          Forecast.new(zip_code:,
                       temp: response["main"]["temp"],
                       temp_min: response["main"]["temp_min"],
                       temp_max: response["main"]["temp_max"],
                       city: response["name"],
                       description: response["weather"][0]["description"])
        else
          InvalidForecast.new(zip_code:, error_message: response["message"])
        end
      rescue StandardError => e
        raise Error, e
      end
    end
  end
end
