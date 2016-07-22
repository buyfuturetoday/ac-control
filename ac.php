<?php
if(isset($_POST['on'])) {
	shell_exec('sudo python on.py');
	echo "Forcing AC on\n";
}
if(isset($_POST['off'])) {
	shell_exec('sudo python off.py');
	echo "Allowing AC off\n";
}
if(isset($_POST['open'])) {
	shell_exec('sudo python open.py');
	echo "Opened air vent\n";
}
if(isset($_POST['close'])) {
	shell_exec('sudo python close.py');
	echo "Closed air vent\n";
}
if(isset($_POST['run'])) {
	shell_exec('sudo python run.py > /dev/null 2>&1 &');
	echo "Running AC for 25 minutes...\n";
}
if(isset($_POST['setpoint'])) {
	file_put_contents('setpoint', $_POST['set']);
	echo "Changed set point to [" . $_POST['set'] . "]\n";
}
if(isset($_GET['on'])) {
	shell_exec('sudo python on.py');
	echo "Forcing AC on\n";
}
if(isset($_GET['off'])) {
	shell_exec('sudo python off.py');
	echo "Allowing AC off\n";
}
if(isset($_GET['run'])) {
	shell_exec('sudo python run.py > /dev/null 2>&1 &');
	echo "Running AC for 55 minutes...\n";
}
if(isset($_GET['open'])) {
	shell_exec('sudo python open.py');
	echo "Opened air vent\n";
}
if(isset($_GET['close'])) {
	shell_exec('sudo python close.py');
	echo "Closed air vent\n";
}
if(isset($_GET['set'])) {
	file_put_contents('setpoint', $_POST['set']);
	echo "Changed set point to [" . $_POST['set'] . "]\n";
}
?>
<!DOCTYPE html>
<html>
<style>
input {
	border:1px solid black;
}
</style>
<title>HVAC Controls</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<body style="max-width:400px; background-color:#333; color:#FFF;">
<h3>
<?php
include("acstate.html");
echo '</h3><form method="POST" action="ac.php">';
echo '<input type="submit" name="on" value="Switch AC ON" style="padding:18px; width:40%; margin:8px; background-color:#0F0;"><input type="submit" name="off" value="Switch AC OFF" style="padding:18px; width:40%; margin:8px; background-color:#F00;"><br><input type="submit" name="run" value="Run for 55m" style="padding:18px; width:80%; margin:8px; background-color:#777;">';
echo '<h3>';
include("ventstate.html");
echo '</h3>';
echo '<input type="submit" name="open" value="Open Vent" style="padding:18px; width:40%; margin:8px; background-color:#0F0;"><input type="submit" name="close" value="Close Vent" style="padding:18px; width:40%; margin:8px; background-color:#F00;">';
echo '<h3>Set point</h3><input type="number" name="set" min="72" max="76" style="font-size:36px; width:40%; margin:8px;" value=';
echo (file_get_contents ("setpoint"));
echo '><input type="submit" name="setpoint" value="Set" style="padding:18px; width:40%; margin:8px; background-color:#777;"></form>';

?>
</body>
</html>