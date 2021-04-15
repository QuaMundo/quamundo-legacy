# frozen_string_literal: true

module WorldAssociationController
  extend ActiveSupport::Concern

  included do
    rescue_from ActionPolicy::Unauthorized do |_ex|
      # FIXME: Fix error handling (redmine #530)
      # flash[:alert] = ex.result.reason.full_messages
      flash[:alert] = t('not_allowed')
      redirect_to worlds_path
    end

    before_action :set_world

    authorize :world, through: :current_world

    private

    def current_world
      @world
    end
  end

  def set_world
    @world = World
             .includes(:permissions)
             .find_by(slug: params[:world_slug])
  end
end
