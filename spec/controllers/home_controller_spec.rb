require 'spec_helper'

describe CommentController, type: :controller do

  before do
    Comment.create(text: "my text")
  end

  it "renders simple trends in xml" do
    get :delete, id: "1"
    expect(response).to render_template("delete.html")
  end
end
