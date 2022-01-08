defmodule GildedRose.Server do
  alias __MODULE__
  alias GildedRose.Item, as: LegacyItem
  alias GildedRose.Server.Item.{Backstage, Basic, Brie, Conjured, Sulfuras}
  use GenServer

  def start_link(items) do
    GenServer.start_link(__MODULE__, items)
  end

  def items(pid) do
    GenServer.call(pid, :items)
  end

  def update(pid) do
    GenServer.cast(pid, :update)
  end

  def init(items) do
    {:ok, Enum.map(items, &identify/1)}
  end

  def handle_call(:items, _, items) do
    {:reply, Enum.map(items, &Map.get(&1, :item)), items}
  end

  def handle_cast(:update, items) do
    {:noreply, items |> Enum.map(&Server.Item.age/1) |> Enum.map(&Server.Item.mark_time/1)}
  end

  defp identify(%LegacyItem{name: name} = item) do
    token = name |> String.downcase() |> String.trim()

    cond do
      String.contains?(token, "backstage") -> %Backstage{item: item}
      String.contains?(token, "aged brie") -> %Brie{item: item}
      String.contains?(token, "conjured") -> %Conjured{item: item}
      String.contains?(token, "sulfuras") -> %Sulfuras{item: item}
      true -> %Basic{item: item}
    end
  end
end
