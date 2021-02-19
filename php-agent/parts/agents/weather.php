<?
	// REQUIRE FILES (필수)
	require "../../config.inc.php";
	require "../../set_init_data.inc.php";
	require "../../function.inc.php";
	
	header("Content-Type: application/json; charset=utf-8");
	
	
	
	// GET DATA
	$curl = curl_init();
	
	curl_setopt_array($curl, array(
		CURLOPT_URL => 'https://api.openweathermap.org/data/2.5/weather?q=Seoul&units=metric&appid=c83ca9bf23dcc3837b011902a418292c',
		CURLOPT_RETURNTRANSFER => true,
		CURLOPT_ENCODING => '',
		CURLOPT_MAXREDIRS => 10,
		CURLOPT_TIMEOUT => 0,
		CURLOPT_FOLLOWLOCATION => true,
		CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
		CURLOPT_CUSTOMREQUEST => 'GET',
	));
	
	$response = curl_exec($curl);
	
	$weatherData = json_decode($response, true);
	
	curl_close($curl);
	
	//var_dump($weatherData["main"]["temp"]);
	
	
	
	// SET DATA
	use InfluxDB2\Client;
	use InfluxDB2\WriteType as WriteType;
	
	# You can generate a Token from the "Tokens Tab" in the UI
	$token = 'HIUIu2nYdXq_g8WT4k-IKJTN2VP_DFykG14oR5FBaArsWfmuKaj70atQy6YAH5GKb8SYLoHoumqnTcRa2skmXw==';
	$org = 'bori0211@gmail.com';
	//$bucket = ''; $bucket 넘겨 받음
	
	$client = new Client([
	    "url" => INFLUXDB2_URL,
	    "token" => INFLUXDB2_TOKEN,
	]);
	
	$writeApi = $client->createWriteApi();
	
	$data = $measurement . ",host=" . $host . " temp=" . $weatherData["main"]["temp"];
	
	$writeApi->write($data, InfluxDB2\Model\WritePrecision::S, INFLUXDB2_BUCKET, INFLUXDB2_ORG);
	
	
	
	// RESULT
	echo '{"result": true, "temp": ' . $weatherData["main"]["temp"] . '}';
?>