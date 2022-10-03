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
class Donation < ApplicationRecord

  belongs_to :campaign
  belongs_to :donor
  accepts_nested_attributes_for :donor, reject_if: :all_blank

  validates :amount, numericality: { greater_than: 0, less_than_or_equal_to: 99_999_999.99 }

  enum kind: %i(single donor_match dollar_match)

  after_commit :create_match_job,
    on: [:create],
    if: Proc.new { self.donor_match? || self.dollar_match?  }

  def create_match_job
    puts "Schedule background job to match"
    # MatchJob.perform_on(self.end_date, id)
  end

  def donation_amount
    donors = campaign.donations.where("created_at > ?", self.created_at)
    if dollar_match?
      calculate_dollor_match(donors: donors)
    elsif donor_match?
      calculate_donor_match(donors: donors)
    else
      amount
    end
  end

  private

  def calculate_dollor_match(donors:)
    calculate_match_or_max(donor_amount: donors.sum(:amount))
  end

  def calculate_donor_match(donors:)
    calculate_match_or_max(donor_amount: donors.count)
  end

  def calculate_match_or_max(donor_amount:)
    total_donation_amount = amount * donor_amount
    if total_donation_amount >= match_max_amount
      match_max_amount
    else
      total_donation_amount
    end
  end

end
