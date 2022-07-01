# load gem and connect database
require 'mysaas'
require 'lib/stubs'
require 'config'
require 'version'
DB = BlackStack::CRDB::connect
require 'lib/skeletons'
require 'extensions/leads/lib/skeletons'

h = {
'leads' => [
    {
        'name' => 'Leandro Sardi',
        'position' => 'Founder and CEO',
        'company' => {
            'name' => "ConnectionSphere",
#            'url' => "https://connectionsphere.com",
        },
        'industry' => "Internet",
        'location' => "Argentina",
        'datas' => [
            {
                'type' => 10,
                'value' => "+54 9 11 5555-5555",
            },
            {
                'type' => 20,
                'value' => "support@expandedventure.com",
            },
        ],
    }, {
        'name' => 'Juan Pablo Sardi',
        'position' => 'CTO',
        'company' => {
            'name' => "ConnectionSphere",
#            'url' => "https://freeleadsdata.com",
        },
        'industry' => "Internet",
        'location' => "Argentina",
        'datas' => [
            {
                'type' => 10,
                'value' => "+54 9 11 5555-5555",
            },
            {
                'type' => 20,
                'value' => "freeleads@expandedventure.com",
            },
        ],
    }, {
        'name' => 'Maria Sardi',
        'position' => 'CFO',
        'company' => {
            'name' => "ConnectionSphere",
            'url' => "https://freeleadsdata.com",
        },
        'industry' => "Internet",
        'location' => "Argentina",
        'datas' => [
            {
                'type' => 10,
                'value' => "+54 9 11 5555-5555",
            },
            {
                'type' => 20,
                'value' => "cfo@expandedventure.com",
            },
        ],
    },
]}

puts Leads::FlLead.merge_many(h).each { |o| o.save }