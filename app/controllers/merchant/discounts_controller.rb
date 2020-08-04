class Merchant::DiscountsController < Merchant::BaseController
  def new

  end

  def create
    merchant = current_user.merchant
    discount = merchant.discounts.new(discount_params)
    if discount.save
      flash[:success] = "Discount was successfully created"
      redirect_to "/merchant/discounts"
    else
      flash[:error] = discount.errors.full_messages.to_sentence
      redirect_to "/merchant/discounts/new"
    end
  end

  def index
    @merchant = current_user.merchant
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    discount = Discount.find(params[:id])
    if discount.update(discount_params)
      flash[:success] = "Discount was successfully updated"
      redirect_to "/merchant/discounts"
    else
      flash[:error] = discount.errors.full_messages.to_sentence
      redirect_to "/merchant/discounts/#{discount.id}/edit"
    end
  end

  private

  def discount_params
    params.permit(:name, :discount_percentage, :minimum_quantity)
  end
end
