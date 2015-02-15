json.array!(@income_statements_controllers) do |income_statements_controller|
  json.extract! income_statements_controller, :id
  json.url income_statements_controller_url(income_statements_controller, format: :json)
end
