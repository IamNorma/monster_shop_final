class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.string :name
      t.integer :discount_percentage
      t.integer :minimum_quantity
      t.references :merchant

      t.timestamps
    end
  end
end
