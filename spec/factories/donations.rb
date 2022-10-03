# == Schema Information
#
# Table name: donations
#
#  id               :integer          not null, primary key
#  amount           :decimal(8, 2)
#  kind             :integer          default("single"), not null
#  match_amount     :decimal(8, 2)
#  match_max_amount :decimal(8, 2)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  campaign_id      :integer          not null
#  donor_id         :integer          not null
#
# Indexes
#
#  index_donations_on_campaign_id  (campaign_id)
#  index_donations_on_donor_id     (donor_id)
#
# Foreign Keys
#
#  campaign_id  (campaign_id => campaigns.id)
#  donor_id     (donor_id => donors.id)
#
FactoryBot.define do
  factory :donation do

    campaign
    donor
    amount                      { 1.00 }

    trait :match_dollar do
      kind                      { :dollar_match }
      match_amount              { 1.00 }
      match_max_amount          { 100.00 }
    end

    trait :match_donor do
      kind                      { :donor_match }
      match_amount              { 1.00 }
      match_max_amount          { 100.00 }
    end
  end
end
