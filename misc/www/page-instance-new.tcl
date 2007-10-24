#
::xowiki::Package initialize -ad_doc {

  This is the resolver for this package. It turns a request into
  an object and executes the object with the computed method

  @author byron linares (bhlr@galileo.edu)


} -parameter {
}

set autoname [::$package_id get_parameter autoname 0]
set folder_id [::xowiki::Page require_folder -name xowiki -package_id $package_id]
set page [::xowiki::PageInstance new ]
set page_index [db_string page_index {
    select count(p.page_id)  from cr_items ci, cr_revisions r, xowiki_page p
    where ci.parent_id = :folder_id
    and ci.content_type not in ('::xowiki::PageTemplate')
    and r.revision_id = ci.live_revision
    and p.page_id = r.revision_id} -default 0]

set page_name "es:page_[incr page_index]"
if {[db_string select_name {
    select 1 from cr_items 
    where name = :page_name 
    and parent_id = :folder_id} -default 0]} {
    
    set page_name "es:[format "%0.0f" [expr [random] * 10]]_[format "%0.0f" [expr [random] * 10]]_page_[incr page_index]"
}

$page configure -name $page_name -parent_id $folder_id -package_id $package_id



set list_page_order [db_list select_order {
    select p.page_order  
    from cr_items ci, cr_revisions r, xowiki_page p
    where ci.parent_id = :folder_id
    and ci.content_type not in ('::xowiki::PageTemplate')
    and r.revision_id = ci.live_revision
    and p.page_id = r.revision_id
    and p.page_order is not null
    order by p.page_order desc
    }]

set max_page_order [lindex [lsort -decreasing -command content_compare::simple_compare $list_page_order] 0]
if {[llength $list_page_order] < 1} {
    set max_page_order 0
}
incr max_page_order

db_0or1row select_instance [::xowiki::PageTemplate instance_select_query \
				-folder_id $folder_id \
				-select_attributes {name} \
				-where_clause "name = 'es:Template_de_ges'"]

set template_id $item_id

$page set page_template $template_id
$page set page_order $max_page_order
$page destroy_on_cleanup
$page initialize_loaded_object
$page save_new
set item_id [$page item_id]
set return_url "[::$package_id package_url][$page set name]"
set link [::$package_id pretty_link [$page set name]]
ad_returnredirect  [export_vars -base $link {{m edit} page_template return_url item_id}]



