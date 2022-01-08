defprotocol GildedRose.Server.Item do
  alias GildedRose.Item

  @spec age(t) :: t
  def age(item)

  @spec mark_time(t) :: t
  def mark_time(item)
end

defimpl GildedRose.Server.Item, for: Any do
  alias GildedRose.Item
  alias Item.Ops

  def age(%{item: %Item{}} = type) do
    type
  end

  def mark_time(%{item: %Item{} = item} = type) do
    %{type | item: Ops.dec_sell_in(item)}
  end
end
