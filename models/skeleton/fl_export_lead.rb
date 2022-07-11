module Leads
  class FlExportLead < Sequel::Model(:fl_export_lead)
    many_to_one :fl_export, :class=>:'Leads::FlExport', :key=>:id_export
    many_to_one :fl_lead, :class=>:'Leads::FlLead', :key=>:id_lead

    # verify the account has credits before adding a lead to the export
    # if the account has not credits, then raise an exception 'No Credits'
    def save()
      account = BlackStack::I2P::Account.where(:id=>self.fl_export.user.id_account).first
      raise 'No Credits' if account.credits('leads') < 1
      super()
    end

  end
end
