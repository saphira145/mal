<?php

	global $output, $path, $class, $status;

	/*----------------------------------------------------
	  テスト表示フラグ
	----------------------------------------------------*/

	// 表示モード取得
	$testFlg = get_dispModeFlg();
	if( $testFlg == 1 && !preg_match( "#/admin/#", $path["url"] ) ) {
		// ＤＢ名取得
		$DBName = get_DBName( "base" );
		// 日付取得
		$sql = "SELECT reserveDatetime FROM {$DBName}.tableAdmin";
		$tbl = sql_query( $sql, "single" );
		$output["testDatetime"] = db2val_datetimeType1( $tbl["reserveDatetime"] );
		$output["TEST_MODE_FLG"]  = 1;
	}




$output['HTTP_HOST'] = $_SERVER['HTTP_HOST'];




?>