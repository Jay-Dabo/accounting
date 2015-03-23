class ClosingForm < Reform::Form
  # include Reform::Form::ActiveModel

  # model :balance_sheet, on: :balance_sheet

  property :balance_sheet do
  	property :balance_year, from: :year, validates: {presence: true}
  	property :firm_balance, from: :firm_id, validates: {presence: true}
  end

  property :income_statement do
  	property :statement_year, from: :year, validates: {presence: true}
  	property :firm_statement, from: :firm_id, validates: {presence: true}
  end

  property :cash_flow do
  	property :flow_year, from: :year, validates: {presence: true}
  	property :firm_flow, from: :firm_id, validates: {presence: true}
  end

end