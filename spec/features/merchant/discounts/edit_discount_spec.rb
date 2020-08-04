require 'rails_helper'

RSpec.describe 'Update Merchant Discount' do
  describe 'As a Merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 1)
      @discount1 = @merchant_1.discounts.create!(name: "15% off 10 or more items", discount_percentage: 15, minimum_quantity: 10)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'I can click a link to get to a discount edit page' do
      visit "/merchant/discounts"

      click_link 'Update Discount'

      expect(current_path).to eq("/merchant/discounts/#{@discount1.id}/edit")
    end

    it 'I can edit the discount information' do
      name = "15% off 8 items or more"
      discount = 15
      quantity = 8

      visit "merchant/discounts/#{@discount1.id}/edit"

      fill_in :name, with: name
      fill_in :discount_percentage, with: discount
      fill_in :minimum_quantity, with: quantity
      click_button 'Update Discount'

      expect(current_path).to eq("/merchant/discounts")
      expect(page).to have_content(name)
      expect(page).to have_content("Discount was successfully updated")
    end

    it 'I can not edit a discount with an incomplete form' do
      name = "15% off 8 items or more"

      visit "merchant/discounts/#{@discount1.id}/edit"

      fill_in :name, with: name
      click_button 'Update Discount'

      expect(page).to have_content("Discount percentage can't be blank")
      expect(page).to have_content("Minimum quantity can't be blank")
      expect(page).to have_button('Update Discount')
    end
  end
end
