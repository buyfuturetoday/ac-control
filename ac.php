<!DOCTYPE html>
<html>
<meta name="viewport" content="width=device-width, initial-scale=1">
<body style="max-width:400px; background-color:#333; color:#FFF;">
<h3>
<?php

include("acstate.html");

echo '</h3><form method="POST" action="ac.php">';
echo '<input type="submit" name="on" value="Switch AC ON" style="padding:18px; margin:8px; background-color:#0F0;"><input type="submit" name="off" value="Switch AC OFF" style="padding:18px; margin:8px; background-color:#F00;"></form>';
if(isset($_POST['on'])) {
	shell_exec('sudo python on.py');
	echo "Done\n";
}
if(isset($_POST['off'])) {
	shell_exec('sudo python off.py');
	echo "Done\n";
}
if(isset($_GET['on'])) {
	shell_exec('sudo python on.py');
	echo "Done\n";
}
if(isset($_GET['off'])) {
	shell_exec('sudo python off.py');
	echo "Done\n";
}
?>
</body>
</html>