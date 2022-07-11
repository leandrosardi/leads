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
BlackStack::I2P::set_services([
  { 
    :code=>'leads', 
    :name=>'B2B Contacts', 
    :unit_name=>'records', 
    :consumption=>BlackStack::I2P::CONSUMPTION_BY_TIME, 
    :description=>'B2B Contacts with Emails & Phone Numbers',
    :summary=>'B2B Contacts with verified email addresses, phone numbers and LinkedIn profiles. Target by job position, industry and location.',
    :thumbnail=>"#{CS_HOME_WEBSITE}/leads/images/logo.png",
    :return_path=>"#{CS_HOME_WEBSITE}/leads/results",
    :free_tier=>{
        # add 10 records per month, for free
        :credits=>10,
        :period=>'month',
        :units=>1,
    },
  },
])

# setup the plan
BlackStack::I2P::set_plans([
    {
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

])
