defmodule GildedRose.Time do
  alias GildedRose.Item

  @type item_type :: :basic | :conjured

  @spec tick({item_type(), %Item{}}) :: {item_type(), %Item{}}
  def tick({:sulfuras, %Item{} = item}) do
    {:sulfuras, item}
  end

  def tick({type, %Item{sell_in: sell_in} = item}) do
    {type, %Item{item | sell_in: sell_in - 1}}
  end

  @spec weather({item_type(), %Item{}}) :: {item_type(), %Item{}}
  def weather({:backstage, %Item{quality: quality, sell_in: sell_in} = item}) when sell_in > 10 do
    {:backstage, %Item{item | quality: quality + 1}}
  end

  def weather({:backstage, %Item{quality: quality, sell_in: sell_in} = item}) when sell_in > 5 do
    {:backstage, %Item{item | quality: quality + 2}}
  end

  def weather({:backstage, %Item{quality: quality, sell_in: sell_in} = item}) when sell_in >= 0 do
    {:backstage, %Item{item | quality: quality + 3}}
  end

  def weather({:backstage, %Item{} = item}) do
    {:backstage, %Item{item | quality: 0}}
  end

  def weather({:basic, %Item{quality: quality} = item}) when quality < 2 do
    {:basic, %Item{item | quality: 0}}
  end

  def weather({:basic, %Item{quality: quality} = item}) do
    {:basic, %Item{item | quality: quality - 1}}
  end

  def weather({:brie, %Item{quality: quality} = item}) when quality < 50 do
    {:brie, %Item{item | quality: quality + 1}}
  end

  def weather({:conjured, %Item{quality: quality} = item}) when quality < 2 do
    {:conjured, %Item{item | quality: 0}}
  end

  def weather({:conjured, %Item{quality: quality, sell_in: sell_in} = item}) when sell_in < 0 do
    {:conjured, %Item{item | quality: quality - 4}}
  end

  def weather({:conjured, %Item{quality: quality} = item}) do
    {:conjured, %Item{item | quality: quality - 2}}
  end

  def weather({type, %Item{} = item}) do
    {type, item}
  end
end
