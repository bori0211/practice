<?
	// REQUIRE FILES (필수)
	require "./config.inc.php";
	require "./set_init_data.inc.php";
	require "./function.inc.php";
	
	// MYSQLi INSTANCE
	$mysqli = mysqli_instance("mqtt");
	
	
	
	// HEADER INCLUDE
	include "./header.inc.php";
?>

    <main class="content-main">
      <div class="content-wrapper">
        <div class="container">
          <div class="row">
            
            <div class="col-md mb-2">
              <table class="table table-bordered">
                <thead>
                  <tr>
                    <th>
                      Weather
                      <div class="btn-group">
                        <button class="btn btn-default btn-xs btn-flat start-btn" type="button">
                          <i class="fas fa-play fa-fw"></i>
                        </button>
                        <button class="btn btn-default btn-xs btn-flat stop-btn" type="button">
                          <i class="fas fa-stop fa-fw"></i>
                        </button>
                      </div>
                    </th>
                  </tr>
                </thead>
                </tbody>
                  <tr>
                    <td class="text-center">
                      Try: <span id="try-count">0</span>
                    </td>
                  </tr>
                  <tr>
                    <td class="text-center">
                      Temperature: <span id="temp">0</span>
                    </td>
                  </tr>
                  <tr>
                    <td class="text-center">
                      Save: <span id="save-success">0</span> / <span id="save-error">0</span>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
            
            <div class="col-md mb-2">
              <table class="table table-bordered">
                <thead>
                  <tr>
                    <th>
                      Chart
                      <div class="btn-group">
                        <button class="btn btn-default btn-xs btn-flat refresh-chart-btn" type="button">
                          <i class="fas fa-redo fa-fw"></i>
                        </button>
                      </div>
                    </th>
                  </tr>
                </thead>
                </tbody>
                  <tr>
                    <td class="text-center">
                      <div id="temp-chart" style="height:300px;">
                        <div class="text-center py-4"><i class="fas fa-spinner fa-spin"></i></div>
                      </div>
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
  var nIntervId;
  var delay = 60000;
  //var delay = 5000;
  
  function saveWeather() {
    var weatherData = {
      "measurement": $("#write-form :input[name='measurement']").val(),
      "host": $("#write-form :input[name='host']").val()
    };
    
    $("#try-count").text(parseInt($("#try-count").text()) + 1);
    
    $.post("/parts/agents/weather.php", weatherData, function(response) {
      if (response.result) {
        $("#temp").text(response.temp);
        $("#save-success").text(parseInt($("#save-success").text()) + 1);
      } else {
        console.log("error");
        $("#save-error").text(parseInt($("#save-error").text()) + 1);
      }
    }, "json").fail(function(xhr) {
      console.log(xhr);
    });
  }
  
  $(document).ready(function() {
    $(".start-btn").on("click", function(e) {
      saveWeather();
      nIntervId = setInterval(saveWeather, delay);
      $(".start-btn").attr("disabled", true);
      $(".stop-btn").attr("disabled", false);
    });
    
    $(".stop-btn").on("click", function(e) {
      clearInterval(nIntervId);
      $(".start-btn").attr("disabled", false);
      $(".stop-btn").attr("disabled", true);
    });
    
    $(".refresh-chart-btn").on("click", function(e) {
      $("#temp-chart").html('<div class="text-center py-4"><i class="fas fa-spinner fa-spin"></i></div>'); // spin
      drawChart();
    });
    
    if (!nIntervId) {
      $(".start-btn").trigger("click");
    } else {
      $(".stop-btn").trigger("click");
    }
    
    // GOOGLE CHART
    google.charts.load("current", {"packages": ["table", "corechart", "bar"]});
    google.charts.setOnLoadCallback(drawChart);
  });
  
  function drawChart() {
    //console.log("drawChart");
    
    var weatherData = {
      "measurement": $("#write-form :input[name='measurement']").val(),
      "host": $("#write-form :input[name='host']").val()
    };
    
    // drawChart
    $.get("/parts/chart/weather.php", weatherData, function(response) {
      //$("#steam-chart").html(""); // spin remove
      var chart = new google.visualization.LineChart(document.getElementById("temp-chart"));
      var data = new google.visualization.DataTable(response);
      var dateFormat = new google.visualization.DateFormat({formatType: "long", timeZone: +9});
      dateFormat.format(data, 0);
      //dataTable.getFormattedValue(0, 0);
      
      var options = {
        title: "Weather",
        interpolateNulls: 'absolute',
        legend: "none",
        pointSize: 1,
        hAxis: {
          format: "HH:mm",
          minValue: response.minValue,
          maxValue: response.maxValue
        },
        vAxis: {
          viewWindowMode: "maximized",
          viewWindow: {
            min: -15,
            max: 15
          }
        }
      };
      //console.log(data);
      chart.draw(data, options);
    }, "json").fail(function(xhr) {
      console.log(xhr);
    });
  }
  
</script>

<?
	// FOOTER INCLUDE
	include "./footer.inc.php";
	
	// MYSQLi CLOSE
	$mysqli->close();
?>
