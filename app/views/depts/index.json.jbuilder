json.array!(@depts) do |dept|
  json.extract! dept, :id, :code, :name
  json.url dept_url(dept, format: :json)
end
