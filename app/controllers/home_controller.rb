class HomeController < ApplicationController
  before_action :authenticate

  def submit_comment
    unless missing_param?
      Comment.create!(text: params[:text], position_x: params[:position_x], position_y: params[:position_y], time: params[:time])
    end
    success_redirect
  end

  def get_comments
    @comments = Comment.all
    respond_to do |format|
      format.json { render "get_comment.json"}
    end
  end

  def delete_comment
    unless no_param?(params[:id])
      Comment.find(params[:id]).destroy
    end
    success_redirect
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