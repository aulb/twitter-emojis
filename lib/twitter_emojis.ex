defmodule TwitterEmojis do
  use Application
  @moduledoc """
  Documentation for TwitterEmojis.
  """

  @doc """
  Hello world.

  ## Examples

      iex> TwitterEmojis.hello
      :world

  """
  def hello do
    :world
  end

  def test_strings do
    [
      "yes this is my 😀  favorite emoji!!! 😱😱",
      "hello world 😀 fdsf",
      "Albert's feeling like 🍕"
    ]
  end

  def parse_string(string, map) do
    string
    |> to_charlist
    |> Enum.reduce(map, fn
      (char, mapAcc) when char >= 127829 -> Map.update(mapAcc, to_string([char]), 1, &(&1 + 1))
      (_char, mapAcc) -> mapAcc
    end)
  end

  def start(_type, _args) do
    test_strings()
    |> Enum.reduce(%{}, &TwitterEmojis.parse_string/2)
    |> IO.inspect

    Supervisor.start_link [], strategy: :one_for_one
  end
end
