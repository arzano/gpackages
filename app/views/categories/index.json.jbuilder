json.array!(@categories) do |category|
  json.extract! category, :name
  json.extract! category, :description
  json.url category_url(category, format: :json)
end
