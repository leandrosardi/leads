module BlackStack
    module Leads
        class Account < BlackStack::MySaaS::Account
            one_to_many :users, :class=>:'BlackStack::Leads::User', :key=>:id_account

            def exports
                self.users.map { |u| u.fl_exports }.flatten
            end # def exports

        end # class Account
    end # module Leads
end # module BlackStack