require "rails_helper"

RSpec.describe ForecastsController do
  describe "GET index" do
    subject { get :index }

    it { is_expected.to have_rendered :index }
  end

  describe "POST create" do
    subject { post :create, params: params }

    let(:params) { { zip_code: "90210" } }
    let(:forecast_body) { load_fixture "open_weather_map_success" }

    before do
      stub_request(:get, /api.openweathermap.org/).to_return(body: forecast_body)
    end

    it { is_expected.to have_rendered "forecasts/_forecast" }

    context "zip code is invalid" do
      let(:params) { { zip_code: "210" } }
      let(:forecast_body) { load_fixture "open_weather_map_failure" }

      it { is_expected.to have_rendered "forecasts/_invalid_forecast" }
    end
  end
end
