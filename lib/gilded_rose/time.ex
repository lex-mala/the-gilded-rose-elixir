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

  def pass({:basic, %Item{} = item}) do
    item =
      cond do
        item.name != "Aged Brie" && item.name != "Backstage passes to a TAFKAL80ETC concert" ->
          if item.quality > 0 do
            if item.name != "Sulfuras, Hand of Ragnaros" do
              %{item | quality: item.quality - 1}
            else
              item
            end
          else
            item
          end

        true ->
          cond do
            item.quality < 50 ->
              item = %{item | quality: item.quality + 1}

              cond do
                item.name == "Backstage passes to a TAFKAL80ETC concert" ->
                  item =
                    cond do
                      item.sell_in < 11 ->
                        cond do
                          item.quality < 50 ->
                            %{item | quality: item.quality + 1}

                          true ->
                            item
                        end

                      true ->
                        item
                    end

                  cond do
                    item.sell_in < 6 ->
                      cond do
                        item.quality < 50 ->
                          %{item | quality: item.quality + 1}

                        true ->
                          item
                      end

                    true ->
                      item
                  end

                true ->
                  item
              end

            true ->
              item
          end
      end

    item =
      cond do
        item.name != "Sulfuras, Hand of Ragnaros" ->
          %{item | sell_in: item.sell_in - 1}

        true ->
          item
      end

    item =
      cond do
        item.sell_in < 0 ->
          cond do
            item.name != "Aged Brie" ->
              cond do
                item.name != "Backstage passes to a TAFKAL80ETC concert" ->
                  cond do
                    item.quality > 0 ->
                      cond do
                        item.name != "Sulfuras, Hand of Ragnaros" ->
                          %{item | quality: item.quality - 1}

                        true ->
                          item
                      end

                    true ->
                      item
                  end

                true ->
                  %{item | quality: item.quality - item.quality}
              end

            true ->
              cond do
                item.quality < 50 ->
                  %{item | quality: item.quality + 1}

                true ->
                  item
              end
          end

        true ->
          item
      end

    {:basic, item}
  end
end
