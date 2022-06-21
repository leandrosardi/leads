module Leads
  class FlSearch < Sequel::Model(:fl_search)
    many_to_one :user, :class=>:'BlackStack::MySaaS::User', :key=>:id_user
  end
end
