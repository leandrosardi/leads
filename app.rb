# define screens
get "/leads/exports", :auth1 => true do
  erb :"/leads/exports", :layout => :"/layouts/core"
end