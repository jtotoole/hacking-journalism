class CommentController < ApplicationController
  before_action :authenticate

  def submit
    unless missing_param?
      Comment.create!(
        text:       params[:text],
        position_x: params[:position_x],
        position_y: params[:position_y],
        time:       params[:time]
      )
    end
  end

  def get
    render json: Comment.all, callback: params[:callback]
  end

  def delete
    unless no_param?(params[:id])
      Comment.find(params[:id]).destroy
    end
  end

  def delete_all
    Comment.delete_all
  end


  private
  def missing_param?
    no_param?(params[:text]) || no_param?(params[:time]) || no_param?(params[:position_x]) || no_param?(params[:position_y])
  end

  def no_param?(param)
    param.empty? || param.nil?
  end

  def success_redirect
    redirect_to(get_comments_path, auth: ENV.fetch('AUTH'))
  end
end