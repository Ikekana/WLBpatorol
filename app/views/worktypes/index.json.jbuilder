json.array!(@worktypes) do |worktype|
  json.extract! worktype, :id, :name
  json.url worktype_url(worktype, format: :json)
end
