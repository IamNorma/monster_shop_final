require 'rails_helper'

RSpec.describe 'New Merchant Discount' do
  describe 'As a Merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'I can click a link to a new discount form page' do
      visit "/merchant"

      click_link 'Create New Discount'

      expect(current_path).to eq("/merchant/discounts/new")
    end

    it 'I can create a new discount by filling out a form' do
      name = "15% off 10 or more items"
      discount = 15
      quantity = 10

      visit "/merchant/discounts/new"

      fill_in :name, with: name
      fill_in :discount_percentage, with: discount
      fill_in :minimum_quantity, with: quantity
      click_button "Create Discount"

      expect(current_path).to eq("/merchant/discounts")
      expect(page).to have_content(name)
    end
  end
end
