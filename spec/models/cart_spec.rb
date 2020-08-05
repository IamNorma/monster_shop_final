require 'rails_helper'

RSpec.describe Cart do
  describe 'Instance Methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 2 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @cart = Cart.new({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2
        })
    end

    it '.contents' do
      expect(@cart.contents).to eq({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2
        })
    end

    it '.add_item()' do
      @cart.add_item(@hippo.id.to_s)

      expect(@cart.contents).to eq({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2,
        @hippo.id.to_s => 1
        })
    end

    it '.count' do
      expect(@cart.count).to eq(3)
    end

    it '.items' do
      expect(@cart.items).to eq([@ogre, @giant])
    end

    it '.grand_total' do
      expect(@cart.grand_total).to eq(120)
    end

    it '.count_of()' do
      expect(@cart.count_of(@ogre.id)).to eq(1)
      expect(@cart.count_of(@giant.id)).to eq(2)
    end

    it '.subtotal_of()' do
      expect(@cart.subtotal_of(@ogre.id)).to eq(20)
      expect(@cart.subtotal_of(@giant.id)).to eq(100)
    end

    it '.limit_reached?()' do
      expect(@cart.limit_reached?(@ogre.id)).to eq(false)
      expect(@cart.limit_reached?(@giant.id)).to eq(true)
    end

    it '.less_item()' do
      @cart.less_item(@giant.id.to_s)

      expect(@cart.count_of(@giant.id)).to eq(1)
    end

    it '.has_discount?()' do
      merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      merchant_2 = Merchant.create!(name: 'Jakes Bikes', address: '123 Other St', city: 'Denver', state: 'CO', zip: 80218)
      r_user = User.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 0)
      pen = merchant_1.items.create!(name: 'Pen', description: "Best pen", price: 5, image: 'https://cdn.shopify.com/s/files/1/0013/9676/8815/products/BK90-A_cf6209e2-3d53-4664-98bc-24145e455988_1800x1800.png?v=1541660986', active: true, inventory: 50 )
      paper_clip = merchant_1.items.create!(name: 'Paper clip', description: "Will nicely clip your papers", price: 8, image: 'https://s3-eu-west-1.amazonaws.com/media.santu.com/3721/Paperclip_13500134721277.jpg', active: true, inventory: 25 )
      tack = merchant_1.items.create!(name: 'Thumbtack', description: "Best tack out there", price: 3, image: 'https://atlas-content1-cdn.pixelsquid.com/assets_v2/167/1671771775815391115/jpeg-600/G03.jpg', active: true, inventory: 25 )
      tire = merchant_2.items.create!(name: 'Tire', description: "Great for rough terrain", price: 20, image: 'https://www.rei.com/media/522a2bbc-ef7b-4945-a7ac-53bf7dff22e4?size=784x588', active: true, inventory: 25 )
      discount1 = merchant_1.discounts.create!(name: "15% off 5 or more items", discount_percentage: 15, minimum_quantity: 5)
      discount2 = merchant_1.discounts.create!(name: "50% off 15 or more items", discount_percentage: 50, minimum_quantity: 15)
      cart2 = Cart.new({
        tire.id.to_s => 6,
        pen.id.to_s => 5,
        paper_clip.id.to_s => 2,
        tack.id.to_s => 16
        })

      expect(cart2.has_discount?(tire.id)).to eq(false)
      expect(cart2.has_discount?(tack.id)).to eq(true)
      expect(cart2.has_discount?(pen.id)).to eq(true)
      expect(cart2.has_discount?(paper_clip.id)).to eq(false)
    end
  end
end
