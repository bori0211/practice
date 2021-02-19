<?
	// REQUIRE FILES (필수)
	require "../../config.inc.php";
	require "../../set_init_data.inc.php";
	require "../../function.inc.php";
	
	header("Content-Type: application/json; charset=utf-8");
	
	// MYSQLi INSTANCE
	$mysqli = mysqli_instance("mqtt");
	
	
	
	echo '{';
	echo '  "cols": [';
	echo '    {"id": "", "label": "Date", "pattern": "", "type": "date"},';
	echo '    {"id": "", "label": "temp", "pattern": "", "type": "number"},';
	echo '    {"type": "string", "p": {"role": "annotation"}}';
	echo '  ],';
	echo '  "rows": [';
	
	$s_date = date("Y-m-d\TH:i:s+09:00", mktime(date("H"), date("i"), date("s"), date("m"), date("d") - 1, date("Y"))); // 하루 전
	$e_date = date("Y-m-d\TH:i:s+09:00", mktime(date("H"), date("i"), date("s") - 1, date("m"), date("d"), date("Y"))); // 1초 전
	
	// GET DATA
	use InfluxDB2\Client;
	use InfluxDB2\WriteType as WriteType;
	
	$client = new Client([
	    "url" => INFLUXDB2_URL,
	    "token" => INFLUXDB2_TOKEN,
	]);
	
	$query = 'from(bucket: "' . INFLUXDB2_BUCKET . '")';
	$query .= '  |> range(start: ' . $s_date . ', stop: ' . $e_date . ')';
	$query .= '  |> filter(fn: (r) => r["_measurement"] == "' . $measurement . '")';
	$query .= '  |> filter(fn: (r) => r["host"] == "' . $host . '")';
	$query .= '  |> filter(fn: (r) => r["_field"] == "temp")';
	$query .= '  |> aggregateWindow(every: 5m, fn: mean, createEmpty: true)';
	$query .= '  |> yield(name: "mean")';
	
	$tables = $client->createQueryApi()->query($query, INFLUXDB2_ORG);
	
	if (is_array($tables[0]->records)) {
		foreach ($tables[0]->records as $key => $record) {
			$isAnnotation = false;
			
			if ($key > 0) echo ', ';
			
			$year = substr($record->values["_time"], 0, 4);
			$month = substr($record->values["_time"], 5, 2);
			$day = substr($record->values["_time"], 8, 2);
			
			$hours = substr($record->values["_time"], 11, 2);
			$minutes = substr($record->values["_time"], 14, 2);
			$seconds = substr($record->values["_time"], 17, 2);
			
			$value = $record->values["_value"];
			
			if ($hours % 2 == 0 && $minutes == 0) $isAnnotation = true;
			
			
			echo '    {"c": [';
			echo '      {"v": "Date(' . $year . ', ' . ($month - 1) . ', ' . $day . ', ' . ($hours + 9) . ', ' . $minutes . ', ' . $seconds . ')", "f": null},';
			
			if ($value != "")
				echo '      {"v": ' . $value . ', "f": null},';
			else
				echo '      {"v": null, "f": null},';
			
			if ($isAnnotation)
				echo '      {"v": "' . number_format($value, 1) . '", "f": null}';
			else
				echo '      {"v": null, "f": null}';
			echo '    ]}';
		}
	}
	
	echo '  ],';
	
	$s_year = substr($s_date, 0, 4);
	$s_month = substr($s_date, 5, 2);
	$s_day = substr($s_date, 8, 2);
	$s_hours = substr($s_date, 11, 2);
	$s_minutes = substr($s_date, 14, 2);
	$s_seconds = substr($s_date, 17, 2);
	
	$e_year = substr($e_date, 0, 4);
	$e_month = substr($e_date, 5, 2);
	$e_day = substr($e_date, 8, 2);
	$e_hours = substr($e_date, 11, 2);
	$e_minutes = substr($e_date, 14, 2);
	$e_seconds = substr($e_date, 17, 2);
	
	echo '  "minValue": "Date(' . $s_year . ', ' . ($s_month - 1) . ', ' . $s_day . ', ' . $s_hours . ', ' . $s_minutes . ', ' . $s_seconds . ')",';
	echo '  "maxValue": "Date(' . $e_year . ', ' . ($e_month - 1) . ', ' . $e_day . ', ' . ($e_hours) . ', ' . $e_minutes . ', ' . $e_seconds . ')"';
	echo '}';
	
	
	
	// MYSQLi CLOSE
	$mysqli->close();
?>