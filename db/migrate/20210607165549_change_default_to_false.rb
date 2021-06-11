# frozen_string_literal: true

class ChangeDefaultToFalse < ActiveRecord::Migration[5.2]
  def change
    change_column_default :merchants, :enabled, from: true, to: false
  end
end
