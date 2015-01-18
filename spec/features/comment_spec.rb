require 'spec_helper'
require 'rest-client'

describe "comment api", type: :feature do

  before do
    Comment.delete_all
    Comment.create!(
      text: "my text",
      position_x: "xpos",
      position_y: "ypos",
      user: "miles",
      time: "12:30",
      created_at: "2015-01-18T03:50:39.597Z",
      updated_at: "2015-01-18T03:50:39.597Z",
      kind: "mykind"
    )
  end

  it "submits comments" do
    expect(Comment.count).to eq(1)
    visit "/submit_comment?position_x=xpos2&position_y=ypos2&user=miles2&time=12:31&kind=mykind"
    expect(Comment.count).to eq(2)
  end

  it "gets comments" do
    visit "/get_comments"
    parsed_response = JSON.parse(page.body)
    expect(parsed_response).to eq([{"id"=>1, "text"=>"my text", "time"=>"12:30", "position_x"=>"xpos", "position_y"=>"ypos", "created_at"=>"2015-01-18T03:50:39.597Z", "updated_at"=>"2015-01-18T03:50:39.597Z", "user"=>"miles", "kind"=>"mykind", "group"=>nil}])
  end

  it "deletes all comments" do
    expect(Comment.count).to eq(1)
    visit "/delete_all"
    expect(Comment.count).to eq(0)
  end

  it "deletes a comment" do
    expect(Comment.count).to eq(1)
    visit "/delete_comment?id=#{Comment.first.id}"
    expect(Comment.count).to eq(0)
  end
end