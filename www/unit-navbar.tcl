# 

ad_page_contract {
    
    
    
    @author byron Haroldo Linares Roman (bhlr@byronLs-Computer.local)
    @creation-date 2007-09-06
    @arch-tag: D9C9886F-7A0B-46DA-8A52-71713DEDC859
    @cvs-id $Id$
} {
    
    page_pos:optional
    page_id:optional
    content_id:optional
    index:optional


} -properties {
} -validate {
} -errors {
}
set show 0
set wiki_url [site_node::get_url_from_object_id -object_id $content_id]
if {![string match $page_id "@revision_id@"]} {
    set show 1

    set form_tree_list [list]

    set wiki_folder_id [::xowiki::Page require_folder -name xowiki -package_id $content_id]
    set item_id [content::revision::item_id -revision_id $page_id]
    set my_cat_id [category::get_mapped_categories $item_id]
    set tree_id [category::get_tree $my_cat_id]
    set my_parent_id [content_category::category_parent -category_id $my_cat_id -tree_id $tree_id]
    set my_parent_id1 [content_category::category_parent -category_id $my_cat_id -level 1 -tree_id $tree_id]
    
    set tree_list [content_category::get_tree_levels -only_level 1 $tree_id]

    set categories_objects [db_list_of_lists select_cat {
        select count(ci.item_id), c.category_id
        from category_object_map c, cr_items ci, cr_revisions r, xowiki_page p
        where c.object_id = ci.item_id and ci.parent_id = :wiki_folder_id
        and ci.content_type not in ('::xowiki::PageTemplate')
        and ci.name not in ('es:header_page','es:index','es:indexe')
        and r.revision_id = ci.live_revision
        and p.page_id = r.revision_id
        group by category_id
        order by category_id asc}]



    foreach tree_level $categories_objects {
	set unit_parent [content_category::category_parent \
			     -category_id [lindex $tree_level 1] \
			     -tree_id $tree_id]
    set unit_index [lsearch -regexp $tree_list $unit_parent]

    if {$unit_index >= 0 && [lsearch -regexp $form_tree_list $unit_parent] < 0} {
	    lappend form_tree_list [list [lindex [lindex $tree_list $unit_index] 1] [lindex [lindex $tree_list $unit_index] 0]]
	}
    }
    ad_form -name unidad -has_submit 1 -export {tree_id} -form {
	{category:integer(select)
	    {label "Capitulo"}
	    {options $form_tree_list}
	    {value $my_parent_id}
	    {html {onChange document.unidad.submit()}}
	}
    } -on_submit {
	set nexturl "\#"
	set tree_list2 [content_category::get_tree_levels -subtree_id $category $tree_id]
	set tree_list2 [linsert $tree_list2 0 $category]
	foreach cat_tree $tree_list2 {
	    set cat_id [lindex $cat_tree 0]
	    
	    set page_list [db_list_of_lists select_content "
            select ci.item_id, p.page_order, ci.name, ci.content_type, category_id, xpi.page_instance_id
	    from category_object_map c, cr_items ci, xowiki_page p, xowiki_page_instance xpi
	    where c.object_id = ci.item_id and ci.parent_id = :wiki_folder_id
	    and ci.content_type not in ('::xowiki::PageTemplate')
	    and ci.name not in ('es:header_page','es:index','es:indexe')
	    and p.page_id = xpi.page_instance_id
	    and category_id in ([join $cat_id ","])
	    and xpi.page_instance_id = ci.live_revision
	    order by p.page_order"]
	    
	    set order_page [lsort -increasing -command content_compare::compare $page_list]

	    if {[llength $order_page] > 0} {
		set next_list [lindex $order_page 0]
		set nexturl "${wiki_url}[lindex $next_list 2]\#cont1"
		break
	    }
	}
	ad_returnredirect $nexturl
    }
} 