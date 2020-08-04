class Discount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :name, :discount_percentage, :minimum_quantity
end
