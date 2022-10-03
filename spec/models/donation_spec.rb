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
require 'rails_helper'

RSpec.describe Donation, type: :model do

  describe "database schema" do
    it { should have_db_column(:id).of_type(:integer) }
    it { should have_db_column(:campaign_id).of_type(:integer) }
    it { should have_db_column(:donor_id).of_type(:integer) }
    it { should have_db_column(:amount).of_type(:decimal) }
    it { should have_db_column(:kind).of_type(:integer) }
    it { should have_db_column(:match_max_amount).of_type(:decimal) }
    it { should have_db_column(:match_amount).of_type(:decimal) }
  end

  describe "association" do
    it { should belong_to(:campaign) }
    it { should belong_to(:donor) }
    it { should accept_nested_attributes_for(:donor) }
  end

  describe "validation" do
    it { should_not allow_value(-0.01).for(:amount) }
    it { should_not allow_value(0).for(:amount) }
    it { should allow_value(0.01).for(:amount) }
    it { should allow_value(99_999_999.99).for(:amount) }
    it { should_not allow_value(100_000_010.00).for(:amount) }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:kind).with_values(single: 0, donor_match: 1, dollar_match: 2) }
  end

  describe "instance methods" do
    describe ".donation_amount" do
      it "match amount not present" do
        donation = FactoryBot.create :donation
        expect(donation.amount).to eq(donation.donation_amount)
      end
      it "returns zero if no other donors" do
        donation_one = FactoryBot.create :donation, :match_dollar
        expect(0).to eq(donation_one.donation_amount)
      end
      it "returns calculated match amount for dollar" do
        donation_one = FactoryBot.create :donation, :match_dollar, amount: 1.0
        FactoryBot.create :donation, campaign: donation_one.campaign
        FactoryBot.create :donation, campaign: donation_one.campaign
        expect(2.0).to eq(donation_one.donation_amount)
      end
      it "returns calculated match amount for dollar who donated after match donation" do
        first_donation = FactoryBot.create :donation, :match_dollar, amount: 1.0
        donation_one = FactoryBot.create :donation, :match_dollar, amount: 1.0, campaign: first_donation.campaign
        FactoryBot.create :donation, campaign: first_donation.campaign, amount: 2.0
        FactoryBot.create :donation, campaign: first_donation.campaign
        expect(3.0).to eq(donation_one.donation_amount)
      end
      it "returns calculated match amount for donor" do
        donation_one = FactoryBot.create :donation, :match_donor, amount: 1.0
        FactoryBot.create :donation, campaign: donation_one.campaign
        FactoryBot.create :donation, campaign: donation_one.campaign
        expect(2.0).to eq(donation_one.donation_amount)
      end
      it "returns calculated match amount for donor who donated after match donation" do
        first_donation = FactoryBot.create :donation, :match_donor, amount: 1.0
        donation_one = FactoryBot.create :donation, :match_donor, amount: 1.0, campaign: first_donation.campaign
        FactoryBot.create :donation, campaign: first_donation.campaign, amount: 2.0
        FactoryBot.create :donation, campaign: first_donation.campaign
        expect(2.0).to eq(donation_one.donation_amount)
      end
    end
  end
end
