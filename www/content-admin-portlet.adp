
Ver P&aacute;ginas de <a href='@applet_url@'>#content-portlet.content#</a><br />
<if @admin_p;literal@ true>
Administrar P&aacute;ginas de <a href="@applet_url@admin/">#content-portlet.content#</a><br />
</if>
#xowiki.edit_content_index# <a href="@applet_url@admin/category-view?package_id=@package_id@">Editar</a>
<if @package_id@ eq "">
  <small>No community specified</small>
</if>
<else>
<ul>
<!--
<multiple name="content">
  <li>
    @content.pretty_name@<small> <a class="button" href="@applet_url@admin/portal-element-remove?element_id=@content.element_id@&referer=@referer@&portal_id=@template_portal_id@">#acs-subsite.Delete#</a></small>
  </li>
</multiple>
</ul>
@form;noquote@
-->
</else>
