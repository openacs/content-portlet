# 

ad_library {
    
    Procedures to supports content portlets.
    
    @author byron Haroldo Linares Roman (bhlr@byronLs-Computer.local)
    @creation-date 2007-07-04
    @arch-tag: 16A7A29A-271C-49B1-8787-935755BF5583
    @cvs-id $Id$
}

namespace eval content_portlet {
    
    ad_proc -private get_my_name {
    } {
        return "content_portlet"
    }

    ad_proc -public get_pretty_name {
    } {
        return [parameter::get_from_package_key \
                    -package_key [my_package_key] \
                    -parameter content_portlet_pretty_name]
    }
    
    ad_proc -private my_package_key {
    } {
        return "content-portlet"
    }
    
    ad_proc -public link {
    } {
        return ""
    }

    ad_proc -public add_self_to_page {
        {-portal_id:required}
        {-package_id:required}
        {-param_action:required}
        {-force_region ""}
        {-page_name "" }
    } {
        Adds a static PE to the given page
    } {
        #       ns_log notice "content_portlet::add_self_to_page -
	# Don't call me. Use static_portal_content:: instead"                                                        
        return [portal::add_element_parameters \
                    -portal_id $portal_id \
                    -portlet_name [get_my_name] \
                    -value $package_id \
                    -force_region [parameter::get_from_package_key -package_key [my_package_key] -parameter content_portal_force_region] \
                    -page_name [parameter::get_from_package_key -package_key [my_package_key] -parameter content_portal_page_name] \
                    -pretty_name [get_pretty_name] \
                    -param_action $param_action]
	#       error                                                                                                                                                
    }
    
    ad_proc -public remove_self_from_page {
        {-portal_id:required}
        {-package_id:required}
    } {
        Removes static PE from the given page
    } {
	# This is easy since there's one and only one instace_id                                                                                                             
        portal::remove_element_parameters \
            -portal_id $portal_id \
            -portlet_name [get_my_name] \
            -value $package_id
    }
    
    ad_proc -public show {
        cf
    } {
    } {
        portal::show_proc_helper \
            -package_key [my_package_key] \
            -config_list $cf \
            -template_src "content-portlet"
    }
}

