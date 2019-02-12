ad_library {
    
    
    
    @author byron Haroldo Linares Roman (bhlr@byronLs-Computer.local)
    @creation-date 2007-06-21
    @cvs-id $Id$
}

namespace eval content_compare {}
namespace eval content_page {}
namespace eval content_category {}


ad_proc -public content_category::delete_p {
    -tree_id
    -category_id
} {
    set tree_list [content_category::get_tree_levels \
		       -subtree_id $category_id $tree_id]
    set tree_list [linsert $tree_list 0 $category_id]
    foreach category $tree_list {
	set my_category_id [lindex $category 0]
	if {[db_string check_mapped_objects {}] eq 1} {
	    return 0
	}
    }
    return 1
}

ad_proc -private content_page::update_object {
    {-wiki_package_id ""}
} {
    
    if {[empty_string_p $wiki_package_id]} {
        set wiki_package_list [xowiki::Package instances]
    } else {
        set wiki_package_list [list $wiki_package_id]
    }
    foreach wiki_package_id $wiki_package_list {
	set wiki_folder_id [::xowiki::Page require_folder \
                                -name xowiki \
                                -package_id $wiki_package_id]
	
	if { [db_0or1row select_instance [::xowiki::Object \
					instance_select_query \
					-folder_id $wiki_folder_id \
					-select_attributes {name} \
					      -where_clause "name ='es:o_index'"]]} {
	set template_id $item_id
	
        set myobject [xowiki::Package instantiate_page_from_id -item_id $item_id]

        set text [list {proc content {} {
set community_id [dotlrn_community::get_community_id]
set com_package_id [dotlrn_community::get_package_id $community_id]
set package_id [site_node_apm_integration::get_child_package_id \
				-package_id $com_package_id \
				-package_key "xowiki"]

set wk_folder_id [::xowiki::Page require_folder -name xowiki -package_id $package_id]
if { ![db_0or1row select_instance [::xowiki::PageInstance instance_select_query \
				       -folder_id $wk_folder_id -select_attributes {name} \
				       -where_clause "name = 'es:header_page'"]]} {
    
    db_0or1row select_instance [::xowiki::PageTemplate instance_select_query \
				    -folder_id $wk_folder_id -select_attributes {name} \
				    -where_clause "name = 'es:Template_de_header'"]
    set tmp_item_id $item_id
    
    set fn "[acs_root_dir]/packages/content-portlet/www/prototypes/gestemplate/GesTemplateheaderpage.page"
    set standard_page "es:header_page"
    if {[file readable $fn]} {
	set page [source $fn]
	$page configure -name $standard_page -parent_id $wk_folder_id -package_id $package_id
	if {![$page exists title]} {
	    $page set title $template1
	}
	$page set page_template $tmp_item_id
	$page destroy_on_cleanup
	$page set instance_attributes "Curso Curso Carrera Carrera Facultad Facultad"
	$page initialize_loaded_object
	$page save_new
    }
}

set user_id [ad_conn user_id]
set admin_p [dotlrn::user_can_admin_community_p -user_id $user_id -community_id [dotlrn_community::get_community_id]]
if {$admin_p} {
    return {
	<p>
	#content-portlet.welcome#
	</p>
	<p>
	#content-portlet.welcome_body#
	</p>
	<br />[[es:header_page|#content-portlet.edit_header#]]
    }
} else {
    return {
	<p>
	#content-portlet.e_welcome#
	</p>
	<p>
	#content-portlet.e_welcome_body#
	</p>
    }
}
}
}]

$myobject set text [lindex $text 0]
$myobject destroy_on_cleanup
$myobject save
$myobject initialize_loaded_object
ns_cache flush xotcl_object_cache ::[$myobject set item_id]
}
}
}


ad_proc -private content_category::up {
    {-wiki_package_id ""}
    {-level 1}
} {
 
    set count 0
    if {[empty_string_p $wiki_package_id]} {
	set wiki_package_list [xowiki::Package instances]
    } else {
	set wiki_package_list [list $wiki_package_id]
    }
    foreach wiki_package_id $wiki_package_list {
	ns_log notice "inicia actualizacion de content"
	set trees [category_tree::get_mapped_trees $wiki_package_id]
	set tree_id [lindex [lindex $trees 0] 0]
	set wiki_folder_id [::xowiki::Page require_folder \
				-name xowiki \
				-package_id $wiki_package_id]
	
	if {$level eq 1} {
	    set tree_list [content_category::get_tree_levels $tree_id]
	} else {
	    set tree_list [content_category::get_tree_levels -only_level 2 $tree_id]
	}
	
	set wiki_url [site_node::get_url_from_object_id \
			  -object_id $wiki_package_id]
	set community_id [dotlrn_community::get_community_id_from_url -url $wiki_url]
	
	set instructors [dotlrn_community::list_users_in_role \
			     -rel_type  "dotlrn_instructor_rel" $community_id]
	
	set instructor_id [lindex [lindex $instructors 0] 3]
	
	set new_tree_id [content_category::map_new_tree -object_id $wiki_package_id \
			     -tree_name "Indice De Contenido." \
			     -user_id $instructor_id]
	    
	set new_tree_list [content_category::get_tree_levels \
			       -only_level 2 $new_tree_id]
	
	    
	ns_log notice " Package_id $wiki_package_id $tree_list :: $new_tree_list"
	foreach category $tree_list {
	    set cat_id [lindex $category 0]
	    set new_cat_id [lindex [lindex $new_tree_list $count] 0]
	    db_foreach select_content {
		select ci.item_id, p.page_order,
		ci.name, ci.content_type, category_id, xpi.page_instance_id
		from category_object_map c, cr_items ci, xowiki_page p,
		xowiki_page_instance xpi
		where c.object_id = ci.item_id
		and ci.parent_id = :wiki_folder_id
		and ci.content_type not in ('::xowiki::PageTemplate')
		and p.page_id = xpi.page_instance_id
		and category_id = :cat_id
		and xpi.page_instance_id = ci.live_revision
		order by p.page_order} {
		    ns_log notice "--------- -object_id $item_id $new_cat_id "
		    category::map_object -remove_old -object_id $item_id $new_cat_id
		}
	    incr count
	}
	
	set count 0
		
	foreach tree $trees {
	    set tree_id [lindex $tree 0]
	    category_tree::unmap -tree_id $tree_id -object_id $wiki_package_id
	}
	
	db_0or1row select_instance [::xowiki::PageTemplate instance_select_query \
					-folder_id $wiki_folder_id \
					-select_attributes {name} \
					-where_clause "name = 'es:Template_de_ges'"]
	
	set template_id $item_id
	
	set template [xowiki::Package instantiate_page_from_id -item_id $item_id]
	
	set text [list {
	    <div class="btbody">	   
 {{adp /packages/xowiki/www/admin/order {page_pos @page_order@ page_id @revision_id@ content_id @package_id@ type @object_type@ dir "decreasing" action 0 page_name @name@ status @publish_status@}}}
<div align="center">
  <table width="750" border="0" cellspacing="0" cellpadding="0">
    <tr>
	    <td colspan="3">{{adp portlets/wiki {name header_page skin plain-include}}}</td>
    </tr>
    <tr>
	    <td colspan="3" align="left">{{adp /packages/content-portlet/www/unit-navbar {page_id @revision_id@ content_id @package_id@}}}</td>
    </tr>
    <tr>
      <td colspan="3"><table width="750" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td  rowspan="3" valign="bottom">{{adp /packages/content-portlet/www/complete-navbar {page_pos @page_order@ page_id @revision_id@ content_id @package_id@ type @object_type@}}}</td></tr>
          <tr>
            <td width="27" valign="bottom"><img src="/resources/content-portlet/template/imagenes/upcornerL.gif" width="27" height="7" /></td>
            <td valign="bottom" class="sobretit"><img src="/resources/content-portlet/template/imagenes/fsobretit.gif" width="16" height="7" /></td>
          </tr>
      </table></td>
    </tr>
	    {{adp /packages/content-portlet/www/complete-titlebar {page_pos @page_order@ page_id @revision_id@ content_id @package_id@ my_title {@title@}}}}
      <tr>
      <td width="27"><img src="/resources/content-portlet/template/imagenes/bcornerL.gif" width="27" height="21" /></td>
	    <td class="below" align="left">{{adp /packages/content-portlet/www/complete-subnavbar {page_pos @page_order@ page_id @revision_id@ content_id @package_id@ type @object_type@}}}</td>
      <td width="28"><img src="/resources/content-portlet/template/imagenes/bcornerR.gif" width="28" height="21" /></td>
    </tr>
    <tr>
      <td width="27" class="sideL"><img src="/resources/content-portlet/template/imagenes/fondoL.gif" width="27" height="11" /></td>
      <td valign="top" class="contenido">@contenido@<br></td>
      <td width="28" class="sideR"><img src="/resources/content-portlet/template/imagenes/fondoR.gif" width="28" height="11" /></td>
    </tr>
    <tr>
      <td width="27"><img src="/resources/content-portlet/template/imagenes/cornerDL.gif" width="27" height="34" /></td>
      <td class="down"><img src="/resources/content-portlet/template/imagenes/fondoDown.gif" width="16" height="34" /></td>
      <td width="28"><img src="/resources/content-portlet/template/imagenes/cornerDR.gif" width="28" height="34" /></td>
    </tr>
  </table>
</div>
</div>
	}]

	$template set text $text
	$template destroy_on_cleanup
	$template save 
	$template initialize_loaded_object
    }
}



ad_proc -public content_category::page_order {
    -tree_id
    -category_id
    -wiki_folder_id
} {
    set tree_list [content_category::get_tree_levels \
		       -subtree_id $category_id $tree_id]
    set tree_list [linsert $tree_list 0 $category_id]
    foreach cat_tree $tree_list {
	set cat_id [lindex $cat_tree 0]
	set page_list [db_list_of_lists select_content {}]
	
	if {[llength $page_list] > 0} {
	    #set next_list [lindex $order_page 0]
	    #set nexturl "${wiki_url}[lindex $next_list 2]\\\#cont1"
	    break
	}
    }
    return $page_list
}


ad_proc -public content_category::category_childs {
    -tree_id
    -category_id
    -wiki_folder_id
} {
    
    set tree_list [content_category::get_tree_levels -subtree_id $category_id $tree_id]
    set tree_list [linsert $tree_list 0 [list $category_id "n"]]
    foreach category $tree_list {
	set cat_id [lindex $category 0]
	set count [db_string select_cat {*SQL*} -default 0]
	if {$count > 0} {
	    return 1
	} 
    }
    return 0
}


ad_proc -public content_category::category_delete {
    tree_id
    category_ids
    {locale ""}
} {
  
    set user_id [auth::get_user_id]
    permission::require_permission \
	-object_id $tree_id \
	-privilege category_tree_write
    
    set result 1
    db_transaction {
	foreach category_id [db_list order_categories_for_delete ""] {
	    category::delete $category_id
	}
	category_tree::flush_cache $tree_id
    } on_error {
	set result 0
    }
    return $result
}

ad_proc -private content_category::valid_level_and_count {
    -tree_id
    -category_id
} {
    set tree_list [content_category::get_tree_levels $tree_id]
    set my_level [lindex \
		      [lindex $tree_list \
			   [lsearch -regexp \
				$tree_list $category_id]] \
		      3]
    
    if {$my_level > 2} {
	return 0
    }
    set sub_tree_list [content_category::get_tree_levels -only_level 1 \
			   -subtree_id $category_id $tree_id]

    if {[llength $sub_tree_list] >= 5} {
	return 0
    }
    return 1
}


ad_proc -private content_category::map_new_tree {
    -object_id
    -tree_name
    {-user_id ""}
} {
    
    if {[empty_string_p $user_id]} {
        set user_id [ad_conn user_id]
    }
    
    db_transaction {
	set tree_id [category_tree::add -name $tree_name -user_id $user_id]
	content_category::new_subtree -tree_id $tree_id -user_id $user_id
	category_tree::map -tree_id $tree_id \
	    -object_id $object_id \
	    -assign_single_p t \
	    -require_category_p t
    }
    return $tree_id
}


ad_proc -private content_category::new_subtree {
    -tree_id
    {-language "es_GT"}
    {-user_id ""}
} {

    if {[empty_string_p $user_id]} {
        set user_id [ad_conn user_id]
    }
    set description "New unit for content"
    set parent_id ""
    set unit_id [category::add -tree_id $tree_id \
		     -parent_id $parent_id \
		     -locale $language \
		     -name "Unidad N" \
		     -user_id $user_id \
		     -description $description]

    foreach cat_name {Introduccion Contenido Actividades Glosario Anexo} {
    
	category::add -tree_id $tree_id \
	    -parent_id $unit_id \
	    -locale $language \
	    -name $cat_name \
	    -user_id $user_id \
	    -description $description
    }

    return $unit_id
}

ad_proc -private content_category::category_parent {
    -category_id
    -tree_id
    {-level 0}
} {
    

    if {[db_0or1row select_parent {
	select parent_id, category_id as category from categories 
	where category_id = :category_id
	and tree_id = :tree_id
    }]} {
	
       	if {![empty_string_p $parent_id] && $level eq 0} {
	    return [content_category::category_parent -category_id $parent_id -tree_id $tree_id]
	} elseif {![empty_string_p $parent_id] && $level ne 0} {
	    return $parent_id
	} else {
	    return $category
	}
    }
}
		      
	  
		  
ad_proc -public content_compare::value_compare {
    x
    y
    def
} {
    set xp [string first . $x]
    set yp [string first . $y]
    if {$xp == -1 && $yp == -1} {
	if {$x < $y} {
	    return -1
	} elseif {$x > $y} {
	    return 1
	} else {
	    return $def
	}
    } elseif {$xp == -1} {
	set yh [string range $y 0 [expr {$yp-1}]]
	return [value_compare $x $yh -1]
    } elseif {$yp == -1} {
	set xh [string range $x 0 [expr {$xp-1}]]
	return [value_compare $xh $y 1]
    } else {
	set xh [string range $x 0 $xp]
	set yh [string range $y 0 $yp]
	if {$xh < $yh} {
	    return -1
	} elseif {$xh > $yh} {
	    return 1
	} else {
	    incr xp
	    incr yp
	    #puts "rest [string range $x $xp end] [string range $y $yp
	    # end]"                                                                                                     
	    return [value_compare [string range $x $xp end] [string range $y $yp end] $def]
	}
    }
}

ad_proc -public content_compare::compare {
    a 
    b
} {
    set x [lindex $a 1]
    set y [lindex $b 1]
    return [content_compare::value_compare $x $y 0]
}

ad_proc -public content_compare::simple_compare {
 a
 b

} {
    return [content_compare::value_compare $a $b 0]
}

ad_proc -public content_category::get_tree_levels {
    -all:boolean
    {-subtree_id ""}
    {-to_level 0}
    {-only_level 0}
    tree_id
    {locale ""}
} {
    Get all categories of a category tree from the cache.
    
    @option all Indicates that phased_out categories should be included.
    @option subtree_id Return only categories of the given subtree.
    @param tree_id category tree to get the categories of.
    @param locale language in which to get the categories. [ad_conn locale] used by default.
    @return tcl list of lists: category_id category_name deprecated_p level
} {
    if {[catch {set tree [nsv_get category_trees $tree_id]}]} {
	return
    }
    if {$to_level ne 0 && $only_level ne 0} {
	set only_level 0
    }
    set result ""
    if {[empty_string_p $subtree_id]} {
	foreach category $tree {
	    util_unlist $category category_id deprecated_p level
	    if {$all_p || $deprecated_p == "f"} {
		if {$to_level < $level && $to_level ne 0} {
		    continue
		}
		if {$only_level ne $level && $only_level ne 0} {
		    continue
		}
		lappend result [list $category_id [category::get_name $category_id $locale] $deprecated_p $level]
	    }
	}
    } else {
	set in_subtree_p 0
	set subtree_level 0
	foreach category $tree {
	    util_unlist $category category_id deprecated_p level
	    if {$level == $subtree_level || $level < $subtree_level} {
		set in_subtree_p 0
	    }
	    if {$in_subtree_p && $deprecated_p == "f"} {
		if {$to_level < [expr $level - $subtree_level] && $to_level ne 0} {
		    continue
		}
		
		if {$only_level ne [expr $level - $subtree_level] && $only_level ne 0} {
		    continue
		}
		
		lappend result [list $category_id [category::get_name $category_id $locale] $deprecated_p [expr $level - $subtree_level]]
	    }
	    if {$category_id == $subtree_id} {
		set in_subtree_p 1
		set subtree_level $level
	    }
	}
    }
    
    return $result
}
