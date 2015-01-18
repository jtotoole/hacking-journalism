require 'spec_helper'

describe CommentController, type: :controller do

  before do
    Comment.create!(text: "my text", id: 1)
  end

  it "renders simple trends in xml" do
    get :delete_comment, id: 1
    expect(response).to render_template("delete_comment")
  end
end
