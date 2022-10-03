# == Schema Information
#
# Table name: campaigns
#
#  id          :integer          not null, primary key
#  end_date    :date
#  goal_amount :decimal(8, 2)
#  name        :string           not null
#  start_date  :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Campaign < ApplicationRecord

	has_many :donations
	has_many :donors, through: :donations

  validates :name, presence: true
  validates :goal_amount, numericality: { greater_than: 0, less_than_or_equal_to: 99_999_999.99 }
  validates :start_date, presence: true
  validates :end_date, presence: true

  validate :end_date_is_after_start_date

  def total_donations
    donations.map {|donation| donation.donation_amount }.sum
  end

  private

  def end_date_is_after_start_date
    if (self.start_date.present? && self.end_date.present?)
      if (self.end_date < self.start_date)
        errors.add(:end_date, 'cannot be before the start date')
      end
    end
  end
end
