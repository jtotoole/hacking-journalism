require 'spec_helper'

describe CommentController, type: :controller do

  before do
    Comment.create(text: "my text")
  end

  it "renders comment delete tmeplate (success)" do
    get :delete, id: Comment.first.id
    expect(response).to render_template("comment/delete")
  end

  it "renders comment submit template (success)" do
    get :submit, position_x: "123", position_y: "123", user: "miles", time: "time"
    expect(response).to render_template("comment/submit")
  end

  it "renders comment delete_all template (success)" do
    get :delete_all
    expect(response).to render_template("comment/delete_all")
  end
end
