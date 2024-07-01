require "rails_helper"

RSpec.describe Forecaster do
  describe "#forecast" do
    subject { forecaster.forecast }

    let(:forecaster) { described_class.new(zip_code) }
    let(:zip_code) { "90210" }
    let(:forecast_body) { load_fixture "open_weather_map_success" }

    before do
      stub_request(:get, /api.openweathermap.org/).to_return(body: forecast_body)
    end

    it { is_expected.to be_a Forecast }

    it "calls the weather api" do
      subject
      expect(WebMock).to have_requested(:get, /api.openweathermap.org/)
    end

    context "zip code was previously forecasted" do
      before do
        forecaster.forecast
      end

      it { is_expected.to be_a Forecast }

      it "does not call the weather api again" do
        subject
        expect(WebMock).to have_requested(:get, /api.openweathermap.org/).once
      end
    end

    context "zip code was previously forecasted by a different instance of the forecaster" do
      before do
        described_class.new(zip_code).forecast
      end

      it { is_expected.to be_a Forecast }

      it "does not call the weather api again" do
        subject
        expect(WebMock).to have_requested(:get, /api.openweathermap.org/).once
      end
    end

    context "zip code is invalid" do
      let(:zip_code) { "210" }
      let(:forecast_body) { load_fixture "open_weather_map_failure" }

      it { is_expected.to be_an InvalidForecast }
    end

    context "network error" do
      before do
        stub_request(:get, /api.openweathermap.org/).to_raise(Net::ReadTimeout)
      end

      it { is_expected.to be_an InvalidForecast }

      context "zip code was previously tried and failed" do
        before do
          forecaster.forecast
        end

        it "calls the weather api again" do
          subject
          expect(WebMock).to have_requested(:get, /api.openweathermap.org/).twice
        end
      end
    end
  end

  describe "#cached?" do
    subject { forecaster.cached? }

    let(:forecaster) { described_class.new(zip_code) }
    let(:zip_code) { "90210" }
    let(:forecast_body) { load_fixture "open_weather_map_success" }

    before do
      stub_request(:get, /api.openweathermap.org/).to_return(body: forecast_body)
    end

    it { is_expected.to be nil }

    context "zip code was forecasted" do
      before do
        forecaster.forecast
      end

      it { is_expected.to be false }

      context "but was in the cache (forecasted more than once)" do
        before do
          forecaster.forecast
        end

        it { is_expected.to be true }
      end
    end
  end
end
