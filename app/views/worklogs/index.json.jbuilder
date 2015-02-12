json.array!(@worklogs) do |worklog|
  json.extract! worklog, :id, :dept_id, :emp_id, :workday, :holiday, :worktype, :rc_start, :wk_start, :wk_end, :rc_end, :rest, :reason, :comment, :check
  json.url worklog_url(worklog, format: :json)
end
