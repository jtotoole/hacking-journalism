Rails.application.routes.draw do
  get "/submit_comment", to: "home#submit_comment"

  get "/get_comments", to: "home#get_comments", defaults: { format: 'json' }
end
