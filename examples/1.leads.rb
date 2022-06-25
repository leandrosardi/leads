# load gem and connect database
require 'mysaas'
require 'lib/stubs'
require 'config'
require 'version'
DB = BlackStack::CRDB::connect
require 'lib/skeletons'
require 'extensions/leads/lib/skeletons'

o = Leads::FlLead.merge ({
    :name => 'Leandro Sardi',
    :position => 'Founder and CEO',
    :company => {
        :name => "ConnectionSphere",
        :url => "https://connectionsphere.com",
    },
    :industry => "Internet",
    :location => "Argentina",
    :datas => [
        {
            :type => Leads::FlData::TYPE_PHONE,
            :value => "+54 9 11 5555-5555",
        },
        {
            :type => Leads::FlData::TYPE_EMAIL,
            :value => "leandro.sardi@expandedventure.com",
        },
        {
            :type => Leads::FlData::TYPE_EMAIL,
            :value => "tickets@expandedventure.com",
        },
    ],
})

o.save

puts "o: #{o.to_h}"
