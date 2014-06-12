{capture name='_smarty_debug' assign=debug_output}
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<title>Smarty Debug Console</title>
<style type="text/css">
{literal}
body,h1,h2,td,th,p { font-family:sans-serif;font-weight:normal;font-size:0.9em;margin:1px;padding:0 }
h1 { margin:0;text-align:left;padding:2px;background-color:#f0c040;color:#000;font-weight:bold;font-size:1.2em }
h2 { background-color:#9B410E;color:#FFF;text-align:left;font-weight:bold;padding:2px;border-top:1px solid #000 }
body { background:#000 }
p, table, div { background:#F0EAD8 }
p { margin:0;font-style:italic;text-align:center }
table { width:100% }
th, td { font-family:monospace;vertical-align:top;text-align:left;width:50% }
td { color:green }
.odd { background-color:#EEE }
.even { background-color:#FAFAFA }
.tplname { color:brown }
.exectime { font-size:0.8em;font-style:italic }
#table_assigned_vars th { color:blue }
#table_config_vars th { color:maroon }
{/literal}
</style>
</head>
<body>
<h1>Smarty Debug Console  -  {if isset($template_name)}{$template_name|debug_print_var nofilter}{else}Total Time {$execution_time|string_format:"%.5f"}{/if}</h1>
{if !empty($template_data)}

<h2>included templates &amp; config files (load time in seconds)</h2>
<div>
{foreach $template_data as $template}
  <span class="tplname">{$template.name}</span>
  <span class="exectime">(compile {$template['compile_time']|string_format:"%.5f"}) (render {$template['render_time']|string_format:"%.5f"}) (cache {$template['cache_time']|string_format:"%.5f"})</span>
  <br />
{/foreach}
</div>
{/if}

<h2>assigned template variables</h2>
<table id="table_assigned_vars">
{foreach $assigned_vars as $vars}
  <tr class="{if $vars@iteration % 2 eq 0}odd{else}even{/if}">   
    <th>${$vars@key|escape:'html'}</th>
    <td>{$vars|debug_print_var nofilter}</td>
  </tr>
{/foreach}
</table>

<h2>assigned config file variables (outer template scope)</h2>
<table id="table_config_vars">
{foreach $config_vars as $vars}
  <tr class="{if $vars@iteration % 2 eq 0}odd{else}even{/if}">   
    <th>{$vars@key|escape:'html'}</th>
    <td>{$vars|debug_print_var nofilter}</td>
  </tr>
{/foreach}
</table>
</body>
</html>
{/capture}
<script type="text/javascript">
{$id = $template_name|default:''|md5}
if( !(window.console && window.console.log && window.console.table) ){ldelim}

  _smarty_console = window.open("","console{$id}","width=680,height=600,resizable,scrollbars=yes");
  _smarty_console.document.write("{$debug_output|escape:'javascript' nofilter}");
  _smarty_console.document.close();

{rdelim}else{ldelim}

  console.group("Smarty Debug");
    console.group("Included templates & config files");
{if count( $template_data ) }
      console.table([
{foreach from=$template_data  key=k item=t}
        {ldelim} file:"{$t.name|escape:javascript}" , compile:"{$t['compile_time']|string_format:"%.5f"}" , render:"{$t['render_time']|string_format:"%.5f"}" , cache:"{$t['cache_time']|string_format:"%.5f"}" {rdelim} ,
{/foreach}
      ]);
{else}
      console.info("no templates included");
{/if}
    console.groupEnd();
    console.group("Assigned template variables");
{if count( $assigned_vars )}
      console.table([
{foreach from=$assigned_vars key=k item=v}
        {ldelim} name:"${$k|escape:javascript}", value:{$v->value|@json_encode}, type:"{$v->value|gettype}", nocache:{if !$v->nocache}false{else}true{/if}, scope:"{$v->scope|escape:javascript}" {rdelim} ,
{/foreach}
      ]);
{else}
      console.info("no template variables assigned");
{/if}
    console.groupEnd();
    console.group("Assigned config file variables");
{if count( $config_vars )}
      console.table([
{foreach from=$template_data  key=k item=t}
        {ldelim} file:"{$t.name|escape:javascript}" , compile:"{$t['compile_time']|string_format:"%.5f"}" , render:"{$t['render_time']|string_format:"%.5f"}" , cache:"{$t['cache_time']|string_format:"%.5f"}" {rdelim} ,
{/foreach}
      ]);
{else}
      console.info("no config file variables assigned");
{/if}
    console.groupEnd();
  console.groupEnd();

{rdelim}
</script>
