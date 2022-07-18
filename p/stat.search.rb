# load gem and connect database
require 'mysaas'
require 'lib/stubs'
require 'config'
require 'version'
DB = BlackStack::CRDB::connect
require 'lib/skeletons'
require 'extensions/leads/lib/skeletons'

# add required extensions
BlackStack::Extensions.append :leads

l = BlackStack::LocalLogger.new('./stat.search.log')

while true

  # TODO: calculate 1 time a day, when I will start to grow the database.
  Leads::FlSearch.where(:stat_start_time=>nil).all.each do |search|
  #Leads::FlSearch.where("COALESCE(stat_start_time, '1900-01-01') < CURRENT_DATE - INTERVAL '1 day'").all.each do |search|
      l.logs "Processing search #{search.id}"
    begin
      l.logs 'Flag start_time... '
      search.stat_start_time = now
      search.save
      l.done

      l.logs 'Calculate stat... '
      search.no_of_results = search.count_leads
      search.no_of_companies = search.count_companies
      l.done

      l.logs 'Flag end_time... '
      search.stat_end_time = now
      search.save
      l.done
    rescue => e
      l.log "Error: #{e.message}"

      l.logs 'Flag error... '
      search.stat_end_time = now
      search.stat_success = false
      search.stat_error_description = e.message
    end
    l.done
  end # end search.each


  l.logs 'Sleeping... '
  sleep(10)
  l.done

end # while true