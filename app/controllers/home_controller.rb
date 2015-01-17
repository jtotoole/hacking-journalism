class HomeController < ApplicationController
  before_action :authenticate

  def submit_comment
    text = params[:text]
    position_x = params[:position_x]
    position_y = params[:position_y]
    time = params[:time]

    unless no_param?(text) || no_param?(time) || no_param?(position_x) || no_param?(position_y)
      Comment.create!(text: text, position_x: position_x, position_y: position_y, time: time)
    end
    render "success"
  end

  def get_comments
    @comments = Comment.all
    respond_to do |format|
      format.json { render "get_comment.json"}
    end
  end

  def delete_comment
    id = params[:id]
    unless no_param?(id)
      Comment.find(id).destroy
      render "success"
    end
  end

  private
  def no_param?(param)
    param.empty? || param.nil?
  end
end