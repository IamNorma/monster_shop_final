require 'rails_helper'

RSpec.describe 'Discount Index Page' do
  describe 'As a Merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_2 = Merchant.create!(name: 'Jake Bikes', address: '123 Other St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 1)
      @discount1 = @merchant_1.discounts.create!(name: "15% off 10 or more items", discount_percentage: 15, minimum_quantity: 10)
      @discount2 = @merchant_1.discounts.create!(name: "50% off 100 or more items", discount_percentage: 50, minimum_quantity: 100)
      @discount3 = @merchant_2.discounts.create!(name: "5% off 1 or more items", discount_percentage: 5, minimum_quantity: 1)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'I can click a link to view all my discounts' do
      visit "/merchant"

      click_link 'View All Your Discounts'

      expect(current_path).to eq("/merchant/discounts")
      expect(page).to have_content(@discount1.name)
      expect(page).to have_content(@discount2.name)
      expect(page).to_not have_content(@discount3.name)
    end
  end
end
