# Title: Day15

sample = "0,3,6"
input = "0,14,6,20,1,4"

defmodule Game do
  defstruct last: nil, record: %{}, turn: 1
end

defmodule Shared do
  def speak_until(%Game{turn: turn} = game, max_turn) when turn <= max_turn,
    do: speak_until(speak(game), max_turn)

  def speak_until(%Game{} = game, _max_turn), do: game

  def speak(%Game{last: last, record: record, turn: turn}) do
    new_last =
      case Map.get(record, last) do
        nil -> :error
        {_} -> 0
        {i, j} -> i - j
      end

    new_record =
      case Map.get(record, new_last) do
        nil -> {turn}
        {i} -> {turn, i}
        {i, _} -> {turn, i}
      end

    %Game{
      last: new_last,
      record: Map.put(record, new_last, new_record),
      turn: turn + 1
    }
  end

  def init(starting_numbers), do: init(starting_numbers, %Game{})
  def init([], %Game{} = game), do: game

  def init([n | tail], %Game{record: record, turn: turn}) do
    init(tail, %Game{last: n, record: Map.put(record, n, {turn}), turn: turn + 1})
  end
end

{starting_numbers, _} = Code.eval_string("[#{input}]")

starting_numbers
|> Shared.init()
|> Shared.speak_until(30000000)
|> Map.get(:last)
|> IO.inspect()
