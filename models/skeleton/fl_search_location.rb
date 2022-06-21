module Leads
  class FlSearchLocation < Sequel::Model(:fl_search_location)
    many_to_one :fl_search, :class=>:'Leads::FlSearch', :key=>:id_search
    many_to_one :fl_location, :class=>:'Leads::FlSearchLocation', :key=>:id_location
  end
end
