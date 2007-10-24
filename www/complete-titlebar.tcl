# 

ad_page_contract {
    
    
    
    @author byron Haroldo Linares Roman (bhlr@byronLs-Computer.local)
    @creation-date 2007-07-18
    @arch-tag: 8085F7B0-7E09-43A8-BDEF-B42D9C90D5CC
    @cvs-id $Id$
} {
    page_pos:optional
    page_id:optional
    content_id:optional
    my_title:optional
    type:optional

} -properties {
} -validate {
} -errors {
}



set title "title bar"

set wiki_url [site_node::get_url_from_object_id -object_id $content_id]
if {![string match $page_pos "@page_order@"]} {
    set show 1
    set wiki_folder_id [::xowiki::Page require_folder -name xowiki -package_id $content_id]
    set item_id [content::revision::item_id -revision_id $page_id]
    set my_cat_id [category::get_mapped_categories $item_id]
    set cat_name [category::get_name $my_cat_id]
    set tree_id [category::get_tree $my_cat_id]
    set my_parent_id [content_category::category_parent -category_id $my_cat_id -tree_id $tree_id]
    set my_parent_id1 [content_category::category_parent -category_id $my_cat_id -level 1 -tree_id $tree_id]
        set tree_list [content_category::get_tree_levels -subtree_id $my_parent_id -to_level 1 $tree_id]
    
    if {[llength $tree_list] < 1} {
        set show 0
        ad_return_template
    }

    set cat_index [expr [lsearch -regexp $tree_list $my_cat_id] + 1]
    if {$cat_index eq 0} {
        set cat_index [expr [lsearch -regexp $tree_list $my_parent_id1] + 1]
    }
    set cat_name [lindex [lindex $tree_list [expr $cat_index -1 ]] 1]

set show_img 0
    switch $cat_index {
        "2" {
            if {[string match $cat_name "Contenido"]} {
                set show_img 1
            }
        }
        "4" {
            if {[string match $cat_name "Glosario"]} {
                set show_img 1
            }
        }
        "1" {
            if {[string match $cat_name "Introduccion"]} {
                set show_img 1
            }
        }
        "3" {
            if {[string match $cat_name "Actividades"]} {
                set show_img 1
            }
        }
        default {
            set show_img 0
        }

    }


} else {
    set show 0
}
