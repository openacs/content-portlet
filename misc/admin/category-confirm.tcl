# 

ad_page_contract {
    
    
    
    @author byron Haroldo Linares Roman (bhlr@byronLs-Computer.local)
    @creation-date 2007-09-13
    @arch-tag: F4A0ADC6-B070-4452-B70E-2FB409C8A738
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
set body_msg "[_ content-portlet.can_delete]"
permission::require_permission -object_id $tree_id -privilege category_tree_write
set tree_list [content_category::get_tree_levels -subtree_id $category_id $tree_id]
set tree_list [linsert $tree_list 0 $category_id]
foreach category $tree_list {
    set my_category_id [lindex $category 0]
    if {[db_string dbqd.xowiki.www.admin.category-delete.check_mapped_objects {}] eq 1} {
        set body_msg "[_ content-portlet.mapped_objects]"
	ad_return_template
    }
}

