<master>
  <property name="title">@title;noquote@</property>
  <property name="context">@context;noquote@</property>
  <property name="header_stuff">@header_stuff;noquote@
   <link rel='stylesheet' href='/resources/xowiki/cattree.css' media='all' />
   <script type="text/javascript" src="/resources/ajaxhelper/prototype/prototype.js"></script> 
   <script type="text/javascript" src="/resources/ajaxhelper/scriptaculous/scriptaculous.js"></script> 
   <script language='javascript' src='/resources/acs-templating/mktree.js' type='text/javascript'></script>
    <script type="text/javascript" src="/resources/ajaxhelper/browser.js"></script>
   <link rel="stylesheet" type="text/css" href="/resources/xowiki/xowiki.css" media="all" />
   <script type="text/javascript">
      function resizetemplate(value) {
      if (BrowserDetect.browser == 'Explorer') {
      new Effect.Fade('out',{duration: 0});
      new Effect.Fade('in',{duration: 0});
      } else {
      switch(value) {
      case '1':	
           new Effect.Fade('categories',{duration: 0});
           new Effect.Scale('categories_cont',25,{duration: 1}, Object.extend({
           scaleX: true, 
	   scaleY: true,
	   scaleContent: false,
	   restoreAfterFinish: true}));
	   new Effect.Puff('in');
	   new Effect.Appear('out');
	   setTimeout("new Effect.Scale('cont', 122, {duration: 1.5},Object.extend({scaleFromCenter: true, scaleY: false}))",500);
           document.cookie='cat_pos=1'
      break;
      case '2':
           new Effect.Scale('cont', 80,{duration: 0.2}, Object.extend({scaleFromCenter: true, scaleY: false}));
	   new Effect.Scale('categories_cont',400,{duration: 1.5}, Object.extend({
           scaleFromCenter: true, 
           scaleX: true, 
           scaleY: false, 
           scaleFrom: 25}));
           setTimeout("new Effect.Appear('categories',{duration: 2})",1500);
//         new Effect.Scale('cont', 80,{duration: 1}, Object.extend({scaleFromCenter: true, scaleY: false}));
           new Effect.Puff('out');
           new Effect.Appear('in');
           document.cookie='cat_pos=2'
      break;
      case '3': 
           new Effect.Fade('categories',{duration: 0});
           new Effect.Scale('categories_cont',25,{duration: 0}, Object.extend({
                scaleX: true,
                scaleY: true,
                scaleContent: false,
                restoreAfterFinish: true}));
           new Effect.Fade('in',{duration: 0});
           new Effect.Appear('out');
           new Effect.Scale('cont', 122, {duration: 0},Object.extend({scaleFromCenter: true, scaleY: false}));
           document.cookie='cat_pos=1'
      }
      }     
      };
      function get_popular_tags(popular_tags_link, prefix) {
      var http = getHttpObject();
      http.open('GET', popular_tags_link, true);
      http.onreadystatechange = function() {
      if (http.readyState == 4) {
      if (http.status != 200) {
      alert('Something wrong in HTTP request, status code = ' + http.status);
      } else {
      var e = document.getElementById('popular_tags');
      e.innerHTML = http.responseText;
      e.style.display = 'block';
      }
      }
      };
      http.send(null);
      }
    </script>
  </property>
  
  <!-- The following DIV is needed for overlib to function! -->
  <div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000;"></div>	

  <div class='xowiki-content'>
    <div id='wikicmds'>
      <if @edit_link@ not nil><a href="@edit_link@" accesskey='e' title='Diese Seite bearbeiten ...'>#xowiki.edit#</a> &middot;</if>
      <if @rev_link@ not nil><a href="@rev_link@" accesskey='r' >#xowiki.revisions#</a> &middot;</if>
      <if @object_type@ not nil and @object_type@ ne "::xowiki::Page">
	<if @object_type@ eq "::xowiki::PageInstance">
	  <a href="@new_link2@?object_type=::xowiki::PageInstance">#xowiki.new#</a> &middot;
	</if>
	<else>
	  <if @new_link@ not nil><a href="@new_link@" accesskey='n'>#xowiki.new#</a> &middot;</if>
	</else>
      </if>
      <else><a href="@new_link2@?object_type=::xowiki::PageInstance">#xowiki.new#</a> &middot;</else>
      <if @delete_link@ not nil><a href="@delete_link@" accesskey='d'>#xowiki.delete#</a> &middot;</if>
   <!--   <if @admin_link@ not nil><a href="@admin_link@" accesskey='a'>#xowiki.admin#</a> &middot;</if> -->
      <if @notification_subscribe_link@ not nil><!-- <a href='/notifications/manage'>#xowiki.notifications#</a> -->
    	<a href="@notification_subscribe_link@">@notification_image;noquote@</a> &middot;</if>
      <if @admin_link@ not nil><a href="@admin_link@category-view?package_id=@package_id@">#xowiki.edit_content_index#</a> &middot;</if>
      <if @index_link@ not nil><a href="@index_link@" accesskey='i'>#xowiki.index#</a></if>
    </div>
  <!-- </div> -->
