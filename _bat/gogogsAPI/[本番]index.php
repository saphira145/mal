<?php

$path["logic"] = dirname($_SERVER["SCRIPT_FILENAME"]) . "/../../logic/";
$path["log"]   = dirname($_SERVER["SCRIPT_FILENAME"]) . "/../../log/";

/*----------------------------------------------------
   ログ出力
----------------------------------------------------*/
function output_logData( $input ){
	global $path;

	//logファイルの保存先
	$filePath = $path["log"] . "gogogsAPI_" . date('Ymd') . ".log";

	// ログの出力
	$fp   = fopen( $filePath, "a" );
	$txts = "[" . date('Y-m-d H:i:s') . "] " . $input ;
	fputs( $fp, $txts . "\r\n" );
	fclose( $fp );
}



// 都道府県ファイルの読み込み --------------------------------------------------
$fileName = $path["logic"] . "140_prefecture.ini";
$prefectureList = file( $fileName );

for($i = 3; $i < count( $prefectureList ); $i++){
	if( substr(trim($prefectureList[$i]), 0, 2) !== "//" ){
		if( preg_match('/prefecture/', $prefectureList[$i])  ){
			$column                 = explode("=", trim($prefectureList[$i]));
			list($name, $num, $key) = explode(".", trim($column[0]));
			$val                    = str_replace('"', "", trim($column[1]));

			$prefecture[$num][$key] = str_replace('"', "", trim($val));
		} else if(preg_match('/sampleCountMin/', $prefectureList[$i])){
			$column                 = explode("=", trim($prefectureList[$i]));
			$val                    = str_replace('"', "", trim($column[1]));
			$sampleCountMin         = $val;
		}
	}
}
// DBファイルの読み込み --------------------------------------------------------
$fileName = $path["logic"] . "110_database.ini";
$dbList = file( $fileName );

for($i = 3; $i < count( $dbList ); $i++){
	if( substr(trim($dbList[$i]), 0, 2) !== "//" ){
		$column          = explode("=", trim($dbList[$i]));
		list($num, $key) = explode(".", trim($column[0]));
		$val             = substr($column[1], 0,strpos($column[1], "//"));

		$ini["db"][$key] = str_replace('"', "", trim($val));
	}
}



// APIから取得 -----------------------------------------------------------------
$apiUrl   = "http://openapi.gogo.gs/v1/average/pref.json?apid=marche&apikey=jMPviLHWneZy"; // json
$jsondata = file_get_contents($apiUrl);

// JSONをパース
$gsdata = json_decode($jsondata, true);

if($gsdata["Status"] != "OK"){
	// データ取得失敗
	output_logData("data acquisition failure.");
	exit;
}
output_logData("{$gsdata["Status"]} [{$gsdata["Condition"]["StartTime"]}]-[{$gsdata["Condition"]["EndTime"]}]");

// データ取得と平均算出
foreach ($gsdata["Result"] as $resultKey => $resultVal) {
	unset($average);

	foreach ($resultVal as $key => $val) {
		if( $val["SampleCount"] >= 10 ){
			$tmp_gasolineList[$resultKey][$val["Prefecture"]] = $val["AveragePrice"];
		}

		$average["price"] += $val["AveragePrice"];
		$average["count"] += 1;
	}
	$tmp_gasolineList[$resultKey][0] = floor($average['price'] / $average['count'] * 10) / 10;
}

// 都道府県ごとにデータ作成
for( $i=0; $i<count($prefecture); $i++){

	// データが無ければ、0を設定
	if( !isset($tmp_gasolineList["RegularGasoline"][$i]) ){
		$tmp_gasolineList["RegularGasoline"][$i] = 0;	//レギュラー
	}
	if( !isset($tmp_gasolineList["HighOctaneGasoline"][$i]) ){
		$tmp_gasolineList["HighOctaneGasoline"][$i] = 0;	//ハイオク
	}
	if( !isset($tmp_gasolineList["LightOilGasolin"][$i]) ){
		$tmp_gasolineList["LightOilGasolin"][$i] = 0;	//軽油
	}

	$gasolineList[$i]["regionID"]           = $prefecture[$i]["id"];
	$gasolineList[$i]["regularGasoline"]    = $tmp_gasolineList["RegularGasoline"][$i];
	$gasolineList[$i]["highOctaneGasoline"] = $tmp_gasolineList["HighOctaneGasoline"][$i];
	$gasolineList[$i]["dieselGasoline"]     = $tmp_gasolineList["LightOilGasolin"][$i];
}

// DB登録 ----------------------------------------------------------------------
if( !$con["db"] = mysql_connect( $ini["db"]["host"], $ini["db"]["user"], $ini["db"]["pass"] ) ) {
	output_logData("database connection failure.");
	exit;
}
mysql_set_charset( "utf8" );

// データ削除
$sql    = "DELETE from mal_compareBase.gasoline ";
$result = @mysql_query( $sql );
output_logData("gasoline initialized on mal_compareBase.gasoline");

// データ登録
for( $i=0; $i<count($gasolineList); $i++){
	unset($insert, $tmp_insertColumns, $tmp_insertValues);

	$insert["regionID"]           = mysql_real_escape_string( stripslashes($gasolineList[$i]["regionID"]) );
	$insert["regularGasoline"]    = mysql_real_escape_string( stripslashes($gasolineList[$i]["regularGasoline"]) );
	$insert["highOctaneGasoline"] = mysql_real_escape_string( stripslashes($gasolineList[$i]["highOctaneGasoline"]) );
	$insert["dieselGasoline"]     = mysql_real_escape_string( stripslashes($gasolineList[$i]["dieselGasoline"]) );

	$sql    = "INSERT INTO mal_compareBase.gasoline ( regionID, regularGasoline, highOctaneGasoline, dieselGasoline ) ";
	$sql   .= "VALUES ('{$insert["regionID"]}', '{$insert["regularGasoline"]}', '{$insert["highOctaneGasoline"]}', '{$insert["dieselGasoline"]}') ";
	$result = @mysql_query( $sql );
	output_logData("regionID {$insert["regionID"]} renewed mal_compareBase.gasoline");
}


// 更新日時の更新
$update["workDatetime"] =  mysql_real_escape_string( stripslashes($gsdata["Condition"]["EndTime"]) );
$sql    = "UPDATE mal_compareBase.tableAdmin SET workDatetime = '{$update["workDatetime"]}' WHERE tableID = 'gasoline' ";
$result = @mysql_query( $sql );
output_logData("gasoline renewed mal_compareBase.tableAdmin");

?>
