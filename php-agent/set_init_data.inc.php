<?
	// MAGIC_QUOTES_GPC
	if (ini_get("magic_quotes_gpc") != true) {
		foreach ($_REQUEST as &$value) {
		    if (is_array($value))
		    	$value = array_map("addslashes", $value);
		    else if (is_string($value))
		    	$value = addslashes($value);
		}
	}
	
	// REGISTER_GLOBALS
	if (ini_get("register_globals") != true) {
		extract($_REQUEST, EXTR_SKIP);
		
		$PHP_SELF = $_SERVER["PHP_SELF"];
	}
	
	
	
	// LOCALE
	setlocale(LC_TIME, "ko_KR.UTF-8");
	
	// RAW HTTP HEADER SEND (HTTP/1.1)
	header("Cache-Control: no-store, no-cache, must-revalidate");
?>