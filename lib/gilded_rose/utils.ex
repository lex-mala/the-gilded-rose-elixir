defmodule GildedRose.Utils do
  alias GildedRose.Item

  def dec_sell_in(%Item{sell_in: sell_in} = item) do
    %Item{item | sell_in: sell_in - 1}
  end

  def inc_quality(%Item{quality: quality} = item, value) do
    %Item{item | quality: quality + value}
  end

  def dec_quality(%Item{quality: quality} = item, value) do
    %Item{item | quality: quality - value}
  end

  def zero_quality(%Item{} = item) do
    %Item{item | quality: 0}
  end
end
