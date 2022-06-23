module Leads
  class FlLead < Sequel::Model(:fl_lead)
    many_to_one :fl_company, :class=>:'Leads::FlCompany', :key=>:id_company
    many_to_one :fl_industry, :class=>:'Leads::FlSearchIndustry', :key=>:id_industry
    many_to_one :fl_location, :class=>:'Leads::FlSearchLocation', :key=>:id_location
    one_to_many :fl_data, :class=:'Leads::FlData', :key=>:id_lead

    # validate the strucutre of the hash descritpro 
    def validate_descriptor(h)
    end

    # 
    def initialize(h)
    end

  end
end
