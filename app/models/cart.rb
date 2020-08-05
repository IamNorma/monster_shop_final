class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents || {}
    @contents.default = 0
  end

  def add_item(item_id)
    @contents[item_id] += 1
  end

  def less_item(item_id)
    @contents[item_id] -= 1
  end

  def count
    @contents.values.sum
  end

  def items
    @contents.map do |item_id, _|
      Item.find(item_id)
    end
  end

  def grand_total
    grand_total = 0.0
    @contents.each do |item_id, quantity|
      if has_discount?(item_id)
        grand_total += (subtotal_of(item_id) - discount_amount(item_id))
      else
        grand_total += Item.find(item_id).price * quantity
      end
    end
    grand_total
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    @contents[item_id.to_s] * Item.find(item_id).price
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def applicable_discount(item_id)
    item = Item.find(item_id)
    item_quantity = @contents[item_id.to_s]
    applicable_discount = item.merchant.discounts.where('minimum_quantity <= ?', item_quantity).order(:discount_percentage).last
  end
  
  def has_discount?(item_id)
    !applicable_discount(item_id).nil?
  end

  def discount_amount(item_id)
    if !applicable_discount(item_id).nil?
      subtotal_of(item_id) * (applicable_discount(item_id).discount_percentage.to_f / (100))
    end
  end

  def discount_price(item_id)
    if !applicable_discount(item_id).nil?
      Item.find(item_id).price * (applicable_discount(item_id).discount_percentage.to_f / (100))
    else
      0
    end
  end
end
