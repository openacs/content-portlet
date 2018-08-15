ad_library {
    
    
    
    @author byron Haroldo Linares Roman (bhlr@byronLs-Computer.local)
    @creation-date 2007-09-08
    @cvs-id $Id$
}

namespace eval content-portlet::apm {}

ad_proc -public content-portlet::apm::after_upgrade {
    {-from_version_name:required}
    {-to_version_name:required}
} {
    apm_upgrade_logic \
        -from_version_name $from_version_name \
        -to_version_name $to_version_name \
        -spec {
	    0.1d2 0.1d3 {
		set count 0
		set instructor_id ""
		set wiki_package_list [xowiki::Package instances]
		foreach wiki_package_id $wiki_package_list {
		    set trees [category_tree::get_mapped_trees $wiki_package_id]
		    set tree_id [lindex [lindex $trees 0] 0]
		    set wiki_folder_id [::xowiki::Page require_folder \
					    -name xowiki \
					    -package_id $wiki_package_id]
		    set tree_list [category_tree::get_tree_levels $tree_id]



		    set wiki_url [site_node::get_url_from_object_id \
				      -object_id $wiki_package_id]
		    set community_id [dotlrn_community::get_community_id_from_url \
					  -url $wiki_url]
		    
		    set instructors [dotlrn_community::list_users_in_role \
					 -rel_type "dotlrn_instructor_rel" $community_id]

		    set instructor_id [lindex [lindex $instructors 0] 3]

		    set new_tree_id [content_category::map_new_tree \
					 -object_id $wiki_package_id \
					 -tree_name "Indice De Contenido" \
					 -user_id $instructor_id]

		    set new_tree_list [category_tree::get_tree_levels \
					   -only_level 2 $new_tree_id]
		    
		    foreach category $tree_list {
			set cat_id [lindex $category 0]
			set new_cat_id [lindex [lindex $new_tree_list $count] 0]
			db_foreach select_content {
			    select ci.item_id, p.page_order,
			    ci.name, ci.content_type, category_id,
			    xpi.page_instance_id
			    from category_object_map c, cr_items ci,
			    xowiki_page p,
			    xowiki_page_instance xpi
			    where c.object_id = ci.item_id
			    and ci.parent_id = :wiki_folder_id
			    and ci.content_type not in ('::xowiki::PageTemplate')
			    and p.page_id = xpi.page_instance_id
			    and category_id = :cat_id
			    and xpi.page_instance_id = ci.live_revision
			    order by p.page_order} {
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
	    
	}

}
