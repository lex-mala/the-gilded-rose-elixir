defmodule GildedRose.ServerTest do
  alias GildedRose.{Item, Server}
  use ExUnit.Case

  test "items/1" do
    {name, sell_in, quality} = {"Bruce Lee's Sunglasses", 0, 134_217_728}
    item = Item.new(name, sell_in, quality)
    server = start_supervised!({Server, [item]})
    assert [%Item{name: ^name, sell_in: ^sell_in, quality: ^quality}] = Server.items(server)
  end

  describe "update/1 with Aged Brie" do
    setup do
      [name: "Aged Brie"]
    end

    test "in normal conditions", %{name: name} do
      item = Item.new(name, 5, 3)
      server = start_supervised!({Server, [item]})
      :ok = Server.update(server)
      assert [{:basic, %Item{name: ^name, quality: 4, sell_in: 4}}] = :sys.get_state(server)
    end

    test "when approaching 50 quality", %{name: name} do
      item = Item.new(name, 5, 50)
      server = start_supervised!({Server, [item]})
      :ok = Server.update(server)
      assert [{:basic, %Item{name: ^name, quality: 50, sell_in: 4}}] = :sys.get_state(server)
    end
  end

  describe "update/1 with a Conjured Item" do
    setup do
      [name: "Conjured boxing gloves"]
    end

    test "in normal conditions", %{name: name} do
      item = Item.new(name, 5, 3)
      server = start_supervised!({Server, [item]})
      :ok = Server.update(server)
      assert [{:conjured, %Item{name: ^name, quality: 1, sell_in: 4}}] = :sys.get_state(server)
    end

    test "when approaching 0 quality", %{name: name} do
      item = Item.new(name, 5, 1)
      server = start_supervised!({Server, [item]})
      :ok = Server.update(server)
      assert [{:conjured, %Item{name: ^name, quality: 0, sell_in: 4}}] = :sys.get_state(server)
    end

    test "when spoiled", %{name: name} do
      item = Item.new(name, -2, 10)
      server = start_supervised!({Server, [item]})
      :ok = Server.update(server)
      assert [{:conjured, %Item{name: ^name, quality: 6, sell_in: -3}}] = :sys.get_state(server)
    end
  end

  describe "update/1 with Sulfuras" do
    test "in normal conditions", %{name: name} do
      name = "Sulfuras, Hand of Ragnaros"
      item = Item.new(name, 0, 1)
      server = start_supervised!({Server, [item]})
      :ok = Server.update(server)
      assert [{:basic, %Item{name: ^name, quality: 1, sell_in: 0}}] = :sys.get_state(server)
    end
  end
end
