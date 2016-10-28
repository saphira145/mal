<?php

/**
  リリース設定中フラグを取得
  リリース日が設定されていて15分以内の場合、管理側にメッセージを表示する。
  ※管理側のみ
 */
	
	if( !empty($output["MEMBER"]) && preg_match( "#/admin#", $path["url"] ) ){
		global $ini;

		// ＤＢ名取得
		$DBName = get_DBName( "base" );

		$fromDatetime = date( "Y-m-d H:i:s" );
		$toDatetime   = date( "Y-m-d H:i:s", mktime( date( "H"), date( "i") + $ini["reserveSet"]["limit"], date( "s"), date( "m"), date( "d"), date( "Y") ) );

		// リリース予定日取得
		$sql = "SELECT reserveDatetime FROM $DBName.tableAdmin WHERE reserveDatetime >= '$fromDatetime' AND reserveDatetime <= '$toDatetime' AND reserveDatetime != '0000-00-00 00:00:00'";
		$tbl = (array)sql_query( $sql , "single" );

		if( count( $tbl ) > 0 ) {
			$output["RELEASE"]["limit"] = $ini["reserveSet"]["limit"];
		}
		
	}
?>
