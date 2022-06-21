module Leads
  class FlSearchPosition < Sequel::Model(:fl_search_position)
    many_to_one :fl_search, :class=>:'Leads::FlSearch', :key=>:id_search
  end
end
