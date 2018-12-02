defmodule Aoc.Day2 do

  def checksum do
    {twos, threes} =
      File.stream!("priv/day2.txt")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.to_charlist/1)
      |> Enum.reduce({0, 0}, fn characters, {x, y} ->
        {twos, threes} = count_letters(characters)
        {x + twos, y + threes}
      end)

    twos * threes
  end

  def find_box do
    box_ids =
      File.stream!("priv/day2.txt")
      |> Enum.map(&String.trim/1)

    Enum.reduce_while(box_ids, nil, fn id, _acc ->
      box_search =
        Enum.reduce_while(box_ids, nil, fn bid, _acc ->
          md = String.myers_difference(bid, id)
          if bid != id and length(md) == 4 and String.length(Keyword.get(md, :del)) == 1 do
            correct_box =
              Keyword.get_values(md, :eq)
              |> Enum.join()

            {:halt, correct_box}
          else
            {:cont, nil}
          end
        end)

      if box_search == nil do
        {:cont, false}
      else
        {:halt, box_search}
      end
    end)
  end

  defp count_letters(characters) do
    letter_counts =
      Enum.reduce(characters, %{}, fn char, acc ->
        Map.update(acc, <<char>>, 1, &(&1 + 1))
      end)

    {occurence_by_size(letter_counts, 2), occurence_by_size(letter_counts, 3)}
  end

  defp occurence_by_size(list, filter) do
    occurences =
      list
      |> Map.values()
      |> Enum.filter(&(&1 == filter))
      |> length()

    if occurences > 0, do: 1, else: 0
  end
end
