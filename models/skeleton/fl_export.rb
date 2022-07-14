module Leads
  class FlExport < Sequel::Model(:fl_export)
    many_to_one :user, :class=>:'BlackStack::MySaaS::User', :key=>:id_user
    many_to_one :fl_search, :class=>:'Leads::FlSearch', :key=>:id_search
    one_to_many :fl_export_leads, :class=>'Leads::FlExportLead', :key=>:id_export

    # restart exports who have finished, but have leads added after their last processing
    def self.restart(l=nil)
      l = BlackStack::DummyLogger.new(nil) if l.nil?
      q = "
        SELECT DISTINCT e.id
        FROM fl_export e
        JOIN fl_export_lead el ON ( el.id_export = e.id AND el.create_time > e.create_file_start_time )
        WHERE e.create_file_start_time IS NOT NULL
      "
      DB[q].all { |row| 
        l.logs "Restarting export #{row[:id]}"
        export = Leads::FlExport.where(:id=>row[:id]).first
        export.create_file_start_time = nil
        export.save
        l.done
        # release resources
        GC.start
        DB.disconnect
      }
    end

    # calculate how many more records can be added to the export,
    # based on 
    # 1. the number of credits available for the export,
    # 2. the number of records already exported, and
    # 3. the number of records requested by the export
    def left
      # number of results alreday present in the export
      n = Leads::FlExportLead.where(:id_export=>self.id).count
      # number of results requested by the export
      m = self.number_of_records
      # credits available for the export
      c = BlackStack::I2P::Account.where(:id=>self.user.account.id).first.credits('leads')
      # total number of results to add
      m.nil? ? c : [c-n, m-n].min
    end

    # add `left` records to the export
    def flood(l=nil)
      l = BlackStack::DummyLogger.new(nil) if l.nil?
      n = self.left # number of results to add
      if n>0
        q = "
          SELECT DISTINCT l.id
          #{self.fl_search.core}
          -- este lead no tuvo que haber sido exportado a ninguna otra lista de esta cuenta
          AND l.id NOT IN (
            SELECT DISTINCT el.id_lead
            FROM fl_export_lead el
            JOIN fl_export e ON ( e.id = el.id_export )
            JOIN \"user\" u ON ( u.id = e.id_user AND u.id_account = '#{self.user.id_account}' )
          )
          LIMIT #{n.to_s}
        "
        DB[q].all { |row|
          l.logs "Adding lead #{row[:id]}... "
          x = Leads::FlExportLead.new()
          x.id = guid
          x.create_time = now
          x.id_export = self.id
          x.id_lead = row[:id]
          x.save
          # 
          GC.start
          DB.disconnect
          l.done
        }
      end # if n>0
    end

    # return a string with the CSV content
    def content(l=nil)
      l = BlackStack::DummyLogger.new(nil) if l.nil?
      ret = ""
      self.fl_export_leads.each { |x|
        raise "Lead #{x.id_lead} has not data" if x.fl_lead.fl_datas.size == 0
        x.fl_lead.fl_datas.each { |d|
          ret += "#{x.id_lead},"
          ret += "\"#{x.fl_lead.name.to_s.gsub('"', '')}\","
          ret += "\"#{x.fl_lead.position.to_s.gsub('"', '')}\","
          ret += "\"#{x.fl_lead.stat_company_name.to_s.gsub('"', '')}\","
          ret += "\"#{x.fl_lead.stat_industry_name.to_s.gsub('"', '')}\","
          ret += "\"#{x.fl_lead.stat_location_name.to_s.gsub('"', '')}\","
          ret += "\"#{d.type_name.to_s.to_s.gsub('"', '')}\","
          ret += "\"#{(d.type.to_i == Leads::FlData::TYPE_PHONE.to_i ? "'" : '') + d.value.to_s.gsub('"', '')}\","
          ret += "\n"
        }
      }
      ret
    end

    # create the storage folder of the account
    # bulld the fullfilename = path + filename
    # delete any existing file with this name, in case that this is a re-processing
    # create the file
    def generate_file(l=nil)
      l = BlackStack::DummyLogger.new(nil) if l.nil?
      # create the storage folder of the account
      self.user.account.create_storage
      # bulld the fullfilename = path + filename
      fullfilename = "#{self.user.account.storage_folder}/leads.exports/#{self.filename}.csv"
      # delete any existing file with this name, in case that this is a re-processing
      File.delete(fullfilename) if File.exists?(fullfilename)
      # create the file
      File.open(fullfilename, 'w') do |f|
        f.write(self.content(l))
      end
      l.done
    end

    # return the unique companies in the export
    def count_companies
      q = "
        SELECT COUNT(DISTINCT l.id_company) AS n
        FROM fl_export_lead el
        JOIN fl_lead l ON ( l.id = el.id_lead )
        WHERE el.id_export = '#{self.id}'
      "
      DB[q].first[:n]
    end

  end
end
