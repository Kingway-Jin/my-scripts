#MaxHotkeysPerInterval 1000
$WheelUp::
    Send {WheelDown}
Return

$WheelDown::
    Send {WheelUp}
Return
