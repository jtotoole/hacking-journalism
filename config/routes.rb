Rails.application.routes.draw do
  get "/submit_comment", to: "home#submit_comment"
  get "/get_comments", to: "home#get_comments", as: "get_comments"
  get "/delete_comment", to: "home#delete_comment"
end
