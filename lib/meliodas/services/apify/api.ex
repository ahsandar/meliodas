defmodule Meliodas.Services.Apify.Api do
  @url "https://api.apify.com/v2/key-value-stores/tVaYRsPHLjNdNBu7S/records/LATEST?disableRedirect=true"

  def fetch() do
    with {:ok, %Finch.Response{body: body, status: 200}} <- request(),
         {:ok, response} <- parse(body),
         {:ok, highest_sorted} <- sort(response) do
      {:ok, highest_sorted}
    else
      _ -> {:error, %{}}
    end
  end

  def build() do
    Finch.build(
      :get,
      @url
    )
  end

  def request() do
    Finch.request(build(), MeliodasFinch)
  end

  def parse(body), do: Jason.decode(body)

  def sort(response) do
    top_5 =
      Enum.sort(response, &(&1["infected"] > &2["infected"]))
      |> Enum.take(5)

    pakistan = Enum.filter(response, fn x -> x["country"] == "Pakistan" end)

    {:ok, pakistan ++ top_5}
  end
end
