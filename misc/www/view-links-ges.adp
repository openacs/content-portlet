<div class='xowiki-content'>
<div id='wikicmds2'>
  <if @edit_link@ not nil><a href="@edit_link@" accesskey='e' title='Diese Seite bearbeiten ...'>#xowiki.edit#</a> &middot; </if>
  <if @rev_link@ not nil><a href="@rev_link@" accesskey='r' >#xowiki.revisions#</a> &middot;</if>
<if @object_type@ not nil and @object_type@ ne "::xowiki::Page">
        <if @object_type@ eq "::xowiki::PageInstance">
          <a href="@new_link2@?object_type=::xowiki::PageInstance">#xowiki.new#</a> &middot;
        </if>
        <else>
          <if @new_link@ not nil><a href="@new_link@" accesskey='n'>#xowiki.new#</a> &middot;</if>
        </else>
      </if><else><a href="@new_link2@?object_type=::xowiki::PageInstance">#xowiki.new#</a> &middot;</else>
  <if @delete_link@ not nil><a href="@delete_link@" accesskey='d'>#xowiki.delete#</a> &middot;</if>
  <if @notification_subscribe_link@ not nil><a href="@notification_subscribe_link@">@notification_image;noquote@</a> &middot;</if>
    <if @admin_link@ not nil><a href="@admin_link@category-view?package_id=@package_id@">#xowiki.edit_content_index#</a> &middot;</if>
    <if @index_link@ not nil><a href="@index_link@" accesskey='i'>#xowiki.index#</a></if> 
</div>
@content;noquote@
</div> <!-- class='xowiki-content' -->
