class Merchant::DiscountsController < Merchant::BaseController
  def new

  end

  def create
    merchant = current_user.merchant
    discount = merchant.discounts.new(discount_params)
    if discount.save
      redirect_to "/merchant/discounts"
    else
      generate_flash(discount)
      redirect_to "/merchant/discounts/new"
    end
  end

  private

  def discount_params
    params.permit(:name, :discount_percentage, :minimum_quantity)
  end
end
