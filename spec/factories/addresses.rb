# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address do
    address {Faker::Address.street_name}
    zipcode {Faker::Address.zip_code}
    city {Faker::Address.city}
    phone {Faker::PhoneNumber.phone_number}
    country nil
  end

  factory :bill_address, :parent => :address, :class => 'BillAddress' do
  end
  factory :ship_address, :parent => :address, :class => 'ShipAddress' do
  end
  factory :customer_bill_address, :parent => :address, :class => 'CustomerBillAddress' do
  end
  factory :customer_ship_address, :parent => :address, :class => 'CustomerShipAddress' do
  end
end
