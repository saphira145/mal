<?php
/* -------------------------------------
	管理者管理
	for NetGRID PHP Framework v2
	最終更新: 2009-02-06
------------------------------------- */


	class loginLog_1 {


	/*----------------------------------------------------
	    コンストラクタ
	----------------------------------------------------*/
		function loginLog_1 () {

		}

		/*----------------------------------------------------
		    ログインログ登録
		----------------------------------------------------*/
		function insert_loginLog ( $memberID ) {

			global $ini;

			// ＤＢ名取得
			$DBName = get_DBName( "base" );

			// SQLインジェクション対応
			$sql_escape["memberID"]      = sql_escapeString($memberID);

			// ログイン回数の更新
			$sql = "SELECT loginCount FROM {$DBName}.memberInfo WHERE memberID = '{$sql_escape["memberID"]}' ";
			$tbl = sql_query( $sql, "single" );
			$tbl["loginCount"] = sprintf ( "%d", $tbl["loginCount"] );

            // Remove LoginCount in 'Member Master' table
			//$update["loginCount"] = $tbl["loginCount"] + 1;
			//$sql = "UPDATE {$DBName}.memberInfo SET {update_set} WHERE memberID = '{$sql_escape["memberID"]}' ";
			//sql_query( $sql, $update );

			// ログイン履歴
			unset($tbl);
			$sql = "SELECT count(memberID) as counter FROM {$DBName}.loginLog WHERE memberID = '{$sql_escape["memberID"]}' ";
			$tbl = sql_query( $sql, "single" );
			$tbl["counter"] = sprintf ( "%d", $tbl["counter"] );

			// 履歴保持件数が上限の場合、一番古いデータを削除する
			if( $tbl["counter"] >= $ini["loginLog"]["historyCnt"] ){
				$sql  = "SELECT insertDatetime ";
				$sql .= "FROM {$DBName}.loginLog ";
				$sql .= "WHERE memberID = '{$sql_escape["memberID"]}' ";
				$sql .= "ORDER BY insertDatetime ";
				$sql .= "LIMIT 1 ";
				$ret  = sql_query( $sql, "single" );

				// SQLインジェクション対応
				$sql_escape["insertDatetime"] = sql_escapeString($ret["insertDatetime"]);

				// 一番古いデータを削除する
				$sql  = "DELETE FROM {$DBName}.loginLog ";
				$sql .= "WHERE memberID = '{$sql_escape["memberID"]}' ";
				$sql .= "AND insertDatetime = '{$sql_escape["insertDatetime"]}' ";
				sql_query( $sql );
			}

            // Add employee number to Log
            $employeeNumber = checkEmployeeNumber() ? checkEmployeeNumber() : null;
            if ( checkEmployeeNumber() ) {
                $employeeNumber = explode('-', base64_decode(checkEmployeeNumber()));
                $employeeNumber = $employeeNumber[1];
            }

			// 履歴登録
			$insert["memberID"]              = $memberID;
			$insert["insertDatetime"]["com"] = "now()";
			$sql = "INSERT INTO loginLog {insert_value}";
			sql_query( $sql, $insert );
		}


		/*----------------------------------------------------
		    ログリストの取得
		----------------------------------------------------*/
		function get_loginList( $input ) {

			global $ini;

			// ＤＢ名取得
			$DBName = get_DBName( "base" );

			// ログ区分の設定
			if( empty($input["searchType"]) ){
				$input["searchType"] = 1;
			} else {
				$input["searchType"] = intval($input["searchType"]);
			}

			// 区分によって条件を設定
			switch( $input["searchType"] ){
				case 1 :
					// 日別
					$dateLength["select"] = 10;
					$dateLength["where"]  = 7;
					$sqlWhereFlg          = 1;
					break;

				case 2 :
					// 月別
					$dateLength["select"] = 7;
					$dateLength["where"]  = 5;
					$sqlWhereFlg          = 1;
					unset($input["searchMonth"]);
					break;

				case 3 :
					// 年別
					$dateLength["select"] = 4;
					$dateLength["where"]  = 4;
					unset($input["searchYear"],$input["searchMonth"]);
					break;
			}

			// 年月
			if( !empty($input["searchYear"]) && !empty($input["searchMonth"]) ){
				// 年月
				$input["searchMonth"] = sprintf( "%02d", $input["searchMonth"] );
				$sql_where  = "WHERE tbl.whereLogDate = '{$input["searchYear"]}-{$input["searchMonth"]}' ";

			} else if( !empty($input["searchYear"]) && empty($input["searchMonth"]) ){
				// 年のみ
				$sql_where  = "WHERE tbl.whereLogDate like '{$input["searchYear"]}-%' ";
			}

			// ログインログ
			unset($tmp_sql);
			$tmp_sql     = "SELECT lg.insertDatetime ";
			$tmp_sql    .= "      , substring( lg.insertDatetime, 1, {$dateLength["select"]} ) AS logDate ";
			$tmp_sql    .= "      , substring( lg.insertDatetime, 1, {$dateLength["where"]} ) AS whereLogDate ";
            switch( $input["searchLogType"] ){
                case 1 :
                    $tmp_sql .= "      , COUNT( DISTINCT (CASE WHEN lg.employeeNumber IS NOT NULL THEN lg.employeeNumber ELSE lg.memberID END) ) userCount ";
                    break;
                case 2 :
                    $tmp_sql .= "      , COUNT( DISTINCT lg.employeeNumber ) userCount ";
                    break;
                case 3 :
                    $tmp_sql .= "      , COUNT( DISTINCT lg.memberID ) userCount ";
                    break;
            }
			$tmp_sql    .= "      , true AS loginLog ";
			$tmp_sql    .= "FROM {$DBName}.loginLog lg ";
			// ログインログ
			switch( $input["searchLogType"] ){
				case 1 :
					break;
				case 2 :
					$tmp_sql .= "WHERE lg.employeeNumber IS NOT NULL AND lg.memberID = 0 ";
					break;
				case 3 :
					$tmp_sql .= "WHERE lg.employeeNumber IS NULL AND lg.memberID <> 0 ";
					break;
			}
			$tmp_sql    .= "GROUP BY substring( lg.insertDatetime, 1, 10 ) ";
			$sql_list[]  = $tmp_sql;

			// 過去のログ
			unset($tmp_sql);
			$tmp_sql     = "SELECT ls2.insertDatetime ";
			$tmp_sql    .= "      , substring(ls2.insertDatetime, 1, {$dateLength["select"]}) as logDate ";
			$tmp_sql    .= "      , substring(ls2.insertDatetime, 1, {$dateLength["where"]}) as whereLogDate ";
			switch( $input["searchLogType"] ){
				case 1 :
					$tmp_sql .= "      , ls2.userCount ";
					break;
				case 2 :
					$tmp_sql .= "      , 0 AS userCount ";
					break;
				case 3 :
					$tmp_sql .= "      , 0 AS userCount ";
					break;
			}
			$tmp_sql    .="      , false AS loginLog ";
			$tmp_sql    .= "FROM {$DBName}.loginLogSummary as ls1, {$DBName}.loginLogSummary as ls2 ";
			$tmp_sql    .= "WHERE ls1.insertDatetime = ls2.insertDatetime ";
			$sql_list[]  = $tmp_sql;

            // 今日
            unset($tmp_sql);
            $today = date("Y-m-d", strtotime("now"));
            $tmp_sql     = "SELECT NOW() insertDatetime ";
            $tmp_sql    .= "      , substring('{$today}', 1, {$dateLength["select"]}) as logDate ";
            $tmp_sql    .= "      , substring('{$today}', 1, {$dateLength["where"]}) as whereLogDate ";
            $tmp_sql    .= "      , 0 AS userCount ";
            $tmp_sql    .="       , false AS loginLog ";
            $sql_list[]  = $tmp_sql;


			// 件数の取得
			$sql   = "SELECT substring(logDate, 1, {$dateLength["where"]}) as logDate ";
			$sql  .= "FROM ( ";
			$sql  .= "" . @implode( " UNION ", $sql_list );
			$sql  .= ") as tbl ";
			$sql  .= "{$sql_where} ";
			$sql  .= "GROUP BY substring(logDate, 1, {$dateLength["where"]})";
			$sql  .= "ORDER BY logDate DESC ";
			$page  = sql_query( $sql );

			if( $sqlWhereFlg ){
				// ページ情報の取得
				$pageInfo = adjust_pageState( count($page), 1, $input["pageNum"] );

				// ページ番号から日付を取得する
				if( $pageInfo["totalPageCount"] < $input["pageNum"] ){
					$data["pageNum"] = intval($pageInfo["totalPageCount"]) - 1;
				} else {
					$data["pageNum"] = intval($pageInfo["pageNum"]) - 1;
				}

				// データを取得
				$sql_where  = "WHERE tbl.whereLogDate = '{$page[$data["pageNum"]]["logDate"]}' ";

				// 前後年月(年)の名称を取得
				$pageInfo["pageName"] = db2val_date($page[$data["pageNum"]]["logDate"]);
				if( isset($pageInfo["nextPage"]) ){
					$pageInfo["nextPageName"] = db2val_date($page[$pageInfo["nextPage"]-1]["logDate"]);
				}

				if( isset($pageInfo["prevPage"]) ){
					$pageInfo["prevPageName"] = db2val_date($page[$pageInfo["prevPage"]-1]["logDate"]);
				}
			}

			$sql   = "SELECT tbl.* ";
			$sql  .= "FROM ( ";
			$sql  .= "" . @implode( " UNION ", $sql_list );
			$sql  .= ") as tbl ";
			$sql  .= "{$sql_where} ";
			$sql  .= "ORDER BY tbl.logDate DESC ";
			$list  = sql_query( $sql );


			// データ取得
			$tmp_list = array();
			for( $i = 0, $iMax = count($list); $i < $iMax; $i++){
				$logDate = $list[$i]["logDate"];
                $keyDate = date("Y-m-d", strtotime($list[$i]["insertDatetime"]));
				if(array_key_exists($logDate, $tmp_list)) {
                    if(array_key_exists($keyDate, $tmp_list[$logDate])){
                        if($tmp_list[$logDate][$keyDate]["loginLog"]){
                            if(!$list[$i]["loginLog"]) continue;
                        } elseif ($list[$i]["loginLog"]) {
                            $tmp_list[$logDate][$keyDate]["cnt"] = array();
                        }
                    }
                    $tmp_list[$logDate][$keyDate]["cnt"][] = intval($list[$i]["userCount"]);
                    $tmp_list[$logDate][$keyDate]["loginLog"] = $list[$i]["loginLog"];
                }else{
                    $tmp_list[$logDate][$keyDate]["cnt"][] = intval($list[$i]["userCount"]);
                    $tmp_list[$logDate][$keyDate]["loginLog"] = $list[$i]["loginLog"];
                }
			}

			// 人数の合計
			if( count($tmp_list) > 0 ){
				foreach( $tmp_list as $key => $val){
					$dateArr       = db2val_date($key);
                    $cnt = array();
                    $loginLog = false;
                    foreach($val as $dateItem){
                        $cnt[] = array_sum($dateItem["cnt"]);
                        $loginLog = $loginLog || $dateItem["loginLog"];
                    }
					$ret["list"][] = array( "date" => $dateArr , "cnt"=> array_sum($cnt), 'loginLog' =>  $loginLog );
					$total[]       = array_sum($val);
				}

				// 合計
				$ret["total"] = array_sum($total);
			}

			return array( $ret, $pageInfo );
		}

        // Register log in special-IP case
        function insert_loginLog_by_employeeNumber ( $employeeNumber ) {

            // 履歴登録
            $insert["employeeNumber"]        = $employeeNumber;
            $insert["insertDatetime"]["com"] = "now()";
            $sql = "INSERT INTO loginLog {insert_value}";
            sql_query( $sql, $insert );
        }
		/*----------------------------------------------------
			   ファイル名取得
		----------------------------------------------------*/
		function get_fileName ( $input ) {
			$formDate = date("Ymd", strtotime ('-3 month', strtotime("first day of this month")));
			$toDate = date("Ymd");
			$searchLogType = ($input["searchLogType"] == 1) ? "全て" : (($input["searchLogType"] == 2) ? "自動ログイン" : "手動ログイン");
			
			// 名前作成
			$ret = "{$formDate}～{$toDate}ログインログ_{$searchLogType}.csv";

			return $ret;
		}



		/*----------------------------------------------------
			   文字コード変換（配列対応）
		----------------------------------------------------*/
		function mbConvertEncodingDeep ( $value, $encFrom, $encTo ) {

			if ( is_array( $value ) ) {
				foreach( $value as $key => $val ) {
					$value[$key] = $this->mbConvertEncodingDeep( $val, $encFrom, $encTo );
				}
			} else{
				$value = mb_convert_encoding( $value, $encTo, $encFrom );
			}

			return $value;
		}

		/*----------------------------------------------------
		    一時アーカイブファイルの削除
		----------------------------------------------------*/
		function delete_tmpCSVFile () {

			global $ini, $path;

			// テンプディレクトリパスの取得
			$temp_path = $path["csv"]["tmpDir"];

			// 削除対象の日付取得
			$y  = date( "Y" );
			$m  = date( "m" );
			$d  = date( "d" );
			$h  = date( "H" );
			$i  = date( "i" );
			$s  = date( "s" );

			$from_date  = date( "Y-m-d H:i:s", mktime( $h, $i, $s, $m, $d - $ini["tempCSV"]["deleteDayUnit"], $y ) );

			$process_date = date( "Y-m-d H:i:s" );

			foreach( glob("$temp_path/*") as $file_path ) {
				$file_date = date('Y-m-d H:i:s', filemtime( $file_path ) );
				if( $file_date < $from_date ) {
					@unlink ( $file_path );
				}
			}
		}

        function get_loginLogDetailList( $input ){
            $sql = "";
            switch ($input["searchLogType"]) {
                case 1 :
                    $sql = "SELECT tbl.* ";
                    $sql .= "FROM ( ";
                    $sql .= "    SELECT insertDatetime ";
                    $sql .= "      , count(logID) logCount ";
                    $sql .= "      , employeeNumber ";
                    $sql .= "      , '' AS loginID ";
                    $sql .= "      , '' AS memberName ";
                    $sql .= "      , '' AS companyName ";
                    $sql .= "   FROM loginLog ";
                    $sql .= "   WHERE employeeNumber IS NOT NULL AND memberID = 0 ";
                    $sql .= "   GROUP BY substring(insertDatetime, 1, 10), employeeNumber ";
                    $sql .= "   UNION ";
                    $sql .= "    SELECT log.insertDatetime ";
                    $sql .= "      , count(log.logID) logCount ";
                    $sql .= "      , '' AS employeeNumber ";
                    $sql .= "      , sess.loginID ";
                    $sql .= "      , mem.memberName ";
                    $sql .= "      , mem.companyName ";
                    $sql .= "   FROM loginLog log ";
                    $sql .= "   LEFT JOIN memberInfo mem ";
                    $sql .= "      ON mem.memberID = log.memberID ";
                    $sql .= "   LEFT JOIN sessionMember sess ";
                    $sql .= "      ON sess.memberID = log.memberID ";
                    $sql .= "   WHERE log.employeeNumber IS NULL AND log.memberID <> 0 ";
                    $sql .= "   GROUP BY substring(log.insertDatetime, 1, 10), log.memberID ";
                    $sql .= ") AS tbl ";
                    $sql .= "ORDER BY tbl.insertDatetime DESC ";
                    break;
                case 2 :
                    $sql = "SELECT insertDatetime ";
                    $sql .= "   , count(logID) logCount ";
                    $sql .= "   , employeeNumber ";
                    $sql .= "FROM loginLog ";
                    $sql .= "WHERE employeeNumber IS NOT NULL AND memberID = 0 ";
                    $sql .= "GROUP BY substring(insertDatetime, 1, 10), employeeNumber ";
                    $sql .= "ORDER BY insertDatetime DESC ";
                    break;
                case 3 :
                    $sql = "SELECT log.insertDatetime ";
                    $sql .= "   , count(log.logID) logCount ";
                    $sql .= "   , sess.loginID ";
                    $sql .= "   , mem.memberName ";
                    $sql .= "   , mem.companyName ";
                    $sql .= "FROM loginLog log ";
                    $sql .= "LEFT JOIN memberInfo mem ";
                    $sql .= "   ON mem.memberID = log.memberID ";
                    $sql .= "LEFT JOIN sessionMember sess ";
                    $sql .= "   ON sess.memberID = log.memberID ";
                    $sql .= "WHERE log.employeeNumber IS NULL AND log.memberID <> 0 ";
                    $sql .= "GROUP BY substring(log.insertDatetime, 1, 10), log.memberID ";
                    $sql .= "ORDER BY log.insertDatetime DESC ";
                    break;
            }
            return sql_query( $sql );
        }

        function get_loginLogListForDetail( $input ){
            $sql = "";
            $dates = @explode("-", $input["date"]);
            // month
            if(isset($dates[1]) && !empty($dates[1])) $dates[1] = sprintf( "%02d", $dates[1] );
            // day
            if(isset($dates[2]) && !empty($dates[2])) $dates[2] = sprintf( "%02d", $dates[2] );
            $date = @implode("-", $dates);

            switch ($input["searchLogType"]) {
                case 1 :
                    $sql = "SELECT tbl.* ";
                    $sql .= "FROM ( ";
                    $sql .= "    SELECT insertDatetime ";
                    $sql .= "      , count(logID) logCount ";
                    $sql .= "      , employeeNumber ";
                    $sql .= "      , '' AS loginID ";
                    $sql .= "      , '' AS memberName ";
                    $sql .= "      , '' AS companyName ";
                    $sql .= "   FROM loginLog ";
                    $sql .= "   WHERE employeeNumber IS NOT NULL AND memberID = 0 ";
                    $sql .= "       AND insertDatetime LIKE '{$date}%' ";
                    $sql .= "   GROUP BY substring(insertDatetime, 1, 10), employeeNumber ";
                    $sql .= "   UNION ";
                    $sql .= "    SELECT log.insertDatetime ";
                    $sql .= "      , count(log.logID) logCount ";
                    $sql .= "      , '' AS employeeNumber ";
                    $sql .= "      , sess.loginID ";
                    $sql .= "      , mem.memberName ";
                    $sql .= "      , mem.companyName ";
                    $sql .= "   FROM loginLog log ";
                    $sql .= "   LEFT JOIN memberInfo mem ";
                    $sql .= "      ON mem.memberID = log.memberID ";
                    $sql .= "   LEFT JOIN sessionMember sess ";
                    $sql .= "      ON sess.memberID = log.memberID ";
                    $sql .= "   WHERE log.employeeNumber IS NULL AND log.memberID <> 0 ";
                    $sql .= "       AND log.insertDatetime LIKE '{$date}%' ";
                    $sql .= "   GROUP BY substring(log.insertDatetime, 1, 10), log.memberID ";
                    $sql .= ") AS tbl ";
                    $sql .= "ORDER BY tbl.insertDatetime DESC ";
                    break;
                case 2 :
                    $sql = "SELECT insertDatetime ";
                    $sql .= "   , count(logID) logCount ";
                    $sql .= "   , employeeNumber ";
                    $sql .= "FROM loginLog ";
                    $sql .= "WHERE employeeNumber IS NOT NULL AND memberID = 0 ";
                    $sql .= "   AND insertDatetime LIKE '{$date}%' ";
                    $sql .= "GROUP BY substring(insertDatetime, 1, 10), employeeNumber ";
                    $sql .= "ORDER BY insertDatetime DESC ";
                    break;
                case 3 :
                    $sql = "SELECT log.insertDatetime ";
                    $sql .= "   , count(log.logID) logCount ";
                    $sql .= "   , sess.loginID ";
                    $sql .= "   , mem.memberName ";
                    $sql .= "   , mem.companyName ";
                    $sql .= "FROM loginLog log ";
                    $sql .= "LEFT JOIN memberInfo mem ";
                    $sql .= "   ON mem.memberID = log.memberID ";
                    $sql .= "LEFT JOIN sessionMember sess ";
                    $sql .= "   ON sess.memberID = log.memberID ";
                    $sql .= "WHERE log.employeeNumber IS NULL AND log.memberID <> 0 ";
                    $sql .= "   AND log.insertDatetime LIKE '{$date}%' ";
                    $sql .= "GROUP BY substring(log.insertDatetime, 1, 10), log.memberID ";
                    $sql .= "ORDER BY log.insertDatetime DESC ";
                    break;
            }

            $list = sql_query($sql);
            $ret = array();
            if(count($list) == 0) return $ret;
            foreach($list as $val){
                $dateArr = db2val_date(date("Y-m-d", strtotime($val["insertDatetime"])));
                $nameArr = db2val_name(isset($val["memberName"]) ? $val["memberName"] : '');
                $ret[] = array(
                    "date" => $dateArr,
                    "logCount" => $val["logCount"],
                    "employeeNumber" => isset($val["employeeNumber"]) ? $val["employeeNumber"] : '',
                    "loginID" => isset($val["loginID"]) ? $val["loginID"] : '',
                    "memberName" => $nameArr,
                    "companyName" => isset($val["companyName"]) ? $val["companyName"] : '',
                );
            }
            return $ret;
        }
	}
?>
