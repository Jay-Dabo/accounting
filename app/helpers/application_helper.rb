module ApplicationHelper
  def title(value)
    unless value.nil?
      @title = "#{value} | Accounting"
    end
  end
end
