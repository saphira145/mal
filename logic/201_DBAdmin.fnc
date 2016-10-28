<?php



	/*----------------------------------------------------
	  ＤＢ名取得
	  引数：
	     1      => mal_compare_1
	     2      => mal_compare_2
	     work   => mal_compareWork
	     base   => mal_compareBase
	     active => mal_compare_1 OR mal_compare_2

	  返値：
	     ＤＢ名
	----------------------------------------------------*/
	function get_DBName ( $param ) {

		global $path;

		// 表示モード取得
		$testFlg = get_dispModeFlg();
		if( $param == "active"
		 && $testFlg == 1
		 && !preg_match( "#/admin/#", $path["url"] ) ) {
			$param = "work";
		}

		switch( $param ) {
			case "1"     : $DBName = "mal_compare_1";        break;
			case "2"     : $DBName = "mal_compare_2";        break;
			case "work"  : $DBName = "mal_compareWork";      break;
			case "base"  : $DBName = "mal_compareBase";      break;
			case "active": $DBName = "mal_compare_" . get_activeDBNum(); break;
		}

		return $DBName;
	}



	/*----------------------------------------------------
	  表示モード取得
	----------------------------------------------------*/
	function get_dispModeFlg () {

		if( $_COOKIE["testDispMode"] == "ON" ) {
			return 1;
		}
		else{
			return NULL;
		}

	}



	/*----------------------------------------------------
	  アクティブＤＢ番号取得
	----------------------------------------------------*/
	function get_activeDBNum () {

		// ＤＢ名取得
		$DBName = get_DBName( "base" );

		$sql = "SELECT activeDBSW FROM {$DBName}.DBAdmin";
		$ret = sql_query( $sql, "single" );

		return $ret["activeDBSW"];
	}



	/*----------------------------------------------------
	  アクティブＰＨＯＴＯディレクトリ
	----------------------------------------------------*/
	function get_activeDirName () {

		// 表示モード取得
		$testFlg = get_dispModeFlg();

		if( $testFlg == 1
		 && !preg_match( "#/admin/#", $path["url"] ) ) {
			// テスト表示
			$ret = "WORK";
		}
		else{
			// 通常表示
			$ret = "DB" . get_activeDBNum();
		}

		return $ret;
	}



	/*----------------------------------------------------
	  ＤＢのロックフラグ取得（ 0:オフ 1:オン ）
	----------------------------------------------------*/
	function get_DBLockFlg ( $fieldName ) {

		// ＤＢ名取得
		$DBName = get_DBName( "base" );

		$sql = "SELECT {$fieldName} FROM {$DBName}.DBAdmin";
		$tbl = sql_query( $sql, "single" );

		return $tbl["$fieldName"];

	}



	/*----------------------------------------------------
	  ワークＤＢのロックフラグ変更（ 0:オフ 1:オン ）
	----------------------------------------------------*/
	function change_workDBLockFlg ( $flg ) {

		// ＤＢ名取得
		$DBName = get_DBName( "base" );

		$sql = "SELECT * FROM {$DBName}.DBAdmin";
		$tbl = (array)sql_query( $sql );

		$DBdata["workDBLockFlg"]  = $flg;

		if( count( $tbl ) > 0 ){
			$sql = "UPDATE {$DBName}.DBAdmin SET {update_set}";
		}
		else{
			$sql = "INSERT INTO {$DBName}.DBAdmin {insert_value}";
		}

		sql_query( $sql, $DBdata );

	}



	/*----------------------------------------------------
	  テストＤＢのロックフラグ変更（ 0:オフ 1:オン ）
	----------------------------------------------------*/
	function change_testDBLockFlg ( $flg ) {

		// ＤＢ名取得
		$DBName = get_DBName( "base" );

		$sql = "SELECT * FROM {$DBName}.DBAdmin";
		$tbl = (array)sql_query( $sql );

		$DBdata["testDBLockFlg"]  = $flg;

		if( count( $tbl ) > 0 ){
			$sql = "UPDATE {$DBName}.DBAdmin SET {update_set}";
		}
		else{
			$sql = "INSERT INTO {$DBName}.DBAdmin {insert_value};";
		}

		sql_query( $sql, $DBdata );

	}



	/*----------------------------------------------------
	  ロールバックＤＢのロックフラグ変更（ 0:オフ 1:オン ）
	----------------------------------------------------*/
	function change_rollBackDBLockFlg ( $flg ) {

		// ＤＢ名取得
		$DBName = get_DBName( "base" );

		$sql = "SELECT * FROM {$DBName}.DBAdmin";
		$tbl = (array)sql_query( $sql );

		$DBdata["rollbackFlg"]  = $flg;

		if( count( $tbl ) > 0 ){
			$sql = "UPDATE {$DBName}.DBAdmin SET {update_set}";
		}
		else{
			$sql = "INSERT INTO {$DBName}.DBAdmin {insert_value};";
		}

		sql_query( $sql, $DBdata );

	}



	/*----------------------------------------------------
	  アクティブスイッチの変更（ 1:compare_1 2:compare_2 ）
	----------------------------------------------------*/
	function change_activeDB ( $num ) {

		// ＤＢ名取得
		$DBName = get_DBName( "base" );

		$sql = "SELECT * FROM {$DBName}.DBAdmin";
		$tbl = (array)sql_query( $sql );

		$DBdata["activeDBSW"]  = $num;

		if( count( $tbl ) > 0 ){
			$sql = "UPDATE {$DBName}.DBAdmin SET {update_set}";
		}
		else{
			$sql = "INSERT INTO {$DBName}.DBAdmin {insert_value};";
		}

		sql_query( $sql, $DBdata );

	}









?>
