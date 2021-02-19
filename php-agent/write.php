<!DOCTYPE html>

<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no,user-scalable=no">
    <title>DF agent</title>
    <link rel="shortcut icon" href="/influxdb2/telegraf-16x16.png" type="image/png">
    <link rel="stylesheet" href="//fonts.googleapis.com/css?family=Roboto:400,700|Raleway:400,700|Noto+Sans+KR:400,700">
    <link rel="stylesheet" href="/bower/bootstrap/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="/bower/fontawesome/css/all.min.css">
    <link rel="stylesheet" href="/influxdb2/style.css">
    <script src="/bower/jquery/dist/jquery.min.js"></script>
    <!-- PWA -->
    <link rel="manifest" href="/influxdb2/manifest.json">
    <link rel="apple-touch-icon" href="/influxdb2/telegraf-192x192.png">
  </head>
  
  <body>
    <nav class="navbar fixed-top" style="justify-content: space-between;">
      <div class="navbar-logo">
        <a class="sidebar-toggle" href="#" role="button" data-toggle="sidebar"><i class="fas fa-bars fa-fw"></i></a>
      </div>
      <div class="navbar-search-form">
        <form role="form" id="write-form">
        <div class="input-group" style="width:16em">
          <input class="form-control" type="text" name="measurement" value="test-df-web">
          <select class="form-control" name="delay">
            <option value="1000">1s</option>
            <option value="5000" selected>5s</option>
            <option value="10000">10s</option>
            <option value="30000">30s</option>
            <option value="60000">1m</option>
            <option value="300000">5m</option>
            <option value="600000">10m</option>
          </select>
          <div class="input-group-append">
            <button class="btn btn-default btn-flat start-btn" type="button" onclick="startWriteData();"><i class="fas fa-play fa-fw text-success"></i></button>
            <button class="btn btn-default btn-flat stop-btn" type="button" onclick="stopWriteData();" disabled><i class="fas fa-stop fa-fw text-danger"></i></button>
          </div>
        </div>
        </form>
      </div>
      
      <div class="navbar-custom-menu">
        <div class="dropdown dropdown-fadeinout login-profile-dropdown">
          <a class="d-block" href="#" data-toggle="dropdown">
            <img class="login-profile-img" src="https://demo.hemochart.com/assets/anonymous.png">
          </a>
          <div class="dropdown-menu dropdown-menu-arrow-top stop-propagation mt-2">
            <div class="dropdown-body">
              <img class="rounded-circle body-img" src="https://demo.hemochart.com/assets/anonymous.png">
              <p class="pt-3 mb-0">
                <strong>김하나</strong>님<br>
                환영합니다 <i class="far fa-laugh fa-fw"></i>
              </p>
            </div>
            <div class="dropdown-footer">
              <a class="btn btn-default btn-sm" href="/mobile/login?act=logout">로그아웃</a>
            </div>
          </div>
        </div>
      </div>
    </nav>
    
    <main class="content-main" data-params='{"selectedContent": "", "selectedAct": ""}'>
      <div class="content-wrapper">
        
  <div class="content">
    <ul class="content-entries" data-params='{"selected_tab": "<?= $selected_tab ?>", "filter": "<?= $filter ?>", "nq": "<?= $nq ?>", "page": 1}'>
      <!--<li class="entry">
        <div class="mx-auto" style="line-height:19px;"><i class="fas fa-spinner fa-spin mx-auto"></i></div>
      </li>-->
    </ul>
  </div>
        
      </div>
    </main>
    
<script>
  // Main
  var nIntervId;
  var startPos;
  var geoOptions = {
    maximumAge: 5 * 60 * 1000,
    enableHighAccuracy: false
  }
  
  function startWriteData() {
    var delay = $("#write-form :input[name='delay']").val();
    writeData();
    nIntervId = setInterval(writeData, delay);
  }
  
  function writeData() {
    console.log("writeData");
    // https://developers.google.com/web/fundamentals/native-hardware/user-location?hl=ko
    // https://developer.mozilla.org/ko/docs/WebAPI/Using_geolocation
    navigator.geolocation.getCurrentPosition(geoSuccess, geoError, geoOptions);
    
    $("#write-form :input[name='measurement']").attr("disabled", true);
    $("#write-form :input[name='delay']").attr("disabled", true);
    
    $(".start-btn").attr("disabled", true);
    $(".stop-btn").attr("disabled", false);
  }
  
  function stopWriteData() {
    clearInterval(nIntervId);
    
    $("#write-form :input[name='measurement']").attr("disabled", false);
    $("#write-form :input[name='delay']").attr("disabled", false);
    
    $(".start-btn").attr("disabled", false);
    $(".stop-btn").attr("disabled", true);
  }
  
  
  
  var geoSuccess = function(position) {
    startPos = position;
    //var existStartLat = document.getElementById('startLat').innerHTML;
    //var existStartLon = document.getElementById('startLon').innerHTML;
    //document.getElementById('startLat').innerHTML = existStartLat + "<br>" + startPos.coords.latitude;
    //document.getElementById('startLon').innerHTML = existStartLon + "<br>" + startPos.coords.longitude;
    writeInfluxDB2(startPos.coords.latitude, startPos.coords.longitude);
  };
  
  var geoError = function(error) {
    console.log('Error occurred. Error code: ' + error.code);
    // error.code can be:
    //   0: unknown error
    //   1: permission denied
    //   2: position unavailable (error response from location provider)
    //   3: timed out
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
        $.get("/influxdb2/write_after_entry.php", {"currentLat": currentLat, "currentLon": currentLon}, function(response) {
          console.log(response);
          $(".content-entries").append(response.entry);
        }, "json").fail(function(xhr) {
          console.log(xhr);
        });
      })
      .catch(error => console.log('error', error));
  }



$(document).ready(function() {
  // check for Geolocation support
  if (navigator.geolocation) {
    console.log('Geolocation is supported!');
  } else {
    alert('Geolocation is not supported for this Browser/OS.');
  }
  
  // Event Handler
  $(".content-entries").on("click", ".delete-btn", function(e) {
    //console.log($(this).parents(".entry"));
    $(this).parents(".entry").remove();
  });
});
</script>
    
  </body>
</html>
