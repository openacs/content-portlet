ad_page_contract {
    
    
    
    @author byron Haroldo Linares Roman (bhlr@byronLs-Computer.local)
    @creation-date 2007-08-24
    @cvs-id $Id$
} {
    tree_id:optional
    package_id:optional
    {new_cat 0}
    {parent_cat 0}
} -properties {
} -validate {
} -errors {
}


set ah_sources [ah::js_sources]
if {![exists_and_not_null tree_id] && [exists_and_not_null package_id]} {
    set tree_id [lindex [lindex [category_tree::get_mapped_trees $package_id] 0] 0]
}



set user_id [ad_maybe_redirect_for_registration]
set package_id [ad_conn package_id]
permission::require_permission -object_id $tree_id -privilege category_tree_write

set tree_list [category_tree::get_tree $tree_id]
array set tree [category_tree::get_data $tree_id]
set class "liClosed"

set tmp_level 1
set title "\#content-portlet.edit_index\#"
set context_bar [list [_ content-portlet.edit_index]]
set return_url [ad_return_url]
set root_add_link "category-add-edit?tree_id=${tree_id}&name=Root&mode=3&return_url=$return_url"

set level_1_tree ""
set level_2_tree ""
set level_list [list]
set aux_level 0
set my_tmp_level 0
set inplaceeditor_js ""

set msg_fade [ah::effects -element "msg_div" \
                                   -effect "Fade" \
		       -options "duration: 1.5"]

set msg_fade_0 [ah::effects -element "msg_div" \
                                   -effect "Fade" \
		       -options "duration: 0"]

set msg_appear [ah::effects -element "msg_div" \
                                  -effect "Appear" \
			 -options "duration: 0.5"]

set msg2_fade [ah::effects -element "msg_div2" \
                                   -effect "Fade" \
		  -options "duration: 1.5"]

set msg2_appear [ah::effects -element "msg_div2" \
                                  -effect "Appear" \
		    -options "duration: 0.5"]

set msg2_fade_0 [ah::effects -element "msg_div2" \
                                   -effect "Fade" \
		    -options "duration: 0"]


set cat_tree "<ul class=\"mktree\">$tree(tree_name) 
<a class=\"ALTbutton\" href=\"${root_add_link}\" onmouseout=\"javascript:${msg2_fade}\" onmouseover=\"javascript:${msg2_appear}\">
<img src=\"/resources/acs-subsite/Add16.gif\"> \#content-portlet.add_unit\#</a><br /><br />\n"


