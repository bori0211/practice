<?php

$curl = curl_init();

curl_setopt_array($curl, array(
  CURLOPT_URL => 'https://influxdb2.webframe.me/api/v2/write?org=devTeam&bucket=datafirst&precision=s',
  CURLOPT_RETURNTRANSFER => true,
  CURLOPT_ENCODING => '',
  CURLOPT_MAXREDIRS => 10,
  CURLOPT_TIMEOUT => 0,
  CURLOPT_FOLLOWLOCATION => true,
  CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
  CURLOPT_CUSTOMREQUEST => 'POST',
  CURLOPT_POSTFIELDS =>'test-php-curl,host=host1 currentLat=20.5,currentLon=90.9',
  CURLOPT_HTTPHEADER => array(
    'Authorization: Token AuGen9c4scgBONy9m3qRLIYFJmR9nbMeTyf6FQqze49kPhHkywV72-kUwdmrTqEix9zJgAeRgB_EgE_odLVnhQ==',
    'Content-Type: text/plain'
  ),
));

$response = curl_exec($curl);

curl_close($curl);
echo $response;
?>