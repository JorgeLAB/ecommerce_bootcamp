json.featured do
  json.array! @loader_service.featured, partial: "product", as: :product
end

json.last_releases do
  json.array! @loader_service.last_releases, partial: "product", as: :product
end

json.cheapest do
  json.array! @loader_service.cheapest, partial: "product", as: :product
end
