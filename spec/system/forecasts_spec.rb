require "rails_helper"

RSpec.describe "Forecasts", type: :system, js: true do
  let(:forecast_body) { load_fixture "open_weather_map_success" }

  before do
    stub_request(:get, /api.openweathermap.org/).to_return(body: forecast_body)
  end

  it "forecasts the weather by zip code" do
    visit "/forecasts"

    expect(page).to have_text "Yoav's Weather Forecaster"

    fill_in :zip_code, with: "90210"
    click_button "Forecast"

    expect(page).to have_text "Zip Code: 90210"
    expect(page).to have_text "Temperature: 90.46"
  end

  it "caches requests" do
    visit "/forecasts"

    expect(page).to have_text "Yoav's Weather Forecaster"

    fill_in :zip_code, with: "90210"
    click_button "Forecast"

    expect(page).to have_text "Zip Code: 90210"
    expect(page).to have_text "Temperature: 90.46"
    expect(page).to_not have_text "(cached)"

    fill_in :zip_code, with: "90210"
    click_button "Forecast"

    expect(page).to have_text "Zip Code: 90210 (cached)"
    expect(page).to have_text "Temperature: 90.46"
  end

  context "invalid zip code" do
    let(:forecast_body) { load_fixture "open_weather_map_failure" }

    it "shows an error" do
      visit "/forecasts"

      expect(page).to have_text "Yoav's Weather Forecaster"

      fill_in :zip_code, with: "210"
      click_button "Forecast"

      expect(page).to have_text "Zip Code: 210"
      expect(page).to have_text "Error: invalid zip code"
      expect(page).to_not have_text "(cached)"

      fill_in :zip_code, with: "210"
      click_button "Forecast"

      expect(page).to have_text "Zip Code: 210 (cached)"
      expect(page).to have_text "Error: invalid zip code"
    end
  end
end