foreach tree_level $tree_list {

    if { $tmp_level < [lindex $tree_level 3]} { 
	#ns_log notice "paso a nivel superior de $tmp_level a [lindex $tree_level 3]"
  	lappend level_list "$tmp_level"
	set tmp_level [lindex $tree_level 3]
    } elseif {$tmp_level > [lindex $tree_level 3]} {
	#ns_log notice "paso a nivel inferior de $tmp_level a [lindex $tree_level 3]"
	append level_${tmp_level}_tree "</li>\n"
	set aux_level [lindex $tree_level 3]
	set my_tmp_level $tmp_level
	for {set i 1} {$i < [expr ($tmp_level - $aux_level) + 1]} {incr i} {
	    set aux2_level [lindex $level_list [expr [llength $level_list] - $i]] 
	    eval "append level_${aux2_level}_tree \"\n<ul>   \n\$level_${my_tmp_level}_tree</ul>\n</li>\n\""
	    set level_${my_tmp_level}_tree ""
	    set my_tmp_level $aux2_level
	}
	set level_list [lrange $level_list 0 [expr $aux_level - 2]]
#	eval "append level_${aux_level}_tree \"\n<ul>   \n\$level_${my_tmp_level}_tree</li>\n</ul>\n</li>\n\""
	#set level_${my_tmp_level}_tree ""
	set level_${tmp_level}_tree ""
	set tmp_level [lindex $tree_level 3]
	set my_tmp_level ""
	set aux_level ""
    } else {
	eval "set aux_string \$level_${tmp_level}_tree"
	if {[string length $aux_string] > 0} {
	    append level_${tmp_level}_tree "</li> \n"
	}
    }
    set add_link "category-add-edit?tree_id=${tree_id}&parent_id=[lindex $tree_level 0]&name=[_ content-portlet.new_seccion]&mode=2&return_url=$return_url"
    set del_link "category-delete?tree_id=${tree_id}&category_id=[lindex $tree_level 0]&return_url=$return_url"
    if {$new_cat eq [lindex $tree_level 0]} {
	append inplaceeditor_js "var editor = new Ajax.InPlaceEditor(\$('cat_${new_cat}'), 'category-add-edit', {
      callback: function(post,value) { return 'tree_id=${tree_id}&category_id=${new_cat}&name=' + value},
      externalControl: 'control_${new_cat}',
      okText: 'Guardar',
     cancelText: 'Cancelar',
     savingText: 'Actualizando'});
      editor.enterEditMode('click');"
	set class "liOpen"
    } else {
	append inplaceeditor_js "new Ajax.InPlaceEditor(\$('cat_[lindex $tree_level 0]'), 'category-add-edit', { 
    callback: function(post,value) { return 'tree_id=${tree_id}&category_id=[lindex $tree_level 0]&name=' + value}, 
    externalControl: 'control_[lindex $tree_level 0]',
    okText: 'Guardar',
    cancelText: 'Cancelar',
    savingText: 'Actualizando'})\; \n"
    }
    
    if {$parent_cat eq [lindex $tree_level 0]} {
	set class "liOpen"
    }
    append level_${tmp_level}_tree "<li style=\" background-image:none; list-style-image:none;\" class=\"$class\">
        &nbsp;<span class=\"cuadro\" id=\"cat_[lindex $tree_level 0]\">[lindex $tree_level 1]</span> 
   <span style=\"font-size:10px;\">
    <a href=\"\javascript:;\" id=\"control_[lindex $tree_level 0]\">
      <img src=\"/resources/acs-subsite/Edit12.gif\"  alt=\"editar\" title=\"\#content-portlet.edit_name\#\"></a>"
    if {[content_category::valid_level_and_count -tree_id $tree_id -category_id [lindex $tree_level 0]]} {
	append level_${tmp_level}_tree "&nbsp;<a href=\"${add_link}\">
    <img src=\"/resources/acs-subsite/Add12.gif\"  alt=\"Agregar\" title=\"\#content-portlet.add_section\#\"></a>"
    }
    if {[content_category::delete_p -tree_id $tree_id -category_id [lindex $tree_level 0]]} {
	append level_${tmp_level}_tree "&nbsp;<a href=\"${del_link}\">
      <img src=\"/resources/acs-subsite/delete12.gif\"  alt=\"Eliminar\" title=\"\#content-portlet.delete_section\#\"></a>"
    }
    append level_${tmp_level}_tree "</span>"
    
    #ns_log notice "estoy en nivel $tmp_level"
}



append level_${tmp_level}_tree "</li> \n"
set aux_level 2
set my_tmp_level $tmp_level
for {set i 1} {$i < [expr ($tmp_level - $aux_level) + 1]} {incr i} {
    set aux2_level [lindex $level_list [expr [llength $level_list] - $i]]
    eval "append level_${aux2_level}_tree \"\n<ul>\n\$level_${my_tmp_level}_tree</ul>\n</li>\n\""
    set level_${my_tmp_level}_tree ""
    set my_tmp_level $aux2_level
}

if {[string length $level_2_tree] > 0} {
    append level_1_tree "\n<ul>\n$level_2_tree</ul>\n</li>\n"
}
append cat_tree "$level_1_tree </ul>\n"

#ns_log notice "$cat_tree"
