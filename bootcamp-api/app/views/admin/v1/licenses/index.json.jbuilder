json.licenses do
  json.array! @loading_service.records do |license|
    json.(license, :id, :key)
  end
end

json.meta do
  json.partial! 'shared/pagination', pagination: @loading_service.pagination
end
