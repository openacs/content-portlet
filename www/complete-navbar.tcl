# 

ad_page_contract {
    
    
    
    @author byron Haroldo Linares Roman (bhlr@byronLs-Computer.local)
    @creation-date 2007-07-04
    @arch-tag: D0597C30-DD00-4D59-BD57-56ED6E0F16A7
    @cvs-id $Id$
} {
    
    page_pos:optional
    page_id:optional
    content_id:optional
    type:optional
    index:optional
    

} -properties {
} -validate {
} -errors {
}


set title "navbar"
set cat_index [list]
set index1 100
set index2 100
set index3 100
set index4 100
set index5 100
set index6 100
set wiki_url [site_node::get_url_from_object_id -object_id $content_id]
if {![string match $page_pos "@page_order@"]} {
    set show 1
    set wiki_folder_id [::xowiki::Page require_folder -name xowiki -package_id $content_id]
    set item_id [content::revision::item_id -revision_id $page_id]
    set my_cat_id [category::get_mapped_categories $item_id]
    set tree_id [category::get_tree $my_cat_id]
    set my_parent_id [content_category::category_parent -category_id $my_cat_id -tree_id $tree_id]
    set tree_list [content_category::get_tree_levels -subtree_id $my_parent_id -to_level 1 $tree_id]

    if {[llength $tree_list] < 1} {
	set show 0
	ad_return_template
    }
    
    set my_cat_index [expr [lsearch -regexp $tree_list $my_cat_id] + 1]

    set categories_objects [db_list_of_lists select_cat {
	select count(ci.item_id), c.category_id
	from category_object_map c, cr_items ci, cr_revisions r, xowiki_page p
	where c.object_id = ci.item_id and ci.parent_id = :wiki_folder_id
	and ci.content_type not in ('::xowiki::PageTemplate')
	and ci.name not in ('es:header_page','es:index','es:indexe')
	and r.revision_id = ci.live_revision
	and p.page_id = r.revision_id
	group by category_id
	order by category_id desc}]
    
    for {set i [expr [llength $tree_list] -1]} {$i >= 0} {incr i -1} {
	set category [lindex $tree_list $i]
	if {[content_category::category_childs \
		 -tree_id $tree_id \
		 -category_id [lindex $category 0] \
		 -wiki_folder_id $wiki_folder_id]} {
	    lappend cat_index [lsearch -regexp $tree_list [lindex $category 1]]
	}
    }    

    if {[llength $cat_index] < 1} {
	set show 0
    }
    for {set i 0} {$i < 6} {incr i} {
	set adp_index [expr $i + 1]
	if {$i < [llength $cat_index]} {
	    set index$adp_index [expr [lindex $cat_index $i] + 1]
	} elseif {$i eq [llength $cat_index]} { 
	    set index$adp_index 0
	} else {
	    set index$adp_index 100
	}
    }
    if {$index1 eq $my_cat_index} {
	set img_rigth "xop005"
    } else {
	set img_rigth "op005"
    }
} else {
    set show 0
}

