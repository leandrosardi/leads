BlackStack::Extensions::add ({
    # descriptive name and descriptor
    :name => 'Leads',
    :description => 'B2B Contacts, with Emails & Phone Numbers.',

    # setup the url of the repository for installation and updates
    :repo_url => 'https://github.com/leandrosardi/leads',
    :repo_branch => 'main',

    # define version with format <mayor>.<minor>.<revision>
    :version => '0.0.2',

    # define the name of the author
    :author => 'leandrosardi',

    # what is the section to add this extension in either the top-bar, the footer, the dashboard.
    :services_section => 'Services for Marketers',
    # show this extension as a service in the top bar?
    :show_in_top_bar => true,
    # show this extension as a service in the footer?
    :show_in_footer => true,
    # show this extension as a service in the dashboard?
    :show_in_dashboard => true,

    # what are the screens to add in the leftbar
    :leftbar_icons => [
        { :label => 'results', :icon => :search, :screen => :results, },
        { :label => 'exports', :icon => :'cloud-download', :screen => :exports, },
        { :label => 'searches', :icon => :'save', :screen => :'saved_searches', },
    ],
 
    # add a folder to the storage from where user can download the exports.
    :storage_folders => [
        { :name => 'leads.exports', },
    ],

    # deployment routines
    :deployment_routines => [{
        :name => 'start-export-process',
        :commands => [{ 
            # back up old configuration file
            # setup new configuration file
            :command => "
                source /home/%ssh_username%/.rvm/scripts/rvm; rvm install 3.1.2; rvm --default use 3.1.2 > /dev/null 2>&1;
                cd /home/%ssh_username%/code/mysaas/extensions/leads/p > /dev/null 2>&1; 
                export RUBYLIB=/home/%ssh_username%/code/mysaas > /dev/null 2>&1;
                nohup ruby export.rb > /dev/null 2>&1 &
            ",
            :sudo => false,
        }],
    }],
})