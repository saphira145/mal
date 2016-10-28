<?php

$path["logic"] = dirname($_SERVER["SCRIPT_FILENAME"]) . "/../../logic/";
$path["log"]   = dirname($_SERVER["SCRIPT_FILENAME"]) . "/../../log/";

/*----------------------------------------------------
   ログ出力
----------------------------------------------------*/
function output_logData( $input ){

	global $path;

	//logファイルの保存先
	$filePath = $path["log"] . "loginLogSummary_" . date('Ymd') . ".log";

	// ログの出力
	$fp   = fopen( $filePath, "a" );
	$txts = "[" . date('Y-m-d H:i:s') . "] " . $input ;
	fputs( $fp, $txts . "\r\n" );
	fclose( $fp );

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


// DB登録 ----------------------------------------------------------------------
if( !$con["db"] = mysql_connect( $ini["db"]["host"], $ini["db"]["user"], $ini["db"]["pass"] ) ) {
	output_logData("database connection failure.");
	exit;
}
mysql_set_charset( "utf8" );
$yesterday = date("Y-m-d", strtotime("-1 day"));
$dbBase = $ini["db"]["dbBase"];

//本日のログイン人数を取得
$sql     = "SELECT COUNT( DISTINCT ( CASE WHEN employeeNumber IS NOT NULL THEN employeeNumber ELSE memberID END ) ) as userCount ";
$sql    .= "FROM {$dbBase}.loginLog ";
$sql    .= "WHERE insertDatetime like '{$yesterday}%' ";
$result  = @mysql_query( $sql );
$mnr     = @mysql_num_rows( $result );
if ( $mnr == 0 ){
	
}else {
	while( $row = @mysql_fetch_array( $result, MYSQL_ASSOC ) ) {
		$loginLog[] = $row;
	}
}
@mysql_free_result( $result );
output_logData("Get " . count($loginLog) . " data from {$dbBase}.loginLog.");

for( $i = 0; $i < count($loginLog); $i++){
	//サマリーに登録
	$insert["insertDatetime"] = date("Y-m-d", strtotime('-1 day'));
	$insert["userCount"]      = mysql_real_escape_string( stripslashes($loginLog[$i]["userCount"]) );
	$sql     = "INSERT INTO {$dbBase}.loginLogSummary ( insertDatetime, userCount ) ";
	$sql    .= "VALUES ('{$insert["insertDatetime"]}', '{$insert["userCount"]}') ";
	$result  = @mysql_query( $sql );
	output_logData("Register the data of {$insert["insertDatetime"]} to {$dbBase}.loginLogSummary.");
	output_logData("The number of users is {$insert["userCount"]} people.");

	// ログの削除
	// $sql    = "UPDATE mal_compareBase_vn.memberInfo SET loginCount = '0' ";
	// $result = @mysql_query( $sql );
	// output_logData("Initialize the number of logins of mal_compareBase_vn.memberInfo.");
}

// Clear loginLog after than 3 months
output_logData("Removing the loginLog expire date!");
$expireDate = date("Y-m-d 00:00:00", strtotime ('-3 month', strtotime("first day of this month")));
$sql     = "DELETE FROM {$dbBase}.loginLog WHERE insertDatetime < '{$expireDate}' ";
$result  = @mysql_query( $sql );
$rowsDeleted = mysql_affected_rows();
output_logData("There are {$rowsDeleted} rows to be deleted!");

?>
