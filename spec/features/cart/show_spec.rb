require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Cart Show Page' do
  describe 'As a Visitor' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
    end

    describe 'I can see my cart' do
      it "I can visit a cart show page to see items in my cart" do
        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'

        visit '/cart'

        expect(page).to have_content("Total: #{number_to_currency((@ogre.price * 1) + (@hippo.price * 2))}")

        within "#item-#{@ogre.id}" do
          expect(page).to have_link(@ogre.name)
          expect(page).to have_content("Price: #{number_to_currency(@ogre.price)}")
          expect(page).to have_content("Quantity: 1")
          expect(page).to have_content("Subtotal: #{number_to_currency(@ogre.price * 1)}")
          expect(page).to have_content("Sold by: #{@megan.name}")
          expect(page).to have_css("img[src*='#{@ogre.image}']")
          expect(page).to have_link(@megan.name)
        end

        within "#item-#{@hippo.id}" do
          expect(page).to have_link(@hippo.name)
          expect(page).to have_content("Price: #{number_to_currency(@hippo.price)}")
          expect(page).to have_content("Quantity: 2")
          expect(page).to have_content("Subtotal: #{number_to_currency(@hippo.price * 2)}")
          expect(page).to have_content("Sold by: #{@brian.name}")
          expect(page).to have_css("img[src*='#{@hippo.image}']")
          expect(page).to have_link(@brian.name)
        end
      end

      it "I can visit an empty cart page" do
        visit '/cart'

        expect(page).to have_content('Your Cart is Empty!')
        expect(page).to_not have_button('Empty Cart')
      end
    end

    describe 'I can manipulate my cart' do
      it 'I can empty my cart' do
        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'

        visit '/cart'

        click_button 'Empty Cart'

        expect(current_path).to eq('/cart')
        expect(page).to have_content('Your Cart is Empty!')
        expect(page).to have_content('Cart: 0')
        expect(page).to_not have_button('Empty Cart')
      end

      it 'I can remove one item from my cart' do
        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'

        visit '/cart'

        within "#item-#{@hippo.id}" do
          click_button('Remove')
        end

        expect(current_path).to eq('/cart')
        expect(page).to_not have_content("#{@hippo.name}")
        expect(page).to have_content('Cart: 1')
        expect(page).to have_content("#{@ogre.name}")
      end

      it 'I can add quantity to an item in my cart' do
        visit item_path(@ogre)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'

        visit '/cart'

        within "#item-#{@hippo.id}" do
          click_button('More of This!')
        end

        expect(current_path).to eq('/cart')
        within "#item-#{@hippo.id}" do
          expect(page).to have_content('Quantity: 3')
        end
      end

      it 'I can not add more quantity than the items inventory' do
        visit item_path(@hippo)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'

        visit '/cart'

        within "#item-#{@hippo.id}" do
          expect(page).to_not have_button('More of This!')
        end

        visit "/items/#{@hippo.id}"

        click_button 'Add to Cart'

        expect(page).to have_content("You have all the item's inventory in your cart already!")
      end

      it 'I can reduce the quantity of an item in my cart' do
        visit item_path(@hippo)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'
        visit item_path(@hippo)
        click_button 'Add to Cart'

        visit '/cart'

        within "#item-#{@hippo.id}" do
          click_button('Less of This!')
        end

        expect(current_path).to eq('/cart')
        within "#item-#{@hippo.id}" do
          expect(page).to have_content('Quantity: 2')
        end
      end

      it 'if I reduce the quantity to zero, the item is removed from my cart' do
        visit item_path(@hippo)
        click_button 'Add to Cart'

        visit '/cart'

        within "#item-#{@hippo.id}" do
          click_button('Less of This!')
        end

        expect(current_path).to eq('/cart')
        expect(page).to_not have_content("#{@hippo.name}")
        expect(page).to have_content("Cart: 0")
      end

      it 'if I add enough quantity of a single item to my cart the bulk discount will show up' do
        merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
        r_user = User.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 0)
        pen = merchant_1.items.create!(name: 'Pen', description: "Best pen", price: 5, image: 'https://cdn.shopify.com/s/files/1/0013/9676/8815/products/BK90-A_cf6209e2-3d53-4664-98bc-24145e455988_1800x1800.png?v=1541660986', active: true, inventory: 50 )
        paper_clip = merchant_1.items.create!(name: 'Paper clip', description: "Will nicely clip your papers", price: 8, image: 'https://s3-eu-west-1.amazonaws.com/media.santu.com/3721/Paperclip_13500134721277.jpg', active: true, inventory: 25 )
        discount1 = merchant_1.discounts.create!(name: "15% off 5 or more items", discount_percentage: 15, minimum_quantity: 5)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(r_user)

        visit "items/#{pen.id}"
        click_button 'Add to Cart'

        visit "items/#{paper_clip.id}"
        click_button 'Add to Cart'

        visit '/cart'

        within "#item-#{pen.id}" do
          click_button('More of This!')
          click_button('More of This!')
          click_button('More of This!')
          click_button('More of This!')
        end

        within "#item-#{paper_clip.id}" do
          click_button('More of This!')
        end

        expect(current_path).to eq('/cart')

        within "#item-#{pen.id}" do
          expect(page).to have_content("Subtotal: $21.25 with discount")
        end

        within "#item-#{paper_clip.id}" do
          expect(page).to have_content("Subtotal: $16.00")
        end

        expect(page).to have_content("Total: $37.25")
      end

      it 'a bulk discount from one merchant will only affect items from that merchant in the cart' do
        merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
        merchant_2 = Merchant.create!(name: 'Jakes Bikes', address: '123 Other St', city: 'Denver', state: 'CO', zip: 80218)
        r_user = User.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 0)
        pen = merchant_1.items.create!(name: 'Pen', description: "Best pen", price: 5, image: 'https://cdn.shopify.com/s/files/1/0013/9676/8815/products/BK90-A_cf6209e2-3d53-4664-98bc-24145e455988_1800x1800.png?v=1541660986', active: true, inventory: 50 )
        paper_clip = merchant_1.items.create!(name: 'Paper clip', description: "Will nicely clip your papers", price: 8, image: 'https://s3-eu-west-1.amazonaws.com/media.santu.com/3721/Paperclip_13500134721277.jpg', active: true, inventory: 25 )
        tack = merchant_1.items.create!(name: 'Thumbtack', description: "Best tack out there", price: 3, image: 'https://atlas-content1-cdn.pixelsquid.com/assets_v2/167/1671771775815391115/jpeg-600/G03.jpg', active: true, inventory: 25 )
        tire = merchant_2.items.create!(name: 'Tire', description: "Great for rough terrain", price: 20, image: 'https://www.rei.com/media/522a2bbc-ef7b-4945-a7ac-53bf7dff22e4?size=784x588', active: true, inventory: 25 )
        discount1 = merchant_1.discounts.create!(name: "15% off 5 or more items", discount_percentage: 15, minimum_quantity: 5)
        discount2 = merchant_1.discounts.create!(name: "50% off 15 or more items", discount_percentage: 50, minimum_quantity: 15)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(r_user)

        visit "items/#{pen.id}"
        click_button 'Add to Cart'

        visit "items/#{tire.id}"
        click_button 'Add to Cart'

        visit '/cart'

        within "#item-#{pen.id}" do
          click_button('More of This!')
          click_button('More of This!')
          click_button('More of This!')
          click_button('More of This!')
        end

        within "#item-#{tire.id}" do
          15.times { click_button('More of This!') }
        end

        expect(current_path).to eq('/cart')

        within "#item-#{pen.id}" do
          expect(page).to have_content("Subtotal: $21.25 with discount")
        end

        within "#item-#{tire.id}" do
          expect(page).to have_content("Subtotal: $320.00")
        end

        expect(page).to have_content("Total: $341.25")
      end

      it 'A bulk discount will only apply to items which exceed the minimum quantity specified in the bulk discount' do
        merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
        r_user = User.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 0)

        pen = merchant_1.items.create!(name: 'Pen', description: "Best pen", price: 5, image: 'https://cdn.shopify.com/s/files/1/0013/9676/8815/products/BK90-A_cf6209e2-3d53-4664-98bc-24145e455988_1800x1800.png?v=1541660986', active: true, inventory: 50 )
        paper_clip = merchant_1.items.create!(name: 'Paper clip', description: "Will nicely clip your papers", price: 8, image: 'https://s3-eu-west-1.amazonaws.com/media.santu.com/3721/Paperclip_13500134721277.jpg', active: true, inventory: 25 )
        tack = merchant_1.items.create!(name: 'Thumbtack', description: "Best tack out there", price: 3, image: 'https://atlas-content1-cdn.pixelsquid.com/assets_v2/167/1671771775815391115/jpeg-600/G03.jpg', active: true, inventory: 25 )
        tire = merchant_1.items.create!(name: 'Tire', description: "Great for rough terrain", price: 20, image: 'https://www.rei.com/media/522a2bbc-ef7b-4945-a7ac-53bf7dff22e4?size=784x588', active: true, inventory: 25 )
        stapler = merchant_1.items.create!(name: 'Stapler', description: "It can staple up to 50 papers together", price: 15, image: 'https://rendering.documents.cimpress.io/v1/columbus/preview?&scene=https%3A%2F%2Fscene.products.cimpress.io%2Fv1%2Fscenes%2Fab8ad720-7425-421d-8045-4fe9b7ee0bf6&width=535', active: true, inventory: 30 )

        discount1 = merchant_1.discounts.create!(name: "15% off 5 or more items", discount_percentage: 15, minimum_quantity: 5)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(r_user)

        visit "items/#{pen.id}"
        click_button 'Add to Cart'

        visit "items/#{paper_clip.id}"
        click_button 'Add to Cart'

        visit "items/#{tack.id}"
        click_button 'Add to Cart'

        visit "items/#{tire.id}"
        click_button 'Add to Cart'

        visit "items/#{stapler.id}"
        click_button 'Add to Cart'

        visit '/cart'

        within "#item-#{pen.id}" do
          expect(page).to have_content("Subtotal: $5.00")
        end

        within "#item-#{paper_clip.id}" do
          expect(page).to have_content("Subtotal: $8")
        end

        within "#item-#{tack.id}" do
          expect(page).to have_content("Subtotal: $3.00")
        end

        within "#item-#{tire.id}" do
          expect(page).to have_content("Subtotal: $20.00")
        end

        within "#item-#{stapler.id}" do
          expect(page).to have_content("Subtotal: $15.00")
        end

        within "#item-#{tack.id}" do
          5.times { click_button('More of This!') }
          expect(page).to have_content("Discount: -$2.70")
        end
      end

      it 'When there is a conflict between discounts, the greater of the two will be applied' do
        merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
        r_user = User.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 0)
        pen = merchant_1.items.create!(name: 'Pen', description: "Best pen", price: 5, image: 'https://cdn.shopify.com/s/files/1/0013/9676/8815/products/BK90-A_cf6209e2-3d53-4664-98bc-24145e455988_1800x1800.png?v=1541660986', active: true, inventory: 50 )
        discount1 = merchant_1.discounts.create!(name: "15% off 5 or more items", discount_percentage: 15, minimum_quantity: 5)
        discount2 = merchant_1.discounts.create!(name: "50% off 15 or more items", discount_percentage: 50, minimum_quantity: 15)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(r_user)

        visit "items/#{pen.id}"
        click_button 'Add to Cart'

        visit '/cart'

        within "#item-#{pen.id}" do
          16.times { click_button('More of This!') }
        end

        within "#item-#{pen.id}" do
          expect(page).to have_content("Discount: -$42.50")
          expect(page).to have_content("Subtotal: $42.50 with discount")
        end
      end 
    end
  end
end
