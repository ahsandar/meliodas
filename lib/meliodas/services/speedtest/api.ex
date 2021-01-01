defmodule Meliodas.Services.Speedtest.Api do
  alias Decimal, as: D

  @cmd "speedtest"
  @flag "json"

  def fetch() do
    request() |> parse() |> format()
  end

  def build() do
    ["-f", @flag, "--accept-license"]
  end

  def request() do
    with {response, 0} <- System.cmd(@cmd, build()) do
      response
    else
      _ -> "{}"
    end
  end

  def parse(body), do: Jason.decode(body)

  def format(
        {:ok,
         %{
           "ping" => ping,
           "download" => download,
           "upload" => upload,
           "isp" => isp
         }}
      ) do
    {:ok,
     %{
       latency: "#{ping["latency"]}ms",
       jitter: "#{ping["jitter"]}ms",
       download: "#{download["bandwidth"] |> calculate_bandwidth_mbits()}Mbps",
       upload: "#{upload["bandwidth"] |> calculate_bandwidth_mbits()}Mbps",
       isp: isp
     }}
  end

  def format({:ok, %{}} = information) do
    Sentry.capture_message("Speedtest error", extra: %{extra: information}) 
    {:error, %{}}
  end

  def format({:error, _}= information) do
    Sentry.capture_message("Speedtest error", extra: %{extra: information})
    {:error, %{}}
  end

  def calculate_bandwidth_mbits(bits) do
    bits |> D.div(1024) |> D.div(1024) |> D.round(2)
  end
end
