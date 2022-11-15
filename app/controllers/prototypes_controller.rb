class PrototypesController < ApplicationController
  before_action :move_to_index, except: [:index, :new, :show, :edit, :destroy]
  before_action :authenticate_user!, except: [:index, :show, :destroy]

  def index
    @prototypes = Prototype.all.includes(:user)
  end

  def new
    @prototype = Prototype.new
    # unless @prototype.user_id == current_user.id
    #   redirect_to new_user_session_path
    # end
  end

  def create
    # binding.pry
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path(@prototype)
    else
      # @prototype = @prototype.includes(:user)
      render :new
    end
  end

  def show
    @prototype = Prototype.find(params[:prototype_id] || params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    @prototype = Prototype.find(params[:id])
    unless @prototype.user_id == current_user.id
      redirect_to new_user_session_path
    end
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype.id)
    else
      render :edit
    end
  end

  def destroy
    @prototype = Prototype.find(params[:id])
    @prototype.destroy
    redirect_to root_path
  end

  private
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end

end
