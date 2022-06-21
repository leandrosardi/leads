module Leads
  class FlExportLead < Sequel::Model(:fl_export_lead)
    many_to_one :fl_export, :class=>:'Leads::FlExport', :key=>:id_export
    many_to_one :fl_lead, :class=>:'Leads::FlLead', :key=>:id_lead
  end
end
