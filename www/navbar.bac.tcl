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
    type:optional
    template:optional
    index:optional
} -properties {
} -validate {
} -errors {
}

set page_list [list]
set next_list [list]
set show 0
set width 78
set cat_id 0
set list_categories [list]

set wiki_url [site_node::get_url_from_object_id -object_id $content_id]
if {![string match $page_pos "@page_order@"]} {
    set show 1
   set wiki_folder_id [::xowiki::Page require_folder -name xowiki -package_id $content_id]
    set item_id [content::revision::item_id -revision_id $page_id]
    set my_cat_id [category::get_mapped_categories $item_id]
    set tree_id [category::get_tree $my_cat_id]

    set cat_parent_id [db_string select_parent {
	select parent_id 
	from categories 
	where tree_id = :tree_id 
	and category_id = :my_cat_id} -default 0]
    

    db_foreach categories {
	select category_id 
	from categories 
	where tree_id = :tree_id 
	and parent_id = :cat_parent_id} {
	    set all_cat_name [category::get_name $category_id]
	    lappend list_categories [list $category_id $all_cat_name]
	} 
    
	switch $index {
	    "2" {
		set template_name "es:Template_de_contenido"
		set cat_name "Contenido"
	    }
	    "4" {
		set template_name "es:Template_de_glosario" 
		set cat_name "Glosario"
	    }
	    "1" {
		set template_name "es:Template_de_introduccion" 
		set cat_name "Introduccion"
	    }
	    "3" {
		set template_name "es:Template_de_actividades"
		set cat_name "Actividades"
	    }
	    default {
		set template_name ""
		set cat_name ""
	    }
	    
	}

    foreach category $list_categories {
	if {[string match [lindex $category 1] $cat_name]} {
	    set cat_id [lindex $category 0]
	    break
	}
    }
    
    if {$cat_id eq 0 && $index ne 4 && ![empty_string_p $cat_parent_id]} {
	set cat_id $my_cat_id
    } elseif {($cat_id eq 0 && $index eq 4) || ([empty_string_p $cat_parent_id])} {
	set cat_id [db_list select_all {
	    select category_id 
	    from categories where tree_id = :tree_id}]
    } 

    if {[empty_string_p $cat_id]} {
	set cat_id 0
    }
    
    set template_id [db_string select_temp {
	select ci.item_id 
	from cr_items ci, xowiki_page_template p
	where ci.parent_id = :wiki_folder_id
	and ci.content_type in ('::xowiki::PageTemplate')
	and p.page_template_id = ci.live_revision
	and ci.name = :template_name
    } -default "0"]
    
    set page_list [db_list_of_lists select_content "
	select ci.item_id, p.page_order, ci.name, ci.content_type, category_id, xpi.page_instance_id
	from category_object_map c, cr_items ci, xowiki_page p, xowiki_page_instance xpi
	where c.object_id = ci.item_id and ci.parent_id = :wiki_folder_id
	and ci.content_type not in ('::xowiki::PageTemplate')
	and p.page_id = xpi.page_instance_id
	and category_id in ([join $cat_id ","])
	and xpi.page_template = :template_id
	and xpi.page_instance_id = ci.live_revision
	order by p.page_order
    "]
    
    set order_page [lsort -increasing -command content_compare::compare $page_list]
    set count 0

    if {[llength $order_page] > 0} {
	set next_list [lindex $order_page 0]
	set nexturl "${wiki_url}[lindex $next_list 2]\#cont1"
	if {[lindex $next_list 5] eq $page_id} {
	    set img_name "xop$index"
	} elseif {$template == $template_id} {
	    set img_name "xop${index}"
	} else {
	    set img_name "op$index"
	}

    } else {
	set show 1
	set nexturl "0"
	set img_name "op${index}_"
	if {$index eq 0} {
	    set width 11
	}
    }
} else {
    set show 0
}


