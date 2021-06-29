# frozen_string_literal: true

module ApplicationHelper
  def currency(number)
    (number / 100.0).round(2)
  end
end