<!-- </body> -->

  <a name="cont1"></a>
  <div id="categories_cont">
    <div style="float:left; width: 20%; font-size: 85%;
      background: url(/resources/xowiki/bw-shadow.png) no-repeat bottom right;
      margin-left: 2px; margin-top: 2px; padding: 0px 6px 6px 0px;			    
      ">
      
      <div style="margin-top: -2px; margin-left: -2px; border: 1px solid #a9a9a9; padding: 5px 5px; background: #f8f8f8">
	<div id="in" style="width: 35px;">
	  <a href="#" onclick="resizetemplate('1');"><img src="/resources/content-portlet/ocultar1.png"></a>
	</div>
	<div id="out" style="width: 35px;">
	  <a href="#" onclick="resizetemplate('2');"><img src="/resources/content-portlet/mostrar1.png"></a>
	</div>
	<div id="categories">
	    <include src="/packages/xowiki/www/portlets/ges-categories" open_page=@name@ skin=plain-include &__including_page=page>
	</div>
      </div>
    </div>
  </div>
  <div id="cont" style="float:right; width: 75%;"><!--@top_portlets;noquote@ -->
    @content;noquote@</div>
  <div style="clear: both; text-align: left; font-size: 85%;">

      <if @digg_link@ not nil>
	<div style='float: right'><a href='@digg_link@'><img  src='http://digg.com/img/badges/100x20-digg-button.png' width='100' height='20' alt='Digg!' border='1'/>
	  </a>
	</div>
      </if>
      <if @delicious_link@ not nil>
	<div style='float: right; padding-right: 10px;'><a href='@delicious_link@'><img src="http://i.i.com.com/cnwk.1d/i/ne05/fmwk/delicious_14x14.gif" width="14" height="14" border="0" alt="Add to your del.icio.us" />del.icio.us</a>
	</div>
      </if>
      <if @my_yahoo_link@ not nil>
	<div style='float: right; padding-right: 10px;'>
	  <a href="@my_yahoo_link@"><img src="http://us.i1.yimg.com/us.yimg.com/i/us/my/addtomyyahoo4.gif" width="91" height="17" border="0" align="middle" alt="Add to My Yahoo!"></a>
	</div>
      </if>
    </div>

@footer;noquote@

     <if @per_object_categories_with_links@ not nil and @per_object_categories_with_links@ ne "">
	Categories: @per_object_categories_with_links;noquote@
      </if>
    </div><br/>
    <if @gc_comments@ not nil>
	<p>#general-comments.Comments#
	<ul>@gc_comments;noquote@</ul></p>
    </if>
    <if @gc_link@ not nil>
      <p>@gc_link;noquote@</p>
    </if>
    <script text="text/javascript">
      if (getCookie('cat_pos')) {
      switch(getCookie('cat_pos')) {
             case '1':
      resizetemplate('3');
      break;
      case '2':
      new Effect.Fade('out',{duration: 0});
      break;
      };
      } else {
      new Effect.Fade('out',{duration: 0});
      }
      if (BrowserDetect.browser == 'Explorer') {
      new Effect.Fade('out',{duration: 0});
      new Effect.Fade('in',{duration: 0});
      }
    </script>
  </div> <!-- class='xowiki-content' -->
  