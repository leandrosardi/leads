module Leads
  class FlExport < Sequel::Model(:fl_export)
    many_to_one :user, :class=>:'BlackStack::MySaaS::User', :key=>:id_user
    many_to_one :fl_search, :class=>:'Leads::FlSearch', :key=>:id_search
  end
end
