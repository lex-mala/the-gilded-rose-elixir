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
    {:noreply, Enum.map(items, &Time.pass/1)}
  end

  defp identify(%Item{name: name} = item) do
    if name |> String.downcase() |> String.contains?("conjured") do
      {:conjured, item}
    else
      {:basic, item}
    end
  end
end