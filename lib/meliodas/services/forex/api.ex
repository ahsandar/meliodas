defmodule Meliodas.Services.Forex.Api do
  alias Decimal, as: D

  # Developer key 1000/req/month NO HTTPS
  @url "http://data.fixer.io/api/latest?access_key="
  @key "GetYourAPIKey"

  def fetch() do
    with {:ok, %Finch.Response{body: body, status: 200}} <- request(),
         {:ok, response} <- parse(body),
         {:ok, rates} <- collect(response) do
      {:ok, rates}
    else
      _ -> {:error, %{}}
    end
  end

  def build() do
    Finch.build(
      :get,
      "#{@url}#{@key}"
    )
  end

  def request() do
    Finch.request(build(), MeliodasFinch)
  end

  def parse(body), do: Jason.decode(body)

  def collect(%{"rates" => rates}) do
    # calculate PKR to other currencies
    {:ok,
     %{
       "EUR" => "#{D.from_float(rates["PKR"]) |> D.round(2)}",
       "USD" => "#{D.div(D.from_float(rates["PKR"]), D.from_float(rates["USD"])) |> D.round(2)}",
       "GBP" => "#{D.div(D.from_float(rates["PKR"]), D.from_float(rates["GBP"])) |> D.round(2)}",
       "SGD" => "#{D.div(D.from_float(rates["PKR"]), D.from_float(rates["SGD"])) |> D.round(2)}",
       "MYR" => "#{D.div(D.from_float(rates["PKR"]), D.from_float(rates["MYR"])) |> D.round(2)}",
       "AED" => "#{D.div(D.from_float(rates["PKR"]), D.from_float(rates["AED"])) |> D.round(2)}",
       "CNY" => "#{D.div(D.from_float(rates["PKR"]), D.from_float(rates["CNY"])) |> D.round(2)}",
       "BTC" => "#{D.div(D.from_float(rates["PKR"]), D.from_float(rates["BTC"])) |> D.round(2)}"
     }}
  end

  def collect(information) do
    Sentry.capture_message("Forex API error", extra: %{extra: information}) 
    {:error, %{}}
  end
end
