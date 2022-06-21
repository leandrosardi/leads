module Leads
  class FlInvite < Sequel::Model(:fl_invite)
    many_to_one :user, :class=>:'BlackStack::MySaaS::User', :key=>:id_user
  end
end
