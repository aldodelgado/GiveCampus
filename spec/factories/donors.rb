# == Schema Information
#
# Table name: donors
#
#  id         :integer          not null, primary key
#  email      :string           not null
#  first_name :string           not null
#  last_name  :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :donor do
    first_name { Faker::Name.first_name  }
    last_name { Faker::Name.last_name  }
    email { Faker::Internet.email }
  end
end
