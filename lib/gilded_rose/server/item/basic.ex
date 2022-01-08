defmodule GildedRose.Server.Item.Basic do
  defstruct [:item]

  defimpl GildedRose.Server.Item do
    alias GildedRose.Item.Ops
    alias GildedRose.Server.Item.Basic

    def age(%Basic{item: %{quality: q} = item} = basic) when q > 1 do
      %Basic{basic | item: Ops.dec_quality(item, 1)}
    end

    def age(%Basic{item: item} = basic) do
      %Basic{basic | item: Ops.zero_quality(item)}
    end

    def mark_time(%Basic{item: item} = basic) do
      %Basic{basic | item: Ops.dec_sell_in(item)}
    end
  end
end
