defmodule GildedRose.Server.Item.Backstage do
  defstruct [:item]

  defimpl GildedRose.Server.Item do
    alias GildedRose.Item.Ops
    alias GildedRose.Server.Item.Backstage

    def age(%Backstage{item: %{sell_in: s} = item} = backstage) when s > 10 do
      %Backstage{backstage | item: Ops.inc_quality(item, 1)}
    end

    def age(%Backstage{item: %{sell_in: s} = item} = backstage) when s > 5 do
      %Backstage{backstage | item: Ops.inc_quality(item, 2)}
    end

    def age(%Backstage{item: %{sell_in: s} = item} = backstage) when s >= 0 do
      %Backstage{backstage | item: Ops.inc_quality(item, 3)}
    end

    def age(%Backstage{item: item} = backstage) do
      %Backstage{backstage | item: Ops.zero_quality(item)}
    end

    def mark_time(%Backstage{item: item} = backstage) do
      %Backstage{backstage | item: Ops.dec_sell_in(item)}
    end
  end
end
