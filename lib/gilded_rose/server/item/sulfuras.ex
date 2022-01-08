defmodule GildedRose.Server.Item.Sulfuras do
  defstruct [:item]

  defimpl GildedRose.Server.Item do
    def age(sulfuras), do: sulfuras
    def mark_time(sulfuras), do: sulfuras
  end
end
