<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN" "http://www.thecodemill.biz/repository/xql.dtd">
<!--  -->
<!-- @author byron Haroldo Linares Roman (bhlr@byronLs-Computer.local) -->
<!-- @creation-date 2007-09-17 -->
<!-- @arch-tag: A2DE2A39-5C21-4D45-B7B1-B2C6ABC4DF97 -->
<!-- @cvs-id $Id$ -->

<queryset>
  
  <rdbms>
    <type>postgresql</type>
    <version>7.2</version>
  </rdbms>
  
  <fullquery name="content_category::delete_p.check_mapped_objects">
    <querytext>

      select case when count(*) = 0 then 0 else 1 end
      where exists (select 1 from category_object_map
      where category_id = :my_category_id)

    </querytext>
  </fullquery>

</queryset>