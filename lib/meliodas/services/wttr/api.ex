defmodule Meliodas.Services.Wttr.Api do
  @location "Singapore"
  @url "http://v2d.wttr.in"
  @format "j1"

  def fetch() do
    with {:ok, %Finch.Response{body: body, status: 200}} <- request(),
         {:ok, weather} <- parse(body),
         {:ok, forecast} <- extract_forecast(weather) do
      {:ok, forecast}
    else
      _ -> {:error, %{}}
    end
  end

  def build() do
    Finch.build(
      :get,
      "#{@url}/#{URI.encode(@location)}?format=#{@format}"
    )
  end

  def request() do
    Finch.request(build(), MeliodasFinch)
  end

  def parse(body), do: Jason.decode(body)

  def extract_forecast(%{
        "current_condition" => [
          %{
            "FeelsLikeC" => feels_like,
            "temp_C" => temp,
            "localObsDateTime" => observation_time,
            "weatherDesc" => [
              %{
                "value" => weather_desc
              }
            ]
          }
        ],
        "nearest_area" => [
          %{
            "latitude" => latitude,
            "longitude" => longitude
          }
        ]
      }) do
    {:ok,
     %{
       feels_like: feels_like,
       temp: temp,
       observation_time: observation_time,
       latitude: latitude,
       longitude: longitude,
       location: @location,
       weather_desc: weather_desc
     }}
  end

  def extract_forecast(information) do
    Sentry.capture_message("Wttr API error", extra: %{extra: information})
    {:error, %{}}
  end
end
