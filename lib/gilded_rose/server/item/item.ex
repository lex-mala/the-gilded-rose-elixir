defprotocol GildedRose.Server.Item do
  @spec age(t) :: t
  def age(item)

  @spec mark_time(t) :: t
  def mark_time(item)
end
