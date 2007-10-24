# 

ad_page_contract {
    
    
    
    @author byron Haroldo Linares Roman (bhlr@byronLs-Computer.local)
    @creation-date 2007-08-27
    @arch-tag: 2D2A97D5-0515-479D-90D6-A22F05718776
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
set delete_url [export_vars -no_empty -base category-delete-2 { tree_id category_id:multiple locale object_id }]
set cancel_url [export_vars -no_empty -base tree-view { tree_id locale object_id }]
set page_title "Delete categories"

set tree_list [content_category::get_tree_levels -subtree_id $category_id $tree_id]
set tree_list [linsert $tree_list 0 $category_id]
foreach category $tree_list { 
    set my_category_id [lindex $category 0]
    if {[db_string check_mapped_objects {}] eq 1} {
	ad_return_complaint 1 "[_ content-portlet.mapped_objects]"
	ad_script_abort
    }
    lappend category_ids $my_category_id 
}

ns_log notice "byronnnnn $tree_id $category_ids $return_url"
set result [content_category::category_delete $tree_id $category_ids]
if {$result eq 0} {
    ad_return_complaint 1 "[_ content-portlet.still_contains_subcategories]"
}
ad_returnredirect $return_url 

