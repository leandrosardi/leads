# public screens (landing page)
get "/leads/landing", :agent => /(.*)/ do
    erb :"/leads/exports", :layout => :"/leads/layouts/public"
end

# internal wizard (funnel) screens
get "/leads/step1", :auth1 => true, :agent => /(.*)/ do
    erb :"/leads/step1", :layout => :"/leads/layouts/public"
end

get "/leads/step2", :auth1 => true, :agent => /(.*)/ do
    erb :"/leads/step2", :layout => :"/leads/layouts/public"
end

get "/leads/tripwire", :auth1 => true, :agent => /(.*)/ do
    erb :"/leads/tripwire", :layout => :"/leads/layouts/public"
end

# internal app screens
get "/leads/plans", :auth1 => true, :agent => /(.*)/ do
    erb :"/leads/plans", :layout => :"/layouts/core"
end

get "/leads/welcome", :auth1 => true, :agent => /(.*)/ do
    erb :"/leads/welcome", :layout => :"/layouts/core"
end

get "/leads/search", :auth1 => true, :agent => /(.*)/ do
    erb :"/leads/search", :layout => :"/layouts/core"
end

get "/leads/saved_searches", :auth1 => true, :agent => /(.*)/ do
    erb :"/leads/saved_searches", :layout => :"/layouts/core"
end

get "/leads/results", :auth1 => true, :agent => /(.*)/ do
    erb :"/leads/results", :layout => :"/layouts/core"
end

get "/leads/exports", :auth1 => true, :agent => /(.*)/ do
    erb :"/leads/exports", :layout => :"/layouts/core"
end

# filters
get "/leads/filter_landing"
    erb :"/leads/filter_landing"
end

get "/leads/filter_step1", :auth1 => true
    erb :"/leads/filter_step1"
end

get "/leads/filter_step2", :auth1 => true
    erb :"/leads/filter_step2"
end

get "/leads/filter_tripwire", :auth1 => true
    erb :"/leads/filter_tripwire"
end





