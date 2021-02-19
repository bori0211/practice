<?
	// REQUIRE FILES (필수)
	require "./config.inc.php";
	require "./set_init_data.inc.php";
	require "./function.inc.php";
	
	// MYSQLi INSTANCE
	$mysqli = mysqli_instance("mqtt");
	
	
	
	// DEFAULT
	if ($filter_period == "") $filter_period = "10m";
	
	// WHERE & ORDER
	$where = " WHERE TRUE";
	if ($filter_period == "10m") $where .= " AND time > DATE_ADD(SYSDATE(), INTERVAL -10 MINUTE)";
	if ($filter_period == "30m") $where .= " AND time > DATE_ADD(SYSDATE(), INTERVAL -30 MINUTE)";
	if ($filter_period == "1h") $where .= " AND time > DATE_ADD(SYSDATE(), INTERVAL -1 HOUR)";
	if ($filter_period == "3h") $where .= " AND time > DATE_ADD(SYSDATE(), INTERVAL -3 HOUR)";
	if ($filter_period == "6h") $where .= " AND time > DATE_ADD(SYSDATE(), INTERVAL -6 HOUR)";
	if ($filter_period == "12h") $where .= " AND time > DATE_ADD(SYSDATE(), INTERVAL -12 HOUR)";
	if ($filter_period == "24h") $where .= " AND time > DATE_ADD(SYSDATE(), INTERVAL -24 HOUR)";
	$order = " ORDER BY time DESC";
	
	
	
	// PREPARE
	list($total_row_cnt) = $mysqli->query_fetch_first_row("SELECT COUNT(*) FROM mqttdb" . $where);
	
	$query = "SELECT eui, accel0, accel1, accel2, accel3, accel4, accel5, accel6, accel7, accel8, accel9, accel10, accel11, accel12, accel13, accel14, accel15, accel16, accel17, accel18, accel19, accel20, accel21, accel22, accel23, accel24, accel25, accel26, accel27, accel28, accel29, temp0, time FROM mqttdb";
	$query .= $where . $order;
	
	$rows = $mysqli->query_fetch_all($query);
	
	
	
	// HEADER INCLUDE
	include "./header.inc.php";
?>

    <main class="content-main">
      <div class="content-wrapper">
        <div class="container">
          <div class="row">
            <div class="col pr-0">
              <!-- geolocation -->
              <table class="table table-bordered" id="col-geolocation">
                <thead>
                  <tr>
                    <th>
                      geolocation
                    </th>
                  </tr>
                </thead>
                </tbody>
                  <tr>
                    <td class="text-center">
                      Geo Result: <span class="geo-result-success">0</span> / <span class="geo-result-error">0</span>
                    </td>
                  </tr>
                  <tr>
                    <td class="text-center">
                      Current Latitude: <span class="current-latitude">0</span><br>
                      Current Longitude: <span class="current-longitude">0</span>
                    </td>
                  </tr>
                  <tr>
                    <td class="text-center">
                      Geo Sent: <span class="geo-sent-success">0</span> / <span class="geo-sent-error">0</span>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
            <div class="col px-2">
              <!-- Blank -->
              <table class="table table-bordered" id="col-blank-1">
                <thead>
                  <tr>
                    <th>
                      Blank
                    </th>
                  </tr>
                </thead>
                </tbody>
                  <tr>
                    <td class="text-center">
                      111
                      222
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
            <div class="col-5 pl-0">
              <!-- Blank -->
              <table class="table table-bordered" id="sch-hdfs-ps-info">
                <thead>
                  <tr>
                    <th>
                      Blank
                    </th>
                  </tr>
                </thead>
                </tbody>
                  <tr>
                    <td class="text-center">
                      333
                      444
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </main>

<script>
  // Main
  var nIntervId;
  var startPos;
  //var delay = 60000;
  var delay = 5000;
  var geoOptions = {
    maximumAge: 5 * 60 * 1000,
    enableHighAccuracy: false
  }
  
  var geoResultSuccess = 0;
  var geoResultError = 0;
  var geoSentSuccess = 0;
  var geoSentError = 0;
  
  function geoLocationSave() {
    // https://developers.google.com/web/fundamentals/native-hardware/user-location?hl=ko
    // https://developer.mozilla.org/ko/docs/WebAPI/Using_geolocation
    navigator.geolocation.getCurrentPosition(geoSuccess, geoError, geoOptions);
  }
  
  var geoSuccess = function(position) {
    startPos = position;
    
    geoResultSuccess = $("#col-geolocation .geo-result-success").text();
    geoResultSuccess = parseInt(geoResultSuccess);
    geoResultSuccess += 1;
    
    $("#col-geolocation .geo-result-success").text(geoResultSuccess);
    
    $("#col-geolocation .current-latitude").text(startPos.coords.latitude);
    $("#col-geolocation .current-longitude").text(startPos.coords.longitude);
    
    writeInfluxDB2(startPos.coords.latitude, startPos.coords.longitude);
  };
  
  var geoError = function(error) {
    console.log('Error occurred. Error code: ' + error.code);
    
    geoResultError = $("#col-geolocation .geo-result-error").text();
    geoResultError = parseInt(geoResultError);
    geoResultError += 1;
    
    $("#col-geolocation .geo-result-error").text(geoResultError);
  };
  
  function writeInfluxDB2(currentLat, currentLon) {
    var myHeaders = new Headers();
    myHeaders.append("Authorization", "Token HIUIu2nYdXq_g8WT4k-IKJTN2VP_DFykG14oR5FBaArsWfmuKaj70atQy6YAH5GKb8SYLoHoumqnTcRa2skmXw==");
    myHeaders.append("Content-Type", "text/plain");
    
    var raw = "test-df-web,host=host1 currentLat=" + currentLat + ",currentLon=" + currentLon;
    
    var requestOptions = {
      method: 'POST',
      headers: myHeaders,
      body: raw,
      redirect: 'follow'
    };
    
    fetch("https://us-west-2-1.aws.cloud2.influxdata.com/api/v2/write?org=bori0211@gmail.com&bucket=datafirst&precision=s", requestOptions)
      .then(response => response.text())
      .then(result => {
        geoSentSuccess = $("#col-geolocation .geo-sent-success").text();
        geoSentSuccess = parseInt(geoSentSuccess);
        geoSentSuccess += 1;
        
        $("#col-geolocation .geo-sent-success").text(geoSentSuccess);
      })
      .catch(error => {
        geoSentError = $("#col-geolocation .geo-sent-error").text();
        geoSentError = parseInt(geoSentError);
        geoSentError += 1;
        
        $("#col-geolocation .geo-sent-error").text(geoSentError);
      });
  }
  
  
  
  // FIRST START
  $(document).ready(function() {
    // check for Geolocation support
    if (navigator.geolocation) {
      console.log('Geolocation is supported!');
      
      geoLocationSave();
      
      nIntervId = setInterval(geoLocationSave, delay);
      
    } else {
      
      console.log('Geolocation is not supported for this Browser/OS.');
    }
  });
  
</script>

<?
	// FOOTER INCLUDE
	include "./footer.inc.php";
	
	// MYSQLi CLOSE
	$mysqli->close();
?>
