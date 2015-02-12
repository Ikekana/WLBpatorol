json.array!(@emps) do |emp|
  json.extract! emp, :id, :code, :name
  json.url emp_url(emp, format: :json)
end
