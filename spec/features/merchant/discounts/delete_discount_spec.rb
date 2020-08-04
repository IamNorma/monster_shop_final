require 'rails_helper'

RSpec.describe 'Destroy a Discount' do
  describe 'As a merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 1)
      @discount1 = @merchant_1.discounts.create!(name: "15% off 10 or more items", discount_percentage: 15, minimum_quantity: 10)
      @discount2 = @merchant_1.discounts.create!(name: "50% off 100 or more items", discount_percentage: 50, minimum_quantity: 100)
      visit "/login"
      fill_in :email, with: @m_user.email
      fill_in :password, with: @m_user.password
      click_button "Log In"
    end

    it 'I can delete a discount' do
      visit "/merchant/discounts"

      expect(page).to have_content(@discount1.name)
      expect(page).to have_content(@discount2.name)

      within "#discount-#{@discount2.id}" do
        click_on 'Delete Discount'
      end

      expect(current_path).to eq("/merchant/discounts")
      expect(page).to have_content(@discount1.name)
      expect(page).to_not have_content(@discount2.name)
    end
  end
end
