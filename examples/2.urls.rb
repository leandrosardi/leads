# load gem and connect database
require 'mysaas'
require 'lib/stubs'
require 'config'
require 'version'
DB = BlackStack::CRDB::connect
require 'lib/skeletons'
require 'extensions/leads/lib/skeletons'


puts Leads::FlCompany.normalize_url('https://connectionsphere.com')
puts Leads::FlCompany.normalize_url('connectionsphere.com')