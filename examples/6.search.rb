# load gem and connect database
require 'mysaas'
require 'lib/stubs'
require 'config'
require 'version'
DB = BlackStack::CRDB::connect
require 'lib/skeletons'
require 'extensions/leads/lib/skeletons'

o = Leads::FlSearch.new ({
    'name' => 'New first search',
    'description' => 'Looking for Financial Advisors in New York City',
    'saved' => true,
    'no_of_results' => 10,
    'no_of_companies' => 10,
    'positions' => [ 
        { 'value' => 'Financial Advisor', 'positive' => true },
    ],
    'locations' => [
        { 'value' => 'New York City', 'positive' => true },
    ],
    'industries' => [
        { 'name' => 'Financial Services', 'positive' => true },
    ],
})

o.save
