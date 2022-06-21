module Leads
  class FlSearchIndustry < Sequel::Model(:fl_search_industry)
    many_to_one :fl_search, :class=>:'Leads::FlSearch', :key=>:id_search
    many_to_one :fl_industry, :class=>:'Leads::FlSearchIndustry', :key=>:id_industry
  end
end
