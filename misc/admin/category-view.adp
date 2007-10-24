<master>
  <property name="title">@title@</property>
  <property name="header_stuff">
<link rel='stylesheet' href='/resources/content-portlet/template/Gestheme.css' media='all' />
    <link rel="stylesheet" type="text/css" href="/resources/xowiki/cattree.css" media="all"/>
    <script language='javascript' src='/resources/acs-templating/mktree.js' type='text/javascript'></script>
    @ah_sources;noquote@
    <script src="/resources/ajaxhelper/scriptaculous/unittest.js" type="text/javascript"></script>
    
    <style type="text/css" media="screen">
      .inplaceeditor-saving { background: url(/resources/ajaxhelper/yui-ext/resources/images/grid/wait.gif) bottom right no-repeat; }
      .editor_cancel {padding: 3px 5px; }
    </style>
    <script text="text/javascript">
      function confirm_delete(value) {
      new Ajax.Updater ('msg_div','category-confirm.tcl',
      {onComplete:function() {@msg_appear;noquote@},
      asynchronous:true,
      method:'post',
      parameters: 'tree_id=@tree_id@&category_id=' + value});
      }
    </script>
  </property>

<a class="ALTbutton" href="../">Regresar</a><br /><br /><br />
<div style="width:60%; position:relative;">
  @cat_tree;noquote@


<div id="msg_div">
    </div>

<div id="msg_div2">
<p>
#content-portlet.unit_descirption#
</p>
    </div>
 

  </div>
    <script>
    @inplaceeditor_js;noquote@
    
   </script>


 <script>
    @msg_fade_0;noquote@
    @msg2_fade_0;noquote@
      Image1= new Image(10,10)
       Image1.src = "/resources/acs-templating/minus.gif"

       Image1= new Image(10,10)
       Image1.src = "/resources/acs-templating/plus.gif"

    </script>
