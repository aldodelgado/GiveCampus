class DonationsController < ApplicationController

  expose :campaign, -> { Campaign.find(params[:campaign_id]) }
  expose :donations, ->{ campaign.donations }
  expose :donation, attributes: :donation_params

  def create
    if campaign.donations.create(donation_params)
      redirect_to root_path
    else
      render :new
    end
  end

  def update
    if donation.update(donation_params)
      redirect_to donation_path(donation)
    else
      render :edit
    end
  end

  def destroy
    donation.destroy
    redirect_to donations_path
  end

  private

  def donation_params
    params.require(:donation).permit(
      :amount,
      :kind,
      :match_max_amount,
      :match_amount,
      donor_attributes: [
        :id,
        :first_name,
        :last_name,
        :email
      ]
    )
  end
end
