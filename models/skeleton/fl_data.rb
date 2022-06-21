module Leads
  class FlData < Sequel::Model(:fl_data)
    many_to_one :fl_lead, :class=>:'Leads::FlLead', :key=>:id_lead
  end
end
