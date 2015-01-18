Rails.application.routes.draw do
  get "/submit_comment", to: "comment#submit"
  get "/get_comments", to: "comment#get", as: "get_comments"
  get "/delete_comment", to: "comment#delete"
  get "/delete_all", to: "comment#delete_all"

  get "/", to: "home#index"
end
