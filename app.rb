# helper to redirect with the params
def redirect2(url, params)
    redirect url + '?' + params.reject { |key, value| key=='agent' }.map{|key, value| "#{key}=#{value}"}.join("&")
end

# default screen
get "/leads", :auth => true, :agent => /(.*)/ do
    redirect2 "/leads/results", params
end
get "/leads/", :auth => true, :agent => /(.*)/ do
    redirect2 "/leads/results", params
end

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

get "/leads/saved_searches", :auth => true, :agent => /(.*)/ do
    erb :"/extensions/leads/views/saved_searches", :layout => :"/views/layouts/core"
end

get "/leads/results", :auth => true, :agent => /(.*)/ do
    erb :"/extensions/leads/views/results", :layout => :"/views/layouts/core"
end

get "/leads/results/:sid", :auth => true, :agent => /(.*)/ do
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

post "/leads/filter_results", :auth => true do
    erb :"/extensions/leads/views/filter_results"
end

post "/leads/filter_save_search", :auth => true do
    erb :"/extensions/leads/views/filter_save_search"
end

post "/leads/filter_export_contacts", :auth => true do
    erb :"/extensions/leads/views/filter_export_contacts"
end

# AJAX 
post "/ajax/leads/create_export_list_and_export_lead.json", :auth => true do
    erb :"/extensions/leads/views/ajax/create_export_list_and_export_lead"
end

post "/ajax/leads/add_lead_to_export_list.json", :auth => true do
    erb :"/extensions/leads/views/ajax/add_lead_to_export_list"
end

post "/ajax/leads/remove_lead_to_export_list.json", :auth => true do
    erb :"/extensions/leads/views/ajax/remove_lead_to_export_list"
end

# API
post "/api1.0/leads/merge.json", :api_key => true do
    erb :"/extensions/leads/views/api1.0/merge"
end

post "/api1.0/leads/merge_many.json", :api_key => true do
    erb :"/extensions/leads/views/api1.0/merge_many"
end


