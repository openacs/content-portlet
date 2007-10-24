# 

ad_page_contract {
    
    
    
    @author byron Haroldo Linares Roman (bhlr@byronLs-Computer.local)
    @creation-date 2007-06-25
    @arch-tag: E81B62CE-430F-4586-9DFA-2AC7C57672D6
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

set page_list [list]
set next_list [list]
if {![string match $page_pos "@page_order@"]} {
    set wiki_url "[site_node::get_url_from_object_id -object_id $content_id]$page_name"
    set wiki_folder_id [::xowiki::Page require_folder -name xowiki -package_id $content_id]
    set item_id [content::revision::item_id -revision_id $page_id]
    set cat_id [category::get_mapped_categories $item_id]

    if {![ permission::permission_p -object_id $item_id -privilege admin]} {
	set show 0
    } else {
	
	db_foreach select_page {
	select ci.item_id as tmp_item_id, r.revision_id, ci.name, ci.content_type, r.title, category_id,p.page_order, ci.publish_status
	from category_object_map c, cr_items ci, cr_revisions r, xowiki_page p
	where c.object_id = ci.item_id and ci.parent_id = :wiki_folder_id
	and ci.content_type not in ('::xowiki::PageTemplate')
	and ci.name not in ('es:header_page','es:index','es:indexe')
	and r.revision_id = ci.live_revision
	and p.page_id = r.revision_id
	and category_id = :cat_id
	order by p.page_order} {
	    
	    lappend page_list [list $tmp_item_id $page_order $name $revision_id $publish_status]
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
	
	if {$action == 0} {
	    set show 1
	    switch $dir {
		"decreasing" {
		    set img_name "up"
		}
		"increasing" {
		    set img_name "down"
		}
	    }
	    set nexturl [export_vars -base admin/toggle-page-order {page_id page_pos page_name content_id status dir {action 1} {show 0}}]
	    set alt "[_ content-portlet.page_${dir}]"
	} elseif {$action == 1} {
	    
	    set tmp_order [lindex $next_list 1]
	    set tmp_item_id [lindex $next_list 0]
	    set tmp_page_id [lindex $next_list 3]
	    set tmp_status [lindex $next_list 4]
	    db_dml update_page {
		UPDATE xowiki_page 
		SET page_order = :tmp_order where page_id = :page_id
	    }
	    
	    ns_cache flush xotcl_object_cache ::$item_id
	    ns_cache flush xotcl_object_cache ::$page_id
	    db_0or1row make_live {
		select content_item__set_live_revision(:page_id, :status)
	    }
	    

	    db_dml update_page {
		UPDATE xowiki_page
	    SET page_order = :page_pos where page_id = :tmp_page_id
	}
	    
	    
	    ns_cache flush xotcl_object_cache ::$tmp_item_id
	    ns_cache flush xotcl_object_cache ::$tmp_page_id
	    db_0or1row make_live {
		select content_item__set_live_revision(:tmp_page_id, :tmp_status)
	    }

	    ad_returnredirect "${wiki_url}\#cont1"
	}
    } else {
	set show 0
    }
    }
} else {
    set show 0
}
