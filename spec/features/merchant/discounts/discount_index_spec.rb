require 'rails_helper'

RSpec.describe 'Discount Index Page' do
  describe 'As a Merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @discount1 = @merchant_1.discounts.create!(name: "15% off 10 or more items", discount_percentage: 15, minimum_quantity: 10)
      @discount2 = @merchant_1.discounts.create!(name: "50% off 100 or more items", discount_percentage: 50, minimum_quantity: 100)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'I can click a link to view all my discounts' do
      visit "/merchant"

      click_link 'View All Your Discounts'

      expect(current_path).to eq("/merchant/discounts")
      expect(page).to have_content(@discount1.name)
      expect(page).to have_content(@discount2.name)
    end
  end
end
