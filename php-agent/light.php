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
            
            <span id="light"></span>
            
          </div>
        </div>
      </div>
    </main>

<script>
  
  $(document).ready(function() {
if ( 'AmbientLightSensor' in window ) {
  const sensor = new AmbientLightSensor();
  sensor.onreading = () => {
    console.log('Current light level:', sensor.illuminance);
  };
  sensor.onerror = (event) => {
    console.log(event.error.name, event.error.message);
  };
  sensor.start();
  $("#light").text("light sensor start");
} else {
  console.log("no light");
  $("#light").text("no light");
}

  });
  
</script>

<?
	// FOOTER INCLUDE
	include "./footer.inc.php";
	
	// MYSQLi CLOSE
	$mysqli->close();
?>
