class DashboardController < ApplicationController
  # FIXME: Refactor - use DashboardEntries Model
  before_action :set_objects

  def index
  end

  private
  def set_objects
    @worlds = current_user.worlds.last_updated
    @dashboard_entries = current_user.dashboard_entries
  end
end
