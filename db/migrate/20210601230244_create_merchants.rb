# frozen_string_literal: true

class CreateMerchants < ActiveRecord::Migration[5.2]
  def change
    create_table :merchants do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
