ad_page_contract {
    
    
    
    @author byron Haroldo Linares Roman (bhlr@byronLs-Computer.local)
    @creation-date 2007-09-03
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


set page_list [list]
set next_list [list]
set show 0
set width 76
set cat_id 0
set list_categories [list]

set wiki_url [site_node::get_url_from_object_id -object_id $content_id]
if {![string match $page_pos "@page_order@"]} {
    set show 1
    set wiki_folder_id [::xowiki::Page require_folder -name xowiki -package_id $content_id]
    set item_id [content::revision::item_id -revision_id $page_id]
    set my_cat_id [category::get_mapped_categories $item_id]
    set tree_id [category::get_tree $my_cat_id]
    set my_parent_id [content_category::category_parent -category_id $my_cat_id -tree_id $tree_id] 
    set my_parent_id1 [content_category::category_parent -category_id $my_cat_id -level 1 -tree_id $tree_id]

    set tree_list [content_category::get_tree_levels -subtree_id $my_cat_id -to_level 1 $tree_id]
    set level_2_list [content_category::get_tree_levels -only_level 2 $tree_id]
    set level_3_list [content_category::get_tree_levels -only_level 3 $tree_id]

    if {[llength $level_3_list] < 1 || ([lsearch -regexp $level_2_list $my_cat_id] < 0 && [lsearch -regexp $level_3_list $my_cat_id] < 0)} {
	set show 0
	ad_return_template
    } elseif {[lsearch -regexp $level_3_list $my_cat_id] >= 0} {
	set tree_list [content_category::get_tree_levels -subtree_id $my_parent_id1 -to_level 1 $tree_id]
    }

    if {[llength $tree_list] < 1} {
        set show 0
        ad_return_template
    }

    set parent_tree_list [content_category::get_tree_levels -subtree_id $my_parent_id -to_level 1 $tree_id]
    if {[llength $parent_tree_list] < 1} {
        set show 0
        ad_return_template
    }

    set parent_cat_index [expr [lsearch -regexp $parent_tree_list $my_cat_id] + 1]
    if {$parent_cat_index eq 0} {
        set parent_cat_index [expr [lsearch -regexp $parent_tree_list $my_parent_id1] + 1]
    }

    set bar_category [lindex $tree_list [expr $index - 1]]
    set cat_name [lindex $bar_category 1] 
    set cat_id [lindex $bar_category 0]
    if {[empty_string_p $cat_id]} {
        set cat_id 0
    }

    set page_list [db_list_of_lists select_content "
        select ci.item_id, p.page_order, ci.name, ci.content_type, category_id, xpi.page_instance_id
        from category_object_map c, cr_items ci, xowiki_page p, xowiki_page_instance xpi
        where c.object_id = ci.item_id and ci.parent_id = :wiki_folder_id
        and ci.content_type not in ('::xowiki::PageTemplate')
        and ci.name not in ('es:header_page','es:index','es:indexe')
        and p.page_id = xpi.page_instance_id
        and category_id in ([join $cat_id ","])
        and xpi.page_instance_id = ci.live_revision
        order by p.page_order
    "] 

    set order_page [lsort -increasing -command content_compare::compare $page_list]
    
    if {[llength $order_page] > 0} {  
	set next_list [lindex $order_page 0]
        set nexturl "${wiki_url}[lindex $next_list 2]\#cont1"
	if {([lindex $next_list 5] eq $page_id) || ($cat_id eq $my_cat_id) || ($my_parent_id1 eq $cat_id)} {
	    append parent_cat_index "_"
        } else {
            set img_name "op$index"
            set img_name2 "op1_"
        }

    } else {
	set nexturl "0"
	set show 0
    }
}
