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

