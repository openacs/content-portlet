# 

ad_page_contract {
    
    
    
    @author byron Haroldo Linares Roman (bhlr@byronLs-Computer.local)
    @creation-date 2007-08-27
    @arch-tag: 37E094FE-5831-4CF6-80AC-0FC7C1A64252
    @cvs-id $Id$
} {

    tree_id:integer
    category_id:integer,notnull
    {locale ""}
    object_id:integer,optional
    return_url:optional
    
} -properties {
} -validate {
} -errors {
}


set user_id [ad_maybe_redirect_for_registration]
permission::require_permission -object_id $tree_id -privilege category_tree_write

db_transaction {
    category::delete $category_id
    category_tree::flush_cache $tree_id
} on_error {
    ad_return_complaint 1 "[_ content-portlet.still_contains_subcategories]"
    ad_script_abort
}

ad_returnredirect $return_url

