ad_page_contract {
    
    
    
    @author byron Haroldo Linares Roman (bhlr@byronLs-Computer.local)
    @creation-date 2007-07-04
    @cvs-id $Id$
} {
    
    page_id:optional
    page_pos:optional
    page_name:optional
    content_id:optional
    status:optional
    dir:optional
    show:optional
    {action 0}


} -properties {
} -validate {
} -errors {
}

if {![string match $page_pos "@page_order@"]} {
    set wiki_folder_id [::xowiki::Page require_folder -name xowiki -package_id $content_id]
    set item_id [content::revision::item_id -revision_id $page_id]
    if {![ permission::permission_p -object_id $item_id -privilege admin]} {
        set show 0
    } else {

	set my_cat_id [category::get_mapped_categories $item_id]
	
	set count_page [db_string select_count {
	    select count(ci.item_id)
	    from category_object_map c, cr_items ci, cr_revisions r, xowiki_page p
	    where c.object_id = ci.item_id and ci.parent_id = :wiki_folder_id
	    and ci.content_type not in ('::xowiki::PageTemplate')
	    and ci.name not in ('es:header_page','es:index','es:indexe')
	    and r.revision_id = ci.live_revision
	    and p.page_id = r.revision_id
	    and category_id = :my_cat_id} -default 0]
	
	if {$count_page > 1} {
	    set show 1
	} else {
	    set show 0
	}
    }
} else {
    set show 0
}

