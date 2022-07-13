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

# public screens (signup/landing page)
get "/leads/signup", :agent => /(.*)/ do
    erb :"/extensions/leads/views/signup"
end

# public screens (login page)
get "/leads/login", :agent => /(.*)/ do
    erb :"/extensions/leads/views/login", :layout => :"/views/layouts/public"
end

# internal wizard (funnel) screens
get "/leads/step1", :auth => true, :agent => /(.*)/ do
    erb :"/extensions/leads/views/step1", :layout => :"/views/layouts/public"
end

get "/leads/step2", :auth => true, :agent => /(.*)/ do
    erb :"/extensions/leads/views/step2", :layout => :"/views/layouts/public"
end

get "/leads/offer", :auth => true, :agent => /(.*)/ do
    account = BlackStack::I2P::Account.where(:id=>@login.user.id_account).first
    if account.disabled_trial?
        redirect '/leads/plans' 
    else
        erb :"/extensions/leads/views/offer", :layout => :"/views/layouts/public"
    end
end

# internal app screens
get "/leads/plans", :auth => true, :agent => /(.*)/ do
    erb :"/extensions/leads/views/plans", :layout => :"/views/layouts/core"
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

get "/leads/filter_delete_saved_search", :auth => true, :agent => /(.*)/ do
    erb :"/extensions/leads/views/filter_delete_saved_search", :layout => :"/views/layouts/core"
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

get "/leads/filter_offer", :auth => true do
    erb :"/extensions/leads/views/filter_offer"
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
post "/ajax/leads/get_lists_linked_to_lead.json", :auth => true do
    erb :"/extensions/leads/views/ajax/get_lists_linked_to_lead"
end

post "/ajax/leads/create_export_list_and_add_lead.json", :auth => true do
    erb :"/extensions/leads/views/ajax/create_export_list_and_add_lead"
end

post "/ajax/leads/add_lead_to_export_list.json", :auth => true do
    erb :"/extensions/leads/views/ajax/add_lead_to_export_list"
end

post "/ajax/leads/remove_lead_from_export_list.json", :auth => true do
    erb :"/extensions/leads/views/ajax/remove_lead_from_export_list"
end

post "/ajax/leads/get_lead_data.json", :auth => true do
    erb :"/extensions/leads/views/ajax/get_lead_data"
end

# API
post "/api1.0/leads/merge.json", :api_key => true do
    erb :"/extensions/leads/views/api1.0/merge"
end

post "/api1.0/leads/merge_many.json", :api_key => true do
    erb :"/extensions/leads/views/api1.0/merge_many"
end


