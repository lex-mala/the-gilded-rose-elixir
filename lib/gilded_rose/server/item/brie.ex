defmodule GildedRose.Server.Item.Brie do
  defstruct [:item]

  defimpl GildedRose.Server.Item do
    alias GildedRose.Item.Ops
    alias GildedRose.Server.Item.Brie

    def age(%Brie{item: %{quality: q} = item} = brie) when q < 50 do
      %Brie{brie | item: Ops.inc_quality(item, 1)}
    end

    def age(%Brie{} = brie) do
      brie
    end

    def mark_time(%Brie{item: item} = brie) do
      %Brie{brie | item: Ops.dec_sell_in(item)}
    end
  end
end
