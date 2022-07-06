# load gem and connect database
require 'mysaas'
require 'lib/stubs'
require 'config'
require 'version'
DB = BlackStack::CRDB::connect
require 'lib/skeletons'
require 'extensions/leads/lib/skeletons'

s = Leads::FlSearch.new ({
    'name' => 'New first search',
    'description' => 'Looking for Financial Advisors in New York, except New York City',
    'id_user' => BlackStack::MySaaS::User.first.id,
    'saved' => false,
    'no_of_results' => 14,
    'no_of_companies' => 10,
    'positions' => [ 
        { 'value' => 'Financial Advisor', 'positive' => true },
        { 'value' => 'Financial Analyst', 'positive' => true },
        { 'value' => 'Financial Manager', 'positive' => true },
        { 'value' => 'Secretary', 'positive' => false },
        { 'value' => 'Student', 'positive' => false },
    ],
    'locations' => [
        { 'value' => 'New York', 'positive' => true },
        { 'value' => 'New York City', 'positive' => false },
    ],
    'industries' => [
        { 'name' => 'Financial Services', 'positive' => true },
        { 'name' => 'Management Consulting', 'positive' => false },
    ],
})

puts s.rows({
    'page' => 2,
    'pagesize' => 5,
    'sortcolumn' => 'name',
    'sortorder' => 'asc',
}).to_s


