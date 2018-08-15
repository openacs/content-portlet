ad_page_contract {
    
    page_id:optional
    content_id:optional
    
    @author byron Haroldo Linares Roman (bhlr@byronLs-Computer.local)
    @creation-date 2007-07-25
    @cvs-id $Id$
} {
    
} -properties {
} -validate {
} -errors {
}
set wiki_url [site_node::get_url_from_object_id -object_id $content_id]
set user_id [ad_conn user_id]
set admin_p [dotlrn::user_can_admin_community_p -user_id $user_id -community_id [dotlrn_community::get_community_id]]
set headerurl "${wiki_url}header_page"
    
