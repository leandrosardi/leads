# Leads

**Leads** is an extension of MySaaS to offer B2B databases.

## 1. Getting Started

Follow the steps below to install **Leads** as an extension in your **MySaaS** project 

We are assuming that you have installed your **MySaaS** in your computer, and it is working.
If you have not **MySaaS** working on your computer, follow [this tutorial](https://github.com/leandrosardi/mysaas/blob/main/docu/12.extensibility.md).

If you don't know how do **MySaaS** extensions work, refer to [this article]().

**Step 1:** Access the extensions folder of your **MySaaS** project.

```bash
cd ~/code/mysaas/extensions
```

**Step 2:** Clone the **Leads** project there.

```bash
git clone https://github.com/leandrosardi/leads/
```

**Step 3:** Add the extension in your configuration file

```ruby
# add required extensions
BlackStack::Extensions.append :leads
```

Restart the **MySaaS** webserver in order to get working the new extension.

## 2. Merging a New Lead to the Database

```ruby
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
```


## 3. Merging Many Leads to the Database

```ruby
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
```

## 4. Creating Searches

```ruby
o = Leads::FlSearch.new ({
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

o.save
```

## 5. Retrieving Table Rows

```ruby
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
    'page' => 1,
    'pagesize' => 25,
    'sortcolumn' => 'name',
    'sortorder' => 'asc',
})
```

## 6. Retrieving Leads

```ruby
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

puts s.leads({
    'page' => 1,
    'pagesize' => 25,
    'sortcolumn' => 'name',
    'sortorder' => 'asc',
})
```

## 7. Disclaimers

This project is still under construction.

The logo has been taken from [here](https://www.shareicon.net/shot-shooting-target-circular-target-targeting-target-interface-duck-700809).

