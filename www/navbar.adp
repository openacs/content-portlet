<if @show@ true>
  <if @index@ ne 0>
    <if @nexturl@ ne 0>
      <li @styleb;noquote@>
	<a href="@nexturl@" style="text-decoration:none;">
	  <span class="style1">
	    <if @show_img@ true><img src="/resources/content-portlet/template/imagenes/@img_name3@" border="0" height="13"/></if>&nbsp;@cat_name@
	  </span>
	</a>
      </li>
    </if>
    <else>
      <li @styleb;noquote@>
	<span class="style1">
	  <if @show_img@ true><img src="/resources/content-portlet/template/imagenes/@img_name3@" border="0" height="13"/></if>&nbsp;@cat_name@
	</span>
      </li>
    </else>
  </if>
  <else>
    <li style=" background-image:none;" ><img src="/resources/content-portlet/template/imagenes/@img_name@.gif" border="0" height="36" width="13" /></li>
  </else>
</if>