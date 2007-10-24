  <if @show@ true>
    <if @nexturl@ ne 0>
      <td style="background-image:url(/resources/content-portlet/template/imagenes/backs@parent_cat_index@.gif); background-repeat:repeat-x;"><div align="center"><a href="@nexturl@">@cat_name@</a></div></td>
    </if>
    <else>
      <td><div align="center">@cat_name@</div></td>
    </else>
  </if>