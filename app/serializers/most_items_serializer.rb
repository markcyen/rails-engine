class MostItemsSerializer
  include JSONAPI::Serializer

  set_type :items_sold
  attributes :name, :count
end
