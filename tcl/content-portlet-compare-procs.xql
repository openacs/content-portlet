<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN" "http://www.thecodemill.biz/repository/xql.dtd">
<!--  -->
<!-- @author byron Haroldo Linares Roman (bhlr@byronLs-Computer.local) -->
<!-- @creation-date 2007-09-12 -->
<!-- @arch-tag: D01A6B61-DE0A-4891-9D75-C835E9C6622B -->
<!-- @cvs-id $Id$ -->

<queryset>
  

<fullquery name="content_category::category_delete.order_categories_for_delete">
      <querytext>

        select category_id
        from categories
        where tree_id = :tree_id
        and category_id in ([join $category_ids ,])
        order by left_ind desc

      </querytext>
</fullquery>

  <fullquery name="content_category::category_childs.select_cat">
    <querytext>
      select count(ci.item_id)
      from category_object_map c, cr_items ci,
      cr_revisions r, xowiki_page p
      where c.object_id = ci.item_id
      and ci.parent_id = :wiki_folder_id
      and ci.content_type not in ('::xowiki::PageTemplate')
      and ci.name not in ('es:header_page','es:index','es:indexe')
      and r.revision_id = ci.live_revision
      and p.page_id = r.revision_id
      and c.category_id = :cat_id
      group by category_id
      order by category_id desc
    </querytext>
  </fullquery>


<fullquery name="content_category::page_order.select_content">
    <querytext>
      select ci.item_id, p.page_order, ci.name, ci.content_type, category_id, xpi.page_instance_id
      from category_object_map c, cr_items ci, xowiki_page p, xowiki_page_instance xpi
      where c.object_id = ci.item_id and ci.parent_id = :wiki_folder_id
      and ci.content_type not in ('::xowiki::PageTemplate')
      and ci.name not in ('es:header_page','es:index','es:indexe')
      and p.page_id = xpi.page_instance_id
      and category_id in ([join $cat_id ","])
      and xpi.page_instance_id = ci.live_revision
      order by p.page_order
    </querytext>
  </fullquery>

</queryset>