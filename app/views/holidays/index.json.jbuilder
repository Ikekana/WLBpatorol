json.array!(@holidays) do |holiday|
  json.extract! holiday, :id, :holidaydate, :year, :comment
  json.url holiday_url(holiday, format: :json)
end
