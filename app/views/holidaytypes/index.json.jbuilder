json.array!(@holidaytypes) do |holidaytype|
  json.extract! holidaytype, :id, :name
  json.url holidaytype_url(holidaytype, format: :json)
end
