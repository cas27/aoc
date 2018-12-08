defmodule Aoc.Day3 do
  @doc """

      iex> Aoc.Day3.overlapped_claims([
      ...> "#123 @ 2,2: 2x2",
      ...> "#124 @ 3,3: 2x2",
      ...> ])
      [{4, 4}]
  """
  def overlapped_claims(claims) do
    for {cord, [_, _ | _]} <- plot_claims(claims), do: cord
  end

  @doc """

      iex> pc = Aoc.Day3.plot_claims([
      ...> "#123 @ 2,2: 2x2",
      ...> "#124 @ 3,3: 2x2",
      ...> "#125 @ 8,8: 2x2"
      ...> ])
      iex> Aoc.Day3.non_overlapped_claims(pc)
      ["125"]
  """
  def non_overlapped_claims(plotted_claims) do
    {ms1, ms2} =
      Enum.reduce(Map.values(plotted_claims), {MapSet.new, MapSet.new}, fn [h | tail], {ms1, ms2} ->
        if length(tail) == 0 do
          ms1 = MapSet.put ms1, h
          {ms1, ms2}
        else
          ms2 = MapSet.put ms2, h
          ms2 = Enum.reduce(tail, ms2, fn id, acc -> MapSet.put acc, id end)
          {ms1, ms2}
        end
      end)

    MapSet.difference(ms1, ms2) |> MapSet.to_list()
  end

  @doc """

      iex> Aoc.Day3.plot_claims([
      ...> "#123 @ 2,2: 2x2",
      ...> "#124 @ 3,3: 2x2",
      ...> ])
      %{
        {3, 3} => ["123"],
        {3, 4} => ["123"],
        {4, 3} => ["123"],
        {4, 4} => ["124", "123"],
        {4, 5} => ["124"],
        {5, 4} => ["124"],
        {5, 5} => ["124"],
      }
  """
  def plot_claims(claims) do
    Enum.reduce(claims, %{}, fn claim, acc ->
      plotted_claim =
        claim
        |> parse_claim()
        |> plot_claim()

      Map.merge(plotted_claim, acc, fn _, v1, v2 -> v1 ++ v2 end)
    end)
  end

  @doc """

      iex> Aoc.Day3.parse_claim("#123 @ 3,2: 5x4")
      {"123", 3, 2, 5, 4}
  """

  def parse_claim(claim) do
    [_, id, x1, y1, x2, y2] =
      claim
      |> String.split(["#", " @ ", ",", ": ", "x"])

    {
      id,
      String.to_integer(x1),
      String.to_integer(y1),
      String.to_integer(x2),
      String.to_integer(y2)
    }
  end

  @doc """

      iex> Aoc.Day3.plot_claim({"123", 3, 2, 2, 2})
      %{
        {4, 3} => ["123"],
        {5, 3} => ["123"],
        {4, 4} => ["123"],
        {5, 4} => ["123"]
      }
  """

  def plot_claim({id, x1, y1, x2, y2}) do
    for x <- (x1+1..(x2+x1)),
        y <- (y1+1..(y2+y1)),
        do: {{x, y}, [id]},
        into: %{}
  end
end
