class RelationConstituentsController < ApplicationController
  # FIXME: Ensure user owns world!
  #include WorldAssociationController

  before_action :set_relation_constituent, only: [:destroy, :update, :edit]

  # FIXME: Realize this via RelationsController!?
  def destroy
    @relation_constituent.destroy
    respond_to do |format|
      format.html do
        # FIXME: Clean this up
        fact = @relation_constituent.fact
        relation = @relation_constituent.relation
        world = fact.world
        redirect_to(world_fact_relation_path(world, fact, relation),
                    notice: t('.destroyed'))
      end
    end
  end

  private
  def set_relation_constituent
    @relation_constituent = RelationConstituent.find(params[:id])
  end
end
