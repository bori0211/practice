<?
	// COMPOSER AUTOLOAD
	require __DIR__ . "/vendor/autoload.php";
	
	// MySQLi Extends
	class mysqli_ext extends mysqli {
		function __construct($db_config) {
			$db_host = $db_config["db_host"];
			$db_user = $db_config["db_user"];
			$db_password = $db_config["db_password"];
			$db_name = $db_config["db_name"];
			
			return parent::__construct($db_host, $db_user, $db_password, $db_name);
		}
		
		function query($query, $resultmode = MYSQLI_STORE_RESULT) {
			$result = parent::query($query, $resultmode);
			
			if ($result == false)
				error_log("MySQLi Query Error [" . $query . " | " . $this->error . "] [" . $_SERVER["HTTP_HOST"] . " " . $_SERVER["REQUEST_URI"] . "] [" . $_SERVER["HTTP_X_FORWARDED_FOR"] . ": " . $_SERVER["HTTP_USER_AGENT"] . "]");
			
			return $result;
		}
		
		function query_fetch_first_row($query) {
			$first_row = null;
			
			if ($res = $this->query($query)) {
				if ($row = $res->fetch_row())
					$first_row = $row;
				
				$res->close();
			}
			
			return $first_row;
		}
		
		function query_fetch_all($query, $resulttype = MYSQLI_ASSOC) {
			$rows = null;
			
			if ($res = $this->query($query)) {
				$rows = $res->fetch_all($resulttype);
				
				$res->close();
			}
			
			return $rows;
		}
	}
	
	// MYSQLi INSTANCE
	function mysqli_instance() {
		$mysqli = new mysqli_ext($GLOBALS["db_config"]);
		
		if ($mysqli->connect_error) {
			exit("Connect Error (" . $mysqli->connect_errno . ") " . $mysqli->connect_error);
		}
		
		if ($mysqli->character_set_name() != "utf8mb4") {
			exit("Error loading character set utf8mb4");
		}
		
		return $mysqli;
	}
	
	// PAGE STATISTICS
	function getmicrotime() {
    	$microtimestmp = explode(" ", microtime());
    	return $microtimestmp[0] + $microtimestmp[1];
	}
?>