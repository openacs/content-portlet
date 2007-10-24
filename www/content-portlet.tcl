array set config $cf
set user_id [ad_conn user_id]

set wiki_url [site_node::get_url_from_object_id -object_id $config(package_id)]


if {![empty_string_p [lindex $config(page_name) 0]]} {
#    regsub {/[^/]+$} [ad_conn url] "/xowiki/$config(page_name)" url
    set url "${wiki_url}$config(page_name)"
} else {
#	regsub {/[^/]+$} [ad_conn url] "/xowiki/es:index" url
    set url "${wiki_url}es:index"
}
