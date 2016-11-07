<?php
# AC on/off
if(isset($_POST['on'])) {
	shell_exec('sudo python device4/on.py');
	echo "Forcing AC on\n";
}
if(isset($_POST['off'])) {
	shell_exec('sudo python device4/off.py');
	echo "Allowing AC off\n";
}
if(isset($_GET['on'])) {
	shell_exec('sudo python device4/on.py');
	echo "Forcing AC on\n";
}
if(isset($_GET['off'])) {
	shell_exec('sudo python device4/off.py');
	echo "Allowing AC off\n";
}
# AC cycle on then shut off
if(isset($_POST['run'])) {
	shell_exec('sudo python device4/run.py > /dev/null 2>&1 &');
	echo "Running AC for 25 minutes...\n";
}
if(isset($_GET['run'])) {
	shell_exec('sudo python device4/run.py > /dev/null 2>&1 &');
	echo "Running AC for 25 minutes...\n";
}

# Furnace on/off
if(isset($_POST['furnace_on'])) {
	shell_exec('sudo python device3/on.py');
	echo "Forcing furnace on\n";
}
if(isset($_POST['furnace_off'])) {
	shell_exec('sudo python device3/off.py');
	echo "Allowing furnace off\n";
}
if(isset($_GET['furnace_on'])) {
	shell_exec('sudo python device3/on.py');
	echo "Forcing furnace on\n";
}
if(isset($_GET['furnace_off'])) {
	shell_exec('sudo python device3/off.py');
	echo "Allowing furnace off\n";
}
# Furnace cycle on then off
if(isset($_POST['furnace_run'])) {
	shell_exec('sudo python device3/run.py > /dev/null 2>&1 &');
	echo "Running furnace for 25 minutes...\n";
}
if(isset($_GET['furnace_run'])) {
	shell_exec('sudo python device3/run.py > /dev/null 2>&1 &');
	echo "Running furnace for 25 minutes...\n";
}

# Vent control
if(isset($_POST['open'])) {
	shell_exec('sudo python device1/open.py');
	echo "Opened air vent\n";
}
if(isset($_POST['close'])) {
	shell_exec('sudo python device2/close.py');
	echo "Closed air vent\n";
}
if(isset($_GET['open'])) {
	shell_exec('sudo python device1/open.py');
	echo "Opened air vent\n";
}
if(isset($_GET['close'])) {
	shell_exec('sudo python device2/close.py');
	echo "Closed air vent\n";
}

# Setpoint control
if(isset($_POST['setpoint'])) {
	file_put_contents('setpoint', $_POST['set']);
	echo "Changed set point to [" . $_POST['set'] . "]\n";
}
if(isset($_GET['set'])) {
	file_put_contents('setpoint', $_POST['set']);
	echo "Changed set point to [" . $_POST['set'] . "]\n";
}

# Mode switch
if(isset($_POST['mode_cool'])) {
	file_put_contents('mode', 'cool');
	echo "Switched to cooling mode.\n";
}
if(isset($_POST['mode_off'])) {
	file_put_contents('mode', 'off');
	echo "Switched to off (fan only) mode.\n";
}
if(isset($_POST['mode_heat'])) {
	file_put_contents('mode', 'heat');
	echo "Switched to heating mode.\n";
}
if(isset($_POST['mode_both'])) {
	file_put_contents('mode', 'both');
	echo "Switched to both (comfy) mode.\n";
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
<form method="POST" action="ac.php">
<?php
if( strpos(file_get_contents("mode"),'cool') !== false) {
    // Cooling mode
    echo '<div>';
    include("acstate.html");
    echo '</div>';
    echo '<input type="submit" name="on" value="Switch AC ON" style="padding:18px; width:40%; margin:8px; background-color:#0F0;"><input type="submit" name="off" value="Switch AC OFF" style="padding:18px; width:40%; margin:8px; background-color:#F00;"><br><input type="submit" name="run" value="Run for 25m" style="padding:18px; width:84%; margin:8px; background-color:#777;">';
} elseif( strpos(file_get_contents("mode"),'heat') !== false) {
    // Heating mode
	echo '<div>';
	include("heatstate.html");
	echo '</div>';
	echo '<input type="submit" name="furnace_on" value="Switch furnace ON" style="padding:18px; width:40%; margin:8px; background-color:#0F0;"><input type="submit" name="furnace_off" value="Switch furnace OFF" style="padding:18px; width:40%; margin:8px; background-color:#F00;"><br><input type="submit" name="furnace_run" value="Run for 25m" style="padding:18px; width:84%; margin:8px; background-color:#777;">';
} elseif( strpos(file_get_contents("mode"),'off') !== false) {
	// Off mode, but show cooling controls anyway
	echo '<div>';
	include("acstate.html");
    echo '</div>';
    echo '<input type="submit" name="on" value="Switch AC ON" style="padding:18px; width:40%; margin:8px; background-color:#0F0;"><input type="submit" name="off" value="Switch AC OFF" style="padding:18px; width:40%; margin:8px; background-color:#F00;"><br><input type="submit" name="run" value="Run for 25m" style="padding:18px; width:84%; margin:8px; background-color:#777;">';
} elseif( strpos(file_get_contents("mode"),'both') !== false) {
	// Both mode, shwo both controls
	echo '<div>';
	include("heatstate.html");
	echo '</div>';
	echo '<input type="submit" name="furnace_on" value="Switch furnace ON" style="padding:18px; width:40%; margin:8px; background-color:#0F0;"><input type="submit" name="furnace_off" value="Switch furnace OFF" style="padding:18px; width:40%; margin:8px; background-color:#F00;"><br><input type="submit" name="furnace_run" value="Run for 25m" style="padding:18px; width:84%; margin:8px; background-color:#777;">';
	echo '<div>';
	include("acstate.html");
    echo '</div>';
    echo '<input type="submit" name="on" value="Switch AC ON" style="padding:18px; width:40%; margin:8px; background-color:#0F0;"><input type="submit" name="off" value="Switch AC OFF" style="padding:18px; width:40%; margin:8px; background-color:#F00;"><br><input type="submit" name="run" value="Run for 25m" style="padding:18px; width:84%; margin:8px; background-color:#777;">';
}
echo '<div>';
include("ventstate.html");
echo '</div>';
echo '<input type="submit" name="open" value="Open Vent" style="padding:18px; width:40%; margin:8px; background-color:#0F0;"><input type="submit" name="close" value="Close Vent" style="padding:18px; width:40%; margin:8px; background-color:#F00;">';
echo '<div>Set point</div><input type="number" name="set" min="70" max="76" style="font-size:36px; width:40%; margin:8px;" value=';
echo (file_get_contents ("setpoint"));
echo '><input type="submit" name="setpoint" value="Set" style="padding:18px; width:39%; margin:8px; background-color:#777;">';
echo '<div>Current mode is: ';
include("mode");
echo '</div>';
echo '</div>';
echo '<input type="submit" name="mode_cool" value="Cool" style="padding:11px; width:20%; margin:4px; background-color:#42c5f4;"><input type="submit" name="mode_off" value="Off" style="padding:11px; width:19%; margin:4px; background-color:#777;"><input type="submit" name="mode_both" value="Both" style="padding:11px; width:20%; margin:4px; background-color:#b027ea;"><input type="submit" name="mode_heat" value="Heat" style="padding:11px; width:20%; margin:4px; background-color:orange;">';
?>
</form>
</body>
</html>
