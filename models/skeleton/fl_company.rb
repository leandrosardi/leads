module Leads
  class FlCompany < Sequel::Model(:fl_company)
    one_to_many :fl_leads, :class=>:'Leads::FlLeads', :key=>:id_company
  end
end
