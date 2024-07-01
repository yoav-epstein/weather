# WEATHER FORECASTER

## Running the application

In a terminal, enter the command: `bin/rails server`

In a browser, navigate to: `http://localhost:3000`, enter the zip code and click the `Forecast` button

## Design Decisions
the `Forecast` model is API agnostic and it is the responsibility of the weather api code to create and fill an
instance of the model. this allows the weather API to be replaced without changing the application.

the `Forecaster` model is responsible for using the weather api to return a `Forecast`. It is also responsible
for caching the forecasts.

## API credentials
OpenWeatherMap is used as the service to get the weather forecast. The api credentials are stored in the file
`config/credentials.yml.enc`, use `bin/rails credentials:edit` to edit it.

## Caching
The Rails memory cache is used by the application. The cache defaults for `development`, and `test` were changed
to keep things simple.
