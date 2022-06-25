# public screens (landing page)
get "/leads/landing", :agent => /(.*)/ do
    erb :"/extensions/leads/views/landing", :layout => :"/views/layouts/public"
end

# internal wizard (funnel) screens
get "/leads/step1", :auth => true, :agent => /(.*)/ do
    erb :"/extensions/leads/views/step1", :layout => :"/views/layouts/public"
end

get "/leads/step2", :auth => true, :agent => /(.*)/ do
    erb :"/extensions/leads/views/step2", :layout => :"/views/layouts/public"
end

get "/leads/tripwire", :auth => true, :agent => /(.*)/ do
    erb :"/extensions/leads/views/tripwire", :layout => :"/views/layouts/public"
end

# internal app screens
get "/leads/plans", :auth => true, :agent => /(.*)/ do
    erb :"/extensions/leads/views/plans", :layout => :"/views/layouts/core"
end

get "/leads/welcome", :auth => true, :agent => /(.*)/ do
    erb :"/extensions/leads/views/welcome", :layout => :"/views/layouts/core"
end

get "/leads/search", :auth => true, :agent => /(.*)/ do
    erb :"/extensions/leads/views/search", :layout => :"/views/layouts/core"
end

get "/leads/saved_searches", :auth => true, :agent => /(.*)/ do
    erb :"/extensions/leads/views/saved_searches", :layout => :"/views/layouts/core"
end

get "/leads/results", :auth => true, :agent => /(.*)/ do
    erb :"/extensions/leads/views/results", :layout => :"/views/layouts/core"
end

get "/leads/exports", :auth => true, :agent => /(.*)/ do
    erb :"/extensions/leads/views/exports", :layout => :"/views/layouts/core"
end

# filters
post "/leads/filter_landing" do
    erb :"/extensions/leads/views/filter_landing"
end

post "/leads/filter_step1", :auth => true do
    erb :"/extensions/leads/views/filter_step1"
end

post "/leads/filter_step2", :auth => true do
    erb :"/extensions/leads/views/filter_step2"
end

post "/leads/filter_tripwire", :auth => true do
    erb :"/extensions/leads/views/filter_tripwire"
end

# TODO: add remaining filters about internal screens (searches, results, etc.)

# API
get "/api1.0/leads/merge.json", :api_key => true do
    erb :"/extensions/leads/views/api1.0/merge"
end
post "/api1.0/leads/merge.json", :api_key => true do
    erb :"/extensions/leads/views/api1.0/merge"
end



