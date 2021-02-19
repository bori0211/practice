<?
	// REQUIRE FILES (필수)
	require "../../config.inc.php";
	require "../../set_init_data.inc.php";
	require "../../function.inc.php";
	
	header("Content-Type: application/json; charset=utf-8");
	
	
	
	// SEND DATA
	use InfluxDB2\Client;
	use InfluxDB2\WriteType as WriteType;
	
	# You can generate a Token from the "Tokens Tab" in the UI
	$token = 'HIUIu2nYdXq_g8WT4k-IKJTN2VP_DFykG14oR5FBaArsWfmuKaj70atQy6YAH5GKb8SYLoHoumqnTcRa2skmXw==';
	$org = 'bori0211@gmail.com';
	//$bucket = ''; $bucket 넘겨 받음
	
	$client = new Client([
	    "url" => "https://us-west-2-1.aws.cloud2.influxdata.com",
	    "token" => $token,
	]);
	
	//$query = "from(bucket: \"datafirst\")   |> range(start: -12h)   |> filter(fn: (r) => r["_measurement"] == "weather")   |> filter(fn: (r) => r["_field"] == "temp")   |> filter(fn: (r) => r["host"] == "my-desktop")   |> aggregateWindow(every: v.windowPeriod, fn: mean, createEmpty: false)   |> yield(name: "mean")";
	//$query = "from(bucket: \"datafirst\")   |> range(start: -12h)   |> aggregateWindow(every: v.windowPeriod, fn: mean, createEmpty: false) ";
	
	//$query = "from(bucket: \"datafirst\") |> range(start: -1h) |> filter(fn: (r) => r[\"_measurement\"] == \"weather\") |> filter(fn: (r) => r[\"_field\"] == \"temp\") ";
	$query = 'from(bucket: "datafirst") |> range(start: -24h) |> filter(fn: (r) => r["_measurement"] == "weather") |> filter(fn: (r) => r["_field"] == "temp") |> filter(fn: (r) => r["host"] == "my-desktop") |> aggregateWindow(every: 1m, fn: mean, createEmpty: true)   |> yield(name: "mean") ';
	$tables = $client->createQueryApi()->query($query, $org);
	
	//var_dump($tables[0]);
	//var_dump($tables[0]->records);
	

	foreach ($tables[0]->records as $key => $record) {
		var_dump($key);
		
		if ($key == 1) var_dump($record->values["_time"]);
		if ($key == 1) var_dump($record->values["_value"]);
		
		
		$year = substr($record->values["_time"], 0, 4);
		$month = substr($record->values["_time"], 5, 2);
		$day = substr($record->values["_time"], 8, 2);
		
		$hours = substr($record->values["_time"], 11, 2);
		$minutes = substr($record->values["_time"], 14, 2);
		$seconds = substr($record->values["_time"], 17, 2);
		
		var_dump($year);
		var_dump($month);
		var_dump($day);
		var_dump($hours);
		var_dump($minutes);
		var_dump($seconds);
	}
	
	
	
	// RESULT
	echo '{"result": true, "temp": ' . $weatherData["main"]["temp"] . '}';
?>