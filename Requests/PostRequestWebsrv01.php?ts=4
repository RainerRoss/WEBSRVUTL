<?php
function runTime($time_start) {
	$time_end = microtime(true);
	$runtime = $time_end - $time_start;
	$number_format_german = number_format($runtime, 3, ',', '.');
	echo 'Runtime: '.$number_format_german.' sec '.'<br><br>';
}
function do_post_request($url, $params, $header) {
	if (!function_exists('curl_init')){
		die('Sorry cURL is not installed!');
	}
	$ch = curl_init();
	curl_setopt($ch, CURLOPT_URL, $url);
	curl_setopt($ch, CURLOPT_HTTPHEADER, array($header));
	curl_setopt($ch, CURLOPT_POST, true);
	curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($params, null, '&'));
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch, CURLOPT_HEADER, false);
	curl_setopt($ch, CURLOPT_TIMEOUT, 10);
	$server_output = curl_exec ($ch);
	curl_close ($ch);
	return $server_output;
}

$time_start = microtime(true);
$url = 'http://www.myhofi.com/myapp/websrv01.pgm';
$params = [
	'id' => 1
];

$response = do_post_request($url, $params, 'Content-type: application/x-www-form-urlencoded\r\n');
runTime($time_start);

echo $response;
$obj = json_decode($response, true);
echo "<pre>";
print_r($obj);
echo 'success: '.$obj["success"].'<br>';
echo 'name: '.$obj["items"][0]["name"].'<br>';
?>
