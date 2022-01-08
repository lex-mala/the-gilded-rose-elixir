defmodule GildedRose.Server.Item.Conjured do
  defstruct [:item]

  defimpl GildedRose.Server.Item do
    alias GildedRose.Utils
    alias GildedRose.Server.Item.Conjured

    def age(%Conjured{item: %{quality: q} = item} = conjured) when q < 2 do
      %Conjured{conjured | item: Utils.zero_quality(item)}
    end

    def age(%Conjured{item: %{sell_in: s} = item} = conjured) when s < 0 do
      %Conjured{conjured | item: Utils.dec_quality(item, 4)}
    end

    def age(%Conjured{item: item} = conjured) do
      %Conjured{conjured | item: Utils.dec_quality(item, 2)}
    end

    def mark_time(%Conjured{item: item} = conjured) do
      %Conjured{conjured | item: Utils.dec_sell_in(item)}
    end
  end
end
