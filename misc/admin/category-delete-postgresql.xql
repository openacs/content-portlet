<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN" "http://www.thecodemill.biz/repository/xql.dtd">
<!--  -->
<!-- @author byron Haroldo Linares Roman (bhlr@byronLs-Computer.local) -->
<!-- @creation-date 2007-08-27 -->
<!-- @arch-tag: 8037BB8A-0BB2-4D58-B201-A9D8EDA12390 -->
<!-- @cvs-id $Id$ -->

<queryset>
  
  <rdbms>
    <type>postgresql</type>
    <version>7.2</version>
  </rdbms>
  
  <fullquery name="check_mapped_objects">
    <querytext>
      
      select case when count(*) = 0 then 0 else 1 end
      where exists (select 1 from category_object_map
      where category_id = :my_category_id)
      
    </querytext>
  </fullquery>
  
</queryset>