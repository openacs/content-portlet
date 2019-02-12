ad_page_contract {
    
    
    
    @author byron Haroldo Linares Roman (bhlr@byronLs-Computer.local)
    @creation-date 2007-08-24
    @cvs-id $Id$
} {
    
    tree_id:integer
    name:notnull
    category_id:integer,optional
    return_url:optional
    {parent_id:integer,optional ""}
    {language "es_GT"}
    {mode 1}
    
} -properties {
} -validate {
} -errors {
}

set user_id [ad_maybe_redirect_for_registration]
set package_id [ad_conn package_id]
permission::require_permission -object_id $tree_id -privilege category_tree_write
set description "User category for content package"

if {$mode eq 1 && [exists_and_not_null category_id]} {
    ## edit mode####
    category::update -category_id $category_id \
	-locale $language \
	-name $name \
	-description $description

} elseif {$mode eq 2} {
    if {[content_category::valid_level_and_count -tree_id $tree_id \
	     -category_id $parent_id]} {
	set new_cat [category::add -tree_id $tree_id \
			 -parent_id $parent_id \
			 -locale $language \
			 -name $name \
			 -description $description]
	set parent_cat [content_category::category_parent -category_id $new_cat -tree_id $tree_id]
    }
} elseif {$mode eq 3} {
    set new_cat [content_category::new_subtree -tree_id $tree_id]
    set parent_cat $new_cat
    
}

if {[exists_and_not_null return_url]} {
    if {[exists_and_not_null new_cat]} {
	ad_returnredirect "$return_url&new_cat=$new_cat&parent_cat=$parent_cat"
    } else {
	ad_returnredirect $return_url
    }
    ad_script_abort
} else {
 #   ad_return_template
}
