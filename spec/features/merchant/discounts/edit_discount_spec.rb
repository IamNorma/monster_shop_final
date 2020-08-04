require 'rails_helper'

RSpec.describe 'Update Merchant Discount' do
  describe 'As a Merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @discount1 = @merchant_1.discounts.create!(name: "15% off 10 or more items", discount_percentage: 15, minimum_quantity: 10)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'I can click a link to get to a discount edit page' do
      visit "/merchant/discounts"

      click_link 'Update Discount'

      expect(current_path).to eq("/merchant/discounts/#{@discount1.id}/edit")
    end
  end
end
