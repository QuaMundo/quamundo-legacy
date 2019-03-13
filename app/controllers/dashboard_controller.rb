class DashboardController < ApplicationController
  before_action :set_objects

  def index
  end

  private
  def set_objects
    @worlds = current_user.worlds.last_updated
    # FIXME: This orders first by world and second by updated_at!
    @figures = current_user.figures.last_updated
  end
end
