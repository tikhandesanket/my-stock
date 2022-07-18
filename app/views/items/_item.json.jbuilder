json.extract! item, :id, :name, :weight, :price, :state, :created_at, :updated_at
json.url item_url(item, format: :json)
