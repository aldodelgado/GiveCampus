class CampaignsController < ApplicationController

  expose :campaigns, ->{ Campaign.all }
  expose :campaign

  def create
    if campaign.save
      redirect_to root_path
    else
      render :new
    end
  end

  def update
    if campaign.update(campaign_params)
      redirect_to campaign_path(campaign)
    else
      render :edit
    end
  end

  def destroy
    campaign.destroy
    redirect_to campaigns_path
  end

  private

  def campaign_params
    params.require(:campaign).permit(:name, :goal_amount, :start_date, :end_date)
  end
end
