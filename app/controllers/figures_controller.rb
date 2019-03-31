class FiguresController < WorldInventoryController
  before_action :set_figure, only: [:show, :edit, :update, :destroy]

  def index
    @figures = @world.figures.order(nick: :asc)
  end

  def show
  end

  def new
    @figure = Figure.new
  end

  def create
    @figure = @world.figures.new(figure_params)

    respond_to do |format|
      if @figure.save
        format.html do
          redirect_to(world_figure_path(@world, @figure),
                      # FIXME: I18n
                      notice: "Figure #{@figure.nick} successfully created")
        end
      else
        format.html do
          # FIXME: I18n
          flash[:alert] = "Nick must be given"
          render :new
        end
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @figure.update(figure_params)
        format.html do
          redirect_to(world_figure_path(@world, @figure),
                      notice: "Figure #{@figure.nick} successfully updated-")
        end
      else
        format.html do
          flash[:alert] = "Something went wrong"
          render :edit
        end
      end
    end
  end

  def destroy
    @figure.destroy
    respond_to do |format|
      format.html do
        redirect_to(world_figures_path(@world),
                    notice: "Figure #{@figure.nick} successfully deleted")
      end
    end
  end

  private
  def set_figure
    @figure = @world.figures.find_by(nick: params[:nick])
  end

  def figure_params
    params.require(:figure).permit(:nick, :last_name, :first_name, :description, :image)
  end
end
