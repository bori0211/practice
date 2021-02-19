<?
	// REQUIRE FILES (필수)
	require "../config.inc.php";
	require "../set_init_data.inc.php";
	//require "../function.inc.php";
	
	header("Content-Type: application/json; charset=utf-8");
	
	
	
	echo '{"entry": ' . json_encode(get_write_after_entry($currentLat, $currentLon)) . '}';
	
	
	
	// ENTRY
	function get_write_after_entry($currentLat, $currentLon) {
		$currentDate = date("Y-m-d H:i:s");
		list($usec, $micro_sec) = explode(" ", microtime());
		
		ob_start();
?>
      <li class="entry" id="entry-<?= $micro_sec ?>">
        <div class="entry-profile">
          <img class="rounded-circle entry-profile-img" src="https://demo.hemochart.com/assets/anonymous.png">
        </div>
        
        <div class="entry-content ml-4" style="margin-top:-2px;">
          <div class="entry-header">
            <div class="entry-heading">
              <span class="font-weight-bold"><?= $currentDate ?></span> <span class="text-grey">(<?= $micro_sec ?>)</span>
            </div>
            <div class="entry-extra" style="margin-top:-3px;">
              <button class="btn btn-default btn-xs btn-flat delete-btn"><i class="fas fa-times fa-fw text-danger"></i></button>
            </div>
          </div>
          <div class="entry-body mt-2">
            <span><?= $currentLat ?></span>
            <span><?= $currentLon ?></span>
          </div>
        </div>
      </li>
<?
		$output = ob_get_contents();
		
		ob_end_clean();
		
		return $output;
	}
?>