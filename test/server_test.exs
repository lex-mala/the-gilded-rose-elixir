defmodule GildedRose.ServerTest do
  alias GildedRose.{Item, Server}
  alias Server.Item.{Backstage, Brie, Conjured, Sulfuras}
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
      assert [%Brie{item: %Item{name: ^name, quality: 4, sell_in: 4}}] = :sys.get_state(server)
    end

    test "when approaching 50 quality", %{name: name} do
      item = Item.new(name, 5, 50)
      server = start_supervised!({Server, [item]})
      :ok = Server.update(server)
      assert [%Brie{item: %Item{name: ^name, quality: 50, sell_in: 4}}] = :sys.get_state(server)
    end
  end

  describe "update/1 with a Backstage Item" do
    setup do
      [name: "Backstage @ The Knitting Factory"]
    end

    test "12 days out", %{name: name} do
      item = Item.new(name, 12, 2)
      server = start_supervised!({Server, [item]})
      :ok = Server.update(server)

      assert [%Backstage{item: %Item{name: ^name, quality: 3, sell_in: 11}}] =
               :sys.get_state(server)
    end

    test "7 days out", %{name: name} do
      item = Item.new(name, 7, 2)
      server = start_supervised!({Server, [item]})
      :ok = Server.update(server)

      assert [%Backstage{item: %Item{name: ^name, quality: 4, sell_in: 6}}] =
               :sys.get_state(server)
    end

    test "1 day out", %{name: name} do
      item = Item.new(name, 1, 2)
      server = start_supervised!({Server, [item]})
      :ok = Server.update(server)

      assert [%Backstage{item: %Item{name: ^name, quality: 5, sell_in: 0}}] =
               :sys.get_state(server)
    end

    test "after the show", %{name: name} do
      item = Item.new(name, -1, 10)
      server = start_supervised!({Server, [item]})
      :ok = Server.update(server)

      assert [%Backstage{item: %Item{name: ^name, quality: 0, sell_in: -2}}] =
               :sys.get_state(server)
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

      assert [%Conjured{item: %Item{name: ^name, quality: 1, sell_in: 4}}] =
               :sys.get_state(server)
    end

    test "when approaching 0 quality", %{name: name} do
      item = Item.new(name, 5, 1)
      server = start_supervised!({Server, [item]})
      :ok = Server.update(server)

      assert [%Conjured{item: %Item{name: ^name, quality: 0, sell_in: 4}}] =
               :sys.get_state(server)
    end

    test "when spoiled", %{name: name} do
      item = Item.new(name, -2, 10)
      server = start_supervised!({Server, [item]})
      :ok = Server.update(server)

      assert [%Conjured{item: %Item{name: ^name, quality: 6, sell_in: -3}}] =
               :sys.get_state(server)
    end
  end

  describe "update/1 with Sulfuras" do
    test "in normal conditions" do
      name = "Sulfuras, Hand of Ragnaros"
      item = Item.new(name, 0, 1)
      server = start_supervised!({Server, [item]})
      :ok = Server.update(server)

      assert [%Sulfuras{item: %Item{name: ^name, quality: 1, sell_in: 0}}] =
               :sys.get_state(server)
    end
  end
end
