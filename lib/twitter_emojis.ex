defmodule TwitterEmojis do
  use Application
  @moduledoc """
  Documentation for TwitterEmojis.
  """

  @doc """
  Notes:
  1) Why are we using defmacro?
  The reason why ... TODO

  2) Be very careful with single quote and double quote
  Double quote is a string
  Single quote is a charlist -> is just a list

  3) Source: https://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
  """
  @emoji_ranges [
    0x1F900..0x1F9FF,
    0x1F680..0x1F6FF,
    0x1F300..0x1F5FF,
    0x1F600..0x1F64F,
    0x2700..0x27BF,
    0x2600..0x26FF,
    0xFE00..0xFE0F,  
    65024..65039, 
    8400..8447
  ]

  def test_strings do
    [
      "yes this is my 😀  favorite emoji!!! 😱😱",
      "hello w🌀rld 😀 🗿fdsf",
      "Albert's feeling like 🙏🍕"
    ]
  end

  def parse_string(string, map) do
    # Convert char string to binary rep
    string
    |> to_charlist
    |> Enum.filter(fn
      (char) -> Enum.any?(@emoji_ranges, fn(range) -> char in range end)
      end)
    |> Enum.reduce(map, fn(char, mapAcc) ->  
      Map.update(mapAcc, to_string([char]), 1, &(&1 + 1))
      end)
    |> IO.inspect
  end

  def start(_type, _args) do
    # Test strings are being enumerated
    test_strings()
    # TODO: How come it knows to pass %{} as the second argument?
    |> Enum.reduce(%{}, &TwitterEmojis.parse_string/2)
    |> IO.inspect

    Supervisor.start_link [], strategy: :one_for_one
  end
end
