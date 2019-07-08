class DashboardController < ApplicationController
  before_action :set_objects

  def index
  end

  private
  def set_objects
    @worlds = current_user.worlds.last_updated
    @inventories = current_user.inventories.order(updated_at: :desc).limit(15)
  end
end
