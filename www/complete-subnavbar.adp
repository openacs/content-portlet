  <if @show@ true >
    <table border="0" cellpadding="0" cellspacing="0" class="introTable">
      <tr>
	<td width="17">	<img width="17" height="21" src="/resources/content-portlet/template/imagenes/Ls@parent_cat_index@.gif"/></td>
        <include src="/packages/content-portlet/www/subnavbar" page_pos=@page_pos@ page_id=@page_id@ content_id=@content_id@ type=@type@ index=@index5@> 
	<if @index5@ ne 100 and @index5@ ne 0>
	<td width="18"><img src="/resources/content-portlet/template/imagenes/separa@parent_cat_index@.gif" width="18" height="21" /></td>
	</if>
        <include src="/packages/content-portlet/www/subnavbar" page_pos=@page_pos@ page_id=@page_id@ content_id=@content_id@ type=@type@ index=@index4@>
	<if @index4@ ne 100 and @index4@ ne 0>
	<td width="18"><img src="/resources/content-portlet/template/imagenes/separa@parent_cat_index@.gif" width="18" height="21" /></td>
        </if>
	<include src="/packages/content-portlet/www/subnavbar" page_pos=@page_pos@ page_id=@page_id@ content_id=@content_id@ type=@type@ index=@index3@>
	<if @index3@ ne 100 and @index3@ ne 0>
	<td width="18"><img src="/resources/content-portlet/template/imagenes/separa@parent_cat_index@.gif" width="18" height="21" /></td>
	</if>
	<include src="/packages/content-portlet/www/subnavbar" page_pos=@page_pos@ page_id=@page_id@ content_id=@content_id@ type=@type@ index=@index2@>
	<if @index2@ ne 100 and @index2@ ne 0>
	<td width="18"><img src="/resources/content-portlet/template/imagenes/separa@parent_cat_index@.gif" width="18" height="21" /></td>
	</if>
	<include src="/packages/content-portlet/www/subnavbar" page_pos=@page_pos@ page_id=@page_id@ content_id=@content_id@ type=@type@ index=@index1@>
        <td width="30"><img src="/resources/content-portlet/template/imagenes/Rs@parent_cat_index@.gif" width="30" height="21" /></td>
      </tr>
    </table>
  </if>