(function () {
  "use strict";
  
  // http -> https
  if (location.protocol !== "https:") {
    location.href = "https:" + location.href.substring(location.protocol.length);
  }
  
  // Host º¯°æ
  if ($("#write-form :input[name='host']").length > 0) {
    $("#write-form :input[name='host']").on("change", function(e) {
      location.href = "/?host=" + $(this).val();
    });
  }
  
})();
