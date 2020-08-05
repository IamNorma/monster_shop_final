# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
merchant_2 = Merchant.create!(name: 'Jakes Bikes', address: '123 Other St', city: 'Denver', state: 'CO', zip: 80218)

m_user = merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 1)
r_user = User.create(name: 'Jessy', address: '456 Up St', city: 'Denver', state: 'CO', zip: 80001, email: 'jessy@example.com', password: 'securepassword', role: 0)

pen = merchant_1.items.create!(name: 'Pen', description: "Best pen", price: 5, image: 'https://cdn.shopify.com/s/files/1/0013/9676/8815/products/BK90-A_cf6209e2-3d53-4664-98bc-24145e455988_1800x1800.png?v=1541660986', active: true, inventory: 50 )
paper_clip = merchant_1.items.create!(name: 'Paper clip', description: "Will nicely clip your papers", price: 8, image: 'https://s3-eu-west-1.amazonaws.com/media.santu.com/3721/Paperclip_13500134721277.jpg', active: true, inventory: 25 )
tack = merchant_1.items.create!(name: 'Thumbtack', description: "Best tack out there", price: 3, image: 'https://atlas-content1-cdn.pixelsquid.com/assets_v2/167/1671771775815391115/jpeg-600/G03.jpg', active: true, inventory: 25 )
tire = merchant_2.items.create!(name: 'Tire', description: "Great for rough terrain", price: 20, image: 'https://www.rei.com/media/522a2bbc-ef7b-4945-a7ac-53bf7dff22e4?size=784x588', active: true, inventory: 25 )

discount1 = merchant_1.discounts.create!(name: "15% off 5 or more items", discount_percentage: 15, minimum_quantity: 5)
discount2 = merchant_1.discounts.create!(name: "50% off 15 or more items", discount_percentage: 50, minimum_quantity: 15)

megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
