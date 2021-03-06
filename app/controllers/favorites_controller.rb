class FavoritesController < ApplicationController
  before_action :result_of_create_destroy, only: :create

  def create
    if @result
      respond_to do |format|
        format.json {render json: {message: @message, next_action: @next_action}}
      end
    else
      respond_to do |format|
        format.json do
          render json: {error_messages: @favorite.errors.full_messages,
            has_errors: Settings.error_status.internal}
        end
      end
    end
  end

  private

  def result_of_create_destroy
    @favorite = Favorite.find_by(user_id: favorite_params[:user_id],
      movie_id: favorite_params[:movie_id])
    if @favorite
      @result = @favorite.destroy
      @next_action = t :add_favorite
      @message = t "movie_favorite.remove"
    else
      @favorite = Favorite.new
      @favorite.assign_attributes favorite_params
      @result = @favorite.save
      @next_action = t "tooltip.favorite.remove"
      @message = t "movie_favorite.create"
    end
  end

  def favorite_params
    params.require(:favorite).permit :user_id, :movie_id
  end
end
