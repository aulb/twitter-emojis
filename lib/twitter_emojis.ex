defmodule TwitterEmojis do
  use Application
  @moduledoc """
  Documentation for TwitterEmojis.
  """

  def test_strings do
    [
      "yes this is my 😀  favorite emoji!!! 😱😱",
      "hello w🌀rld 😀 🗿fdsf",
      "Albert's feeling like 🙏🍕"
    ]
  end

  @doc """
  ## Examples
    iex> TwitterEmojis.is_emoji(?😀)
    true

    iex> TwitterEmojis.is_emoji(?a)
    false

  Notes:
  1) Why are we using defmacro?
  The reason why ... TODO

  2) Be very careful with single quote and double quote
  Double quote is a string
  Single quote is a charlist -> is just a list

  3) Source: https://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
  """
  defmacro is_emoticon(char, emoji_ranges) do
    is_in_range = quote do
      char in emoji_range
    end

    # What is quote?
    quote do: 
      Enum.any?(unquote(emoji_ranges), fn(emoji_range) -> unquote(is_in_range) end)
      # unquote(char) in 0x1F600..0x1F64F or unquote(char) in 0x1F300..0x1F5FF
      # is_emoji(unquote(char))
  end

  def parse_string(string, map) do
    emoji_ranges = [
      0x1F600..0x1F64F,  # Emoticons
      0x1F300..0x1F5FF,  # Misc Symbols and Pictographs
      0x1F680..0x1F6FF,  # Transport and Map
      0x2600..0x26FF,    # Misc symbols
      0x2700..0x27BF,    # Dingbats
      0xFE00..0xFE0F,    # Variation Selectors
      0x1F900..0x1F9FF,  # Supplemental Symbols and Pictographs
      65024..65039,      # Variation selector
      8400..8447         # Combining Diacritical Marks for Symbols
    ]

    string
    # Convert char string to binary rep
    |> to_charlist
    |> Enum.reduce(map, fn
      # Read more: The & shorthand, parameters are available as &1 &2 &3 ..., function that accepts one argument
      # f(x) = x + 1
      # TODO: Learn more about guards
      (char, mapAcc) when is_emoticon(char, emoji_ranges) -> Map.update(mapAcc, to_string([char]), 1, &(&1 + 1))
      # If its not an emoticon, then return the map untouched
      (_char, mapAcc) -> mapAcc
    end)
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
