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
  defmacro is_emoji(char) do
    # What is quote? Gets the binary representation of its expression
    quote do: unquote(char) in 0x1F600..0x1F64F or unquote(char) in 0x1F300..0x1F5FF
  end

  def parse_string(string, map) do
    string
    # Convert char string to binary rep
    |> to_charlist
    |> Enum.reduce(map, fn
      # Read more: The & shorthand, parameters are available as &1 &2 &3 ..., function that accepts one argument
      # f(x) = x + 1
      # TODO: Learn more about guards
      (char, mapAcc) when is_emoji(char) -> Map.update(mapAcc, to_string([char]), 1, &(&1 + 1))
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
