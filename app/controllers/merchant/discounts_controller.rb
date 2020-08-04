class Merchant::DiscountsController < Merchant::BaseController
  def new

  end

  def create
    merchant = current_user.merchant
    discount = merchant.discounts.new(discount_params)
    if discount.save
      redirect_to "/merchant/discounts"
    else
      flash[:error] = discount.errors.full_messages.to_sentence
      redirect_to "/merchant/discounts/new"
    end
  end

  def index
    @merchant = current_user.merchant
  end

  private

  def discount_params
    params.permit(:name, :discount_percentage, :minimum_quantity)
  end
end
