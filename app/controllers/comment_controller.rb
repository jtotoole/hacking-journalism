class CommentController < ApplicationController
  before_action :authenticate

  def submit
    unless missing_param?
      Comment.create!(
        text:       params[:text] || nil,
        position_x: params[:position_x],
        position_y: params[:position_y],
        time:       params[:time],
        user:       params[:user],
        kind:       params[:kind],
        group:      params[:group] || nil
      )
    end
  end

  def get
    if no_param?(params[:group])
      comments = Comment.all
    else
      comments = Comment.where(group: params[:group])
    end
    render json: comments, callback: params[:callback]
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
    no_param?(params[:kind]) || no_param?(params[:time]) || no_param?(params[:position_x]) || no_param?(params[:position_y]) || no_param?(params[:user])
  end

  def no_param?(param)
    param.nil? || param.empty?
  end

  def success_redirect
    redirect_to(get_comments_path, auth: ENV.fetch('AUTH'))
  end
end