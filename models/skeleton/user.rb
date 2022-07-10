module BlackStack
    module Leads
        class User < BlackStack::MySaaS::User
            one_to_many :fl_exports, :class=>:'Leads::FlExport', :key=>:id_user
        end # class User
    end # module Leads
end # module BlackStack