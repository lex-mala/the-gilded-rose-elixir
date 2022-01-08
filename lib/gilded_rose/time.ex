defmodule GildedRose.Time do
  alias GildedRose.Item

  @type item_type :: :basic | :conjured

  @spec pass({item_type(), %Item{}}) :: {item_type(), %Item{}}
  def pass({:backstage, %Item{quality: quality, sell_in: sell_in} = item}) when sell_in > 10 do
    {:backstage, %Item{item | quality: quality + 1, sell_in: sell_in - 1}}
  end

  def pass({:backstage, %Item{quality: quality, sell_in: sell_in} = item}) when sell_in > 5 do
    {:backstage, %Item{item | quality: quality + 2, sell_in: sell_in - 1}}
  end

  def pass({:backstage, %Item{quality: quality, sell_in: sell_in} = item}) when sell_in >= 0 do
    {:backstage, %Item{item | quality: quality + 3, sell_in: sell_in - 1}}
  end

  def pass({:backstage, %Item{sell_in: sell_in} = item}) do
    {:backstage, %Item{item | quality: 0, sell_in: sell_in - 1}}
  end

  def pass({:basic, %Item{quality: quality, sell_in: sell_in} = item}) when quality < 2 do
    {:basic, %Item{item | quality: 0, sell_in: sell_in - 1}}
  end

  def pass({:basic, %Item{quality: quality, sell_in: sell_in} = item}) do
    {:basic, %Item{item | quality: quality - 1, sell_in: sell_in - 1}}
  end

  def pass({:brie, %Item{quality: quality, sell_in: sell_in} = item}) when quality < 50 do
    {:brie, %Item{item | quality: quality + 1, sell_in: sell_in - 1}}
  end

  def pass({:brie, %Item{sell_in: sell_in} = item}) do
    {:brie, %Item{item | sell_in: sell_in - 1}}
  end

  def pass({:conjured, %Item{quality: quality, sell_in: sell_in} = item}) when quality < 2 do
    {:conjured, %Item{item | quality: 0, sell_in: sell_in - 1}}
  end

  def pass({:conjured, %Item{quality: quality, sell_in: sell_in} = item}) when sell_in < 0 do
    {:conjured, %Item{item | quality: quality - 4, sell_in: sell_in - 1}}
  end

  def pass({:conjured, %Item{quality: quality, sell_in: sell_in} = item}) do
    {:conjured, %Item{item | quality: quality - 2, sell_in: sell_in - 1}}
  end

  def pass({:sulfuras, %Item{} = item}) do
    {:sulfuras, item}
  end
end
