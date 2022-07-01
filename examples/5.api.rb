# load gem and connect database
require 'mysaas'
require 'lib/stubs'
require 'config'
require 'version'

res = nil

url = "#{CS_HOME_WEBSITE}/api1.0/leads/merge_many.json"

leads = [
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
=begin
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
=end
    },
]

begin
    params = {
        'api_key' => BlackStack::API.api_key,
        'leads' => leads
    }
    res = BlackStack::Netting::call_post(url, params)
    parsed = JSON.parse(res.body)
    raise parsed['status'] if parsed['status']!='success'
    puts parsed.to_s
rescue Errno::ECONNREFUSED => e
    raise "Errno::ECONNREFUSED:" + e.message
rescue => e2
    raise "Exception:" + e2.message
end

