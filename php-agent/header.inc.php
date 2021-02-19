<?
	echo "<!DOCTYPE html>\n";
?>

<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width,initial-scale=1,shrink-to-fit=no,user-scalable=no">
    <title>DF agent</title>
    <link rel="shortcut icon" href="/assets/favicon-16x16.png" type="image/png">
    <link rel="stylesheet" href="//fonts.googleapis.com/css?family=Roboto:400,700|Raleway:400,700|Noto+Sans+KR:400,700">
    <link rel="stylesheet" href="/bower/bootstrap/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="/bower/fontawesome/css/all.min.css">
    <link rel="stylesheet" href="/custom/style.css">
    <script src="/bower/jquery/dist/jquery.min.js"></script>
    <!-- PWA -->
    <link rel="manifest" href="/manifest.json">
    <link rel="apple-touch-icon" href="/assets/favicon-192x192.png">
  </head>
  
  <body>
    <nav class="navbar fixed-top">
      <div class="navbar-logo">
        <a class="navbar-brand" href="/"><img class="logo-img" src="/assets/favicon-192x192.png"></a>
      </div>
      <div class="navbar-search-form">
        <form role="form" id="write-form">
        <div class="input-group" style="width:16em">
          <input class="form-control" type="text" name="measurement" value="weather">
          <select class="form-control" name="host">
            <option value="gb-pc" <? if ($host == "gb-pc") echo "selected"; ?>>gb-pc</option>
            <option value="iphone" <? if ($host == "iphone") echo "selected"; ?>>iphone</option>
            <option value="s3" <? if ($host == "s3") echo "selected"; ?>>s3</option>
          </select>
        </div>
        </form>
      </div>
    </nav>
