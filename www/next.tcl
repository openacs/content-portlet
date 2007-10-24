# 

ad_page_contract {
    
    
    
    @author byron Haroldo Linares Roman (bhlr@byronLs-Computer.local)
    @creation-date 2007-06-20
    @arch-tag: 71F81219-A45B-4B17-BF48-22942B62A7AC
    @cvs-id $Id$
} {
    page_pos:optional
    page_id:optional
    content_id:optional
    wiki_folder_id:optional
    dir:optional
} -properties {
} -validate {
} -errors {
}

set page_list [list]
set show 0
set next_list [list]
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

    db_foreach select_page {
    select ci.item_id, r.revision_id, ci.name, ci.content_type, r.title, category_id,p.page_order  
    from category_object_map c, cr_items ci, cr_revisions r, xowiki_page p 
    where c.object_id = ci.item_id and ci.parent_id = :wiki_folder_id
    and ci.content_type not in ('::xowiki::PageTemplate')
    and ci.name not in ('es:header_page','es:index','es:indexe')
    and r.revision_id = ci.live_revision
    and p.page_id = r.revision_id
    and category_id = :cat_id
    order by p.page_order} {

	lappend page_list [list $item_id $page_order $name $revision_id]
    }    

    
    set order_page [lsort -$dir -command content_compare::compare $page_list]
    set count 0
    foreach pages $order_page {
	set current_pos [lsearch -exact $pages $page_id]
	if {$current_pos >= 0} {
	    incr count
	    set next_list [lindex $order_page $count]
	    break
	}
	incr count
    }
    
    if {[llength $next_list] > 0} {
	set nexturl "${wiki_url}[lindex $next_list 2]"
	switch $dir {
	    "decreasing" {
		set img_name "backID"
		set alt "[_ content-portlet.back]"
	    }
	    "increasing" {
		set img_name "nextID"
		set alt "[_ content-portlet.next]"
	    }
	}
	append  img_name "[expr $cat_index + 1]"
    } else {
	set show 0
	set nexturl "index"
	set img_name ""
    }
} else {
    set show 0
}


