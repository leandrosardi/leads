# load gem and connect database
require 'mysaas'
require 'lib/stubs'
require 'config'
require 'version'
DB = BlackStack::CRDB::connect
require 'lib/skeletons'
require 'extensions/i2p/lib/skeletons'
require 'extensions/leads/lib/skeletons'

# add required extensions
BlackStack::Extensions.append :i2p
BlackStack::Extensions.append :leads

BlackStack::Extensions.add_storage_subfolders

l = BlackStack::LocalLogger.new('./export.log')

while true
  # restart exports who have finished, but have leads added after their last processing
  l.logs 'Restarting... '
  Leads::FlExport::restart(l)
  l.done

  # iterate all exports with no start time, and a search.
  Leads::FlExport.where(:create_file_start_time=>nil).all.each do |export|
    l.logs "Processing export #{export.id}"
    begin
      l.logs 'Flag start_time... '
      export.create_file_start_time = now
      export.save
      l.done

      l.logs 'Flood export... '
      if export.id_search.nil?
        l.logf 'No search specified'
      else
        export.flood(l)
        l.done
      end

      l.logs 'Generate file... '
      export.generate_file(l)
      l.done

      l.logs 'Flag end_time... '
      export.no_of_results = export.fl_export_leads.count
      export.no_of_companies = export.count_companies
      export.create_file_end_time = now
      export.create_file_success=true
      export.save
      l.done

    rescue => e
      l.log "Error: #{e.message}"

      l.logs 'Flag error... '
      export.create_file_success = false
      export.create_file_error_description = e.message
      export.save
      l.done
    end
    l.done

  end # exports.each 

  l.logs 'Sleeping... '
  sleep(10)
  l.done

end # while true