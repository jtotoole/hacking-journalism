class Parsely
  def root
    "http://api.parsely.com/v2/"
  end

  def rest_call
    response  = RestClient.get("https://api.parsely.com/v2/analytics/posts?apikey=blog.parsely.com")
    binding.pry
    "binding"
  end
end