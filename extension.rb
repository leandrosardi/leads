BlackStack::Extensions::add ({
    # descriptive name and descriptor
    :name => 'Leads',
    :description => 'Leads is a mySaaS extension to add a marketplace of B2B contacts.',

    # define version with format <mayor>.<minor>.<revision>
    :version => '0.0.1',

    # define the name of the author
    :author => 'leandrosardi',

    # what is the section to add this extension in either the top-bar, the footer, the dashboard.
    :apps_section => 'Marketplace',
    # show this extension as a service in the top bar?
    :show_in_top_bar => true,
    # show this extension as a service in the footer?
    :show_in_footer => true,
    # show this extension as a service in the dashboard?
    :show_in_dashboard => true,

    # what are the screens to add in the leftbar
    :leftbar_icons => [
        # add an icon with the label "dashboard`, with the icon `icon-dashboard`, and poiting to the scren `helpdesk/dashboard`. 
        { :label => 'search', :icon => :'icon-search', :screen => :search, },
        # add an icon with the label "tickets`, with the icon `icon-envelope`, and poiting to the scren `helpdesk/tickets`. 
        { :label => 'exports', :icon => :'icon-download-cloud', :screen => :exports, },
    ],
 
    # add a folder to the storage from where user can download the exports.
    :storage_folders => [
        { :name => 'exports.leads', },
    ],
})