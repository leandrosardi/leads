module Leads
    JOBPOSITIONS = ['Founder','President','Director','Manager','CEO','VP','Consultant','Owner','Sales','Partner','Chiropractor','Doctor','MD','Keynote','Speaker','Expert','Realtor','Broker','Lawyer','Advisor']

    # load all the skeletons
    def self.server_side
        require 'extensions/leads/lib/skeletons'
    end

    # load all the stubs
    def self.client_side
        # this extension has not stub
        #require 'extensions/leads/lib/stubs'
    end
end # module Leads

# setup the product
BlackStack::I2P::add_services([
    { 
        :code=>'leads', 
        :name=>'B2B Contacts', 
        :unit_name=>'records', 
        :consumption=>BlackStack::I2P::CONSUMPTION_BY_TIME, 
        # formal description to show in the list of products
        :description=>'B2B Contacts with Emails & Phone Numbers',
        # persuasive description to show in the sales letter
        :title=>'The Best Data Quality, at the Best Price',
        # larger persuasive description to show in the sales letter
        :summary=>'B2B Contacts with verified <b>email addresses</b>, <b>phone numbers</b> and <b>LinkedIn profiles</b>.',
        :thumbnail=>"#{CS_HOME_WEBSITE}/leads/images/logo.png",
        :return_path=>"#{CS_HOME_WEBSITE}/leads/results",
        # what is the life time of this product or service?
        :credits_expiration_period => 'month',
        :credits_expiration_units => 1,
        # free tier configuration
        :free_tier=>{
            # add 10 records per month, for free
            :credits=>10,
            :period=>'month',
            :units=>1,
        },
        # most popular plan configuratioon
        :most_popular_plan => 'leads.batman',
    },
])

# setup the plan
BlackStack::I2P::add_plans([
    {
        # which product is this plan belonging
        :service_code=>'leads', 
        # recurrent billing plan or one-time payments
        :type=>BlackStack::I2P::PAYMENT_SUBSCRIPTION,  
        # show this plan in the UI
        :public=>false,
        # is this a One-Time Offer?
        # true: this plan is available only if the account has not any invoice using this plan
        # false: this plan can be purchased many times
        :one_time_offer=>true,  
        # plan description
        :item_number=>'leads.offer', 
        :name=>'90% Off', 
        # trial configuration
        :trial_credits=>280, 
        :trial_fee=>7, 
        :trial_units=>1, 
        :trial_period=>'month',     
        # billing details
        :credits=>28, 
        :normal_fee=>7, # cognitive bias: expensive fee to show it strikethrough, as the normal price. But it's a lie. 
        :fee=>7, # this is the fee that your will charge to the account, as a special offer price.
        :period=>'month',
        :units=>1, # billed monthy
		# Force credits expiration in the moment when the client 
		# renew with a new payment from the same subscription.
		# Activate this option for every allocation service.
		:expiration_on_next_payment => true, # default true
		# Additional period after the billing cycle - Extend 2 weeks after the billing cycle - Referemce: https://github.com/ExpandedVenture/ConnectionSphere/issues/283.
		:expiration_lead_period => 'day', #'M', # default day
		:expiration_lead_units => 365 #3, # default 0
    }, {
        # which product is this plan belonging
        :service_code=>'leads', 
        # recurrent billing plan or one-time payments
        :type=>BlackStack::I2P::PAYMENT_SUBSCRIPTION,  
        # show this plan in the UI
        :public=>true,
        # is this a One-Time Offer?
        # true: this plan is available only if the account has not any invoice using this plan
        # false: this plan can be purchased many times
        :one_time_offer=>false,  
        # plan description
        :item_number=>'leads.robin', 
        :name=>'Robin', 
        # billing details
        :credits=>28, 
        :normal_fee=>7, # cognitive bias: expensive fee to show it strikethrough, as the normal price. But it's a lie. 
        :fee=>7, # this is the fee that your will charge to the account, as a special offer price.
        :period=>'month',
        :units=>1, # billed monthy
		# Force credits expiration in the moment when the client 
		# renew with a new payment from the same subscription.
		# Activate this option for every allocation service.
		:expiration_on_next_payment => true, # default true
		# Additional period after the billing cycle - Extend 2 weeks after the billing cycle - Referemce: https://github.com/ExpandedVenture/ConnectionSphere/issues/283.
		:expiration_lead_period => 'day', #'M', # default day
		:expiration_lead_units => 365 #3, # default 0
    }, {
        # which product is this plan belonging
        :service_code=>'leads', 
        # recurrent billing plan or one-time payments
        :type=>BlackStack::I2P::PAYMENT_SUBSCRIPTION,  
        # show this plan in the UI
        :public=>true,
        # is this a One-Time Offer?
        # true: this plan is available only if the account has not any invoice using this plan
        # false: this plan can be purchased many times
        :one_time_offer=>false,  
        # plan description
        :item_number=>'leads.batman', 
        :name=>'Batman', 
        # billing details
        :credits=>135, 
        :normal_fee=>33, # cognitive bias: expensive fee to show it strikethrough, as the normal price. But it's a lie. 
        :fee=>27, # this is the fee that your will charge to the account, as a special offer price.
        :period=>'month',
        :units=>1, # billed monthy
		# Force credits expiration in the moment when the client 
		# renew with a new payment from the same subscription.
		# Activate this option for every allocation service.
		:expiration_on_next_payment => true, # default true
		# Additional period after the billing cycle - Extend 2 weeks after the billing cycle - Referemce: https://github.com/ExpandedVenture/ConnectionSphere/issues/283.
		:expiration_lead_period => 'day', #'M', # default day
		:expiration_lead_units => 365 #3, # default 0
    }, {
        # which product is this plan belonging
        :service_code=>'leads', 
        # recurrent billing plan or one-time payments
        :type=>BlackStack::I2P::PAYMENT_SUBSCRIPTION,  
        # show this plan in the UI
        :public=>true,
        # is this a One-Time Offer?
        # true: this plan is available only if the account has not any invoice using this plan
        # false: this plan can be purchased many times
        :one_time_offer=>false,  
        # plan description
        :item_number=>'leads.hulk', 
        :name=>'Hulk', 
        # billing details
        :credits=>314, 
        :normal_fee=>79, # cognitive bias: expensive fee to show it strikethrough, as the normal price. But it's a lie. 
        :fee=>47, # this is the fee that your will charge to the account, as a special offer price.
        :period=>'month',
        :units=>1, # billed monthy
		# Force credits expiration in the moment when the client 
		# renew with a new payment from the same subscription.
		# Activate this option for every allocation service.
		:expiration_on_next_payment => true, # default true
		# Additional period after the billing cycle - Extend 2 weeks after the billing cycle - Referemce: https://github.com/ExpandedVenture/ConnectionSphere/issues/283.
		:expiration_lead_period => 'day', #'M', # default day
		:expiration_lead_units => 365 #3, # default 0
    }
])
