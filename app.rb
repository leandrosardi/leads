# public screens (landing page)
get "/leads/landing", :agent => /(.*)/ do
    erb :"/extensions/leads/views/exports", :layout => :"/leads/layouts/public"
end

# internal wizard (funnel) screens
get "/leads/step1", :auth1 => true, :agent => /(.*)/ do
    erb :"/extensions/leads/views/step1", :layout => :"/leads/layouts/public"
end

get "/leads/step2", :auth1 => true, :agent => /(.*)/ do
    erb :"/extensions/leads/views/step2", :layout => :"/leads/layouts/public"
end

get "/leads/tripwire", :auth1 => true, :agent => /(.*)/ do
    erb :"/extensions/leads/views/tripwire", :layout => :"/leads/layouts/public"
end

# internal app screens
get "/leads/plans", :auth1 => true, :agent => /(.*)/ do
    erb :"/extensions/leads/views/plans", :layout => :"/layouts/core"
end

get "/leads/welcome", :auth1 => true, :agent => /(.*)/ do
    erb :"/extensions/leads/views/welcome", :layout => :"/layouts/core"
end

get "/leads/search", :auth1 => true, :agent => /(.*)/ do
    erb :"/extensions/leads/views/search", :layout => :"/layouts/core"
end

get "/leads/saved_searches", :auth1 => true, :agent => /(.*)/ do
    erb :"/extensions/leads/views/saved_searches", :layout => :"/layouts/core"
end

get "/leads/results", :auth1 => true, :agent => /(.*)/ do
    erb :"/extensions/leads/views/results", :layout => :"/layouts/core"
end

get "/leads/exports", :auth1 => true, :agent => /(.*)/ do
    erb :"/extensions/leads/views/exports", :layout => :"/layouts/core"
end

# filters
get "/leads/filter_landing"
    erb :"/extensions/leads/views/filter_landing"
end

get "/leads/filter_step1", :auth1 => true
    erb :"/extensions/leads/views/filter_step1"
end

get "/leads/filter_step2", :auth1 => true
    erb :"/extensions/leads/views/filter_step2"
end

get "/leads/filter_tripwire", :auth1 => true
    erb :"/extensions/leads/views/filter_tripwire"
end

# TODO: add remaining filters about internal screens (searches, results, etc.)


