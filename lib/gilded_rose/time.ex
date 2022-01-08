defmodule GildedRose.Time do
  alias GildedRose.Item

  @type item_type :: :backstage | :basic | :brie | :conjured | :sulfuras

  @spec age({item_type(), %Item{}}) :: {item_type(), %Item{}}
  def age({:backstage, %Item{sell_in: sell_in} = item}) when sell_in > 10 do
    {:backstage, inc_quality(item, 1)}
  end

  def age({:backstage, %Item{sell_in: sell_in} = item}) when sell_in > 5 do
    {:backstage, inc_quality(item, 2)}
  end

  def age({:backstage, %Item{sell_in: sell_in} = item}) when sell_in >= 0 do
    {:backstage, inc_quality(item, 3)}
  end

  def age({:backstage, %Item{} = item}) do
    {:backstage, zero_quality(item)}
  end

  def age({:basic, %Item{quality: quality} = item}) when quality < 2 do
    {:basic, zero_quality(item)}
  end

  def age({:basic, %Item{} = item}) do
    {:basic, dec_quality(item, 1)}
  end

  def age({:brie, %Item{quality: quality} = item}) when quality < 50 do
    {:brie, inc_quality(item, 1)}
  end

  def age({:conjured, %Item{quality: quality} = item}) when quality < 2 do
    {:conjured, zero_quality(item)}
  end

  def age({:conjured, %Item{sell_in: sell_in} = item}) when sell_in < 0 do
    {:conjured, dec_quality(item, 4)}
  end

  def age({:conjured, %Item{} = item}) do
    {:conjured, dec_quality(item, 2)}
  end

  def age({type, %Item{} = item}) do
    {type, item}
  end

  @spec tick({item_type(), %Item{}}) :: {item_type(), %Item{}}
  def tick({:sulfuras, %Item{} = item}) do
    {:sulfuras, item}
  end

  def tick({type, %Item{sell_in: sell_in} = item}) do
    {type, %Item{item | sell_in: sell_in - 1}}
  end

  defp inc_quality(%Item{quality: quality} = item, value) do
    %Item{item | quality: quality + value}
  end

  defp dec_quality(%Item{quality: quality} = item, value) do
    %Item{item | quality: quality - value}
  end

  defp zero_quality(%Item{} = item) do
    %Item{item | quality: 0}
  end
end
