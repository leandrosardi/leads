module Leads
  class FlExportLead < Sequel::Model(:fl_export_lead)
    many_to_one :fl_export, :class=>:'Leads::FlExport', :key=>:id_export
    many_to_one :fl_lead, :class=>:'Leads::FlLead', :key=>:id_lead

    # verify the account has credits before adding a lead to the export.
    # if the account has not credits, then raise an exception 'No Credits'.
    #
    # if the lead has not been added to any other export list of this account, 
    # then consume 1 credit from the account.
    #
    # call the super method to add the lead to the export.
    # 
    def save()
      account = BlackStack::I2P::Account.where(:id=>self.fl_export.user.id_account).first
      raise 'No Credits' if account.credits('leads') < 1
      
      account2 = BlackStack::Leads::Account.where(:id=>self.fl_export.user.id_account).first 
      account.consume('leads', 1) if FlExportLead.where(:id_lead=>self.id_lead, :id_export => account2.exports.map { |e| e.id }).first.nil?

      super()
    end

  end
end
