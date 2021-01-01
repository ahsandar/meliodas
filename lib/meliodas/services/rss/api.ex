defmodule Meliodas.Services.Rss.Api do
  @url "https://www.dawn.com/feeds/home"

  def fetch() do
    with {:ok, %Finch.Response{body: body, status: 200}} <- request(),
         {:ok, response} <- parse(body),
         {:ok, titles} <- collect(response) do
      {:ok, titles}
    else
      _ -> {:error, %{}}
    end
  end

  def build() do
    Finch.build(:get, @url)
  end

  def request() do
    Finch.request(build(), MeliodasFinch)
  end

  def parse(body), do: ElixirFeedParser.parse(body)

  def collect(feed), do: {:ok, Enum.map(feed.entries, fn x -> x.title end) |> Enum.take(7)}
end
