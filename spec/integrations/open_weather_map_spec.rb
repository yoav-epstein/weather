require "rails_helper"

RSpec.describe Integrations::OpenWeatherMap do
  describe ".forecast_for" do
    subject { described_class.forecast_for(zip_code) }

    let(:zip_code) { "90210" }
    let(:forecast_body) { load_fixture "open_weather_map_success", temp: }
    let(:temp) { 74.0 }

    before do
      stub_request(:get, /api.openweathermap.org/).to_return(body: forecast_body)
    end

    it { is_expected.to be_a Forecast }

    it "copies the data from the service into the forecast" do
      expect(subject.to_h).to include(zip_code: zip_code,
                                      temp: temp,
                                      temp_min: 74.12,
                                      temp_max: 97.54,
                                      city: "Beverly Hills",
                                      description: "clear sky")
    end

    context "zip code is invalid" do
      let(:zip_code) { "210" }
      let(:forecast_body) { load_fixture "open_weather_map_failure" }

      it { is_expected.to be_an InvalidForecast }

      it "copies the data from the service into the forecast" do
        expect(subject.to_h).to include(zip_code: zip_code,
                                        error_message: "invalid zip code")
      end
    end

    context "network error" do
      before do
        stub_request(:get, /api.openweathermap.org/).to_raise(Net::ReadTimeout)
      end

      it "raises an OpenWeatherMap exception" do
        expect { subject }.to raise_error(Integrations::OpenWeatherMap::Error)
      end
    end
  end
end
