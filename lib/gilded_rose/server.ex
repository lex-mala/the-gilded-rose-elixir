defmodule GildedRose.Server do
  alias GildedRose.{Item, Time}
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
    {:reply, Enum.map(items, &elem(&1, 1)), items}
  end

  def handle_cast(:update, items) do
    {:noreply, items |> Enum.map(&Time.weather/1) |> Enum.map(&Time.tick/1)}
  end

  defp identify(%Item{name: name} = item) do
    token = name |> String.downcase() |> String.trim()

    type =
      cond do
        String.contains?(token, "backstage") -> :backstage
        String.contains?(token, "aged brie") -> :brie
        String.contains?(token, "conjured") -> :conjured
        String.contains?(token, "sulfuras") -> :sulfuras
        true -> :basic
      end

    {type, item}
  end
end
