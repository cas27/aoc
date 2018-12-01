defmodule Aoc.Day1 do
  def get_frequency(current_frequency, frequency_matches) do
    File.stream!("priv/day1.txt")
    |> Enum.reduce_while({current_frequency, frequency_matches}, fn offset, {current, matches} ->
      result =
        offset
        |> String.trim()
        |> String.to_integer()
        |> Kernel.+(current)

      case Map.get(matches, result) do
        nil -> {:cont, {result, Map.put(matches, result, 1)}}
        _ -> {:halt, result}
      end
    end)
  end

  def find_first_duplicate(current_frequency \\ 0, matches \\ %{}) do
    result = get_frequency(current_frequency, matches)
    get_duplicate_frequency(result)
  end

  def get_duplicate_frequency({current_frequency, matches}), do: find_first_duplicate(current_frequency, matches)
  def get_duplicate_frequency(first_duplicate), do: first_duplicate
end
