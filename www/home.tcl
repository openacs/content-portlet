ad_page_contract {
    
    
    
    @author byron Haroldo Linares Roman (bhlr@byronLs-Computer.local)
    @creation-date 2007-06-20
    @cvs-id $Id$
} {
    page_pos:optional
    page_id:optional
    content_id:optional

} -properties {
} -validate {
} -errors {
}

set page_list [list]
set show 0
set nexturl ""
set wiki_url [site_node::get_url_from_object_id -object_id $content_id]
if {![string match $page_pos "@page_order@"]} {
    set show 1
    set wiki_folder_id [::xowiki::Page require_folder -name xowiki -package_id $content_id]
    set item_id [content::revision::item_id -revision_id $page_id]
    set cat_id [category::get_mapped_categories $item_id]
    set tree_id [category::get_tree $cat_id]
    set my_parent_id [content_category::category_parent -category_id $cat_id -tree_id $tree_id]
    set my_parent_id1 [content_category::category_parent -category_id $cat_id -level 1 -tree_id $tree_id]
    set tree_list [content_category::get_tree_levels -subtree_id $my_parent_id -to_level 1 $tree_id]

    if {[llength $tree_list] < 1} {
        set show 0
        ad_return_template
    }
    
    set cat_index [lsearch -regexp $tree_list $cat_id]
    if {$cat_index < 0} {
	set cat_index [expr [lsearch -regexp $tree_list $my_parent_id1] + 0]
    }

    set img_name "homeID"
    append  img_name "[expr $cat_index + 1]"

    set home_cat [db_string select_home {
	select distinct c.category_id
        from category_object_map c, cr_items ci, cr_revisions r, xowiki_page p
        where c.object_id = ci.item_id and ci.parent_id = :wiki_folder_id
        and ci.content_type not in ('::xowiki::PageTemplate')
	and ci.name not in ('es:header_page','es:index','es:indexe')
        and r.revision_id = ci.live_revision
        and p.page_id = r.revision_id
        order by category_id asc
	limit 1} -default 0]

    db_foreach select_page {
	select ci.item_id, r.revision_id, ci.name, ci.content_type, r.title, category_id,p.page_order
	from category_object_map c, cr_items ci, cr_revisions r, xowiki_page p
	where c.object_id = ci.item_id and ci.parent_id = :wiki_folder_id
	and ci.content_type not in ('::xowiki::PageTemplate')
	and ci.name not in ('es:header_page','es:index')
	and r.revision_id = ci.live_revision
	and p.page_id = r.revision_id
	and category_id = :home_cat
	order by p.page_order} {
	    
	    lappend page_list [list $item_id $page_order $name $revision_id]
	}
    
    set order_page [lsort -increasing -command content_compare::compare $page_list]
    set home_list [lindex $order_page 0]
    set home_name [lindex $home_list 2]
    set nexturl "${wiki_url}$home_name"
        

} else {
    set show 0
}


