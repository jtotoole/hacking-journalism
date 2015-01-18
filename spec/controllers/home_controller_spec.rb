require 'spec_helper'

describe CommentController, type: :controller do

  before do
    Comment.create(text: "my text")
  end

  it "renders comment delete view (success)" do
    get :delete, id: Comment.first.id
    expect(response).to render_template("comment/delete")
  end

  # it "renders comment submit view (success)" do
  #   get :submit, text: "my text", position_x:
  #   expect(response).to render_template("comment/delete")
  # end
end
