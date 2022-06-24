# load gem and connect database
require 'mysaas'
require 'lib/stubs'
require 'config'
require 'version'
DB = BlackStack::CRDB::connect
require 'lib/skeletons'
require 'extensions/leads/lib/skeletons'

[
    "https://www.connectionsphere.com",
    "https://www.connectionsphere.com/",
    "https://www.connectionsphere.com/en",
    "https://www.connectionsphere.com/en/",
    "https://www.connectionsphere.com/en/home",
    "https://www.connectionsphere.com/en/home/",
    "https://connectionsphere.com/",
    "connectionsphere.com",
    "euler.connectionsphere.com",
].each { |url|
    puts "#{url} --> #{Leads::FlCompany.normalize_url(url)}"
}

