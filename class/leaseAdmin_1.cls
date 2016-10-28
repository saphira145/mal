<?php
	class leaseAdmin_1 {

		/*----------------------------------------------------
		    コンストラクタ
		----------------------------------------------------*/
		function leaseAdmin_1 () {

		}


		/*----------------------------------------------------
		  金利の取得
		----------------------------------------------------*/
		function get_interestRatesList(  ){
			
			// ＤＢ名取得
			$DBName = get_DBName("base");

			$sql  = "SELECT * ";
			$sql .= "FROM {$DBName}.interestRates ";
			$sql .= "ORDER BY ratesID, payNumID";
			$tbl  = sql_query( $sql );

			for( $i = 0, $iMax = count($tbl); $i < $iMax; $i++ ){
				$tmp_ratesID  = $tbl[$i]["ratesID"];
				$tmp_payNumID = $tbl[$i]["payNumID"];
				$tmp_ret[$tmp_ratesID][$tmp_payNumID] = $tbl[$i];
			}

			for( $i = 0, $iMax = count($tmp_ret); $i < $iMax; $i++ ){
				$ret[$i]["ratesID"]    = $i;
				$cnt = 0;

				for( $j = 0, $jMax = count($tmp_ret[$i]); $j < $jMax; $j++ ){
					$ret[$i]["rates"][$cnt]["payNumID"] = $tmp_ret[$i][$j]["payNumID"];
					$ret[$i]["rates"][$cnt]["ratesIn"]  = $tmp_ret[$i][$j]["ratesIn"];
					$ret[$i]["rates"][$cnt]["ratesOut"] = $tmp_ret[$i][$j]["ratesOut"];
					$cnt++;
				}
			}


			return $ret;
		}


		/*----------------------------------------------------
		  更新日時の取得(金利)
		----------------------------------------------------*/
		function get_interestRatesDatetime( ){
			
			// ＤＢ名取得
			$DBName = get_DBName("base");

			$sql  = "SELECT max(updateDatetime) AS updateDatetime ";
			$sql .= "FROM {$DBName}.interestRates ";
			$ret  = sql_query( $sql, "single" );

			// 日付変換
			$ret["updateDatetime"]    = db2val_datetimeType1( $ret["updateDatetime"] );

			return $ret;
		}


		/*----------------------------------------------------
		  金利の更新
		----------------------------------------------------*/
		function update_interestRates( $input ){

			// ＤＢ名取得
			$DBName = get_DBName("base");

			// 登録用にデータを整形
			$cnt = 0;
			for( $i = 0, $iMax = count($input); $i < $iMax; $i++ ){

				for( $j = 0, $jMax = count($input[$i]["rates"]); $j < $jMax; $j++ ){
					$tmp_input[$cnt]["ratesID"]  = $input[$i]["ratesID"];
					$tmp_input[$cnt]["payNumID"] = $input[$i]["rates"][$j]["payNumID"];
					$tmp_input[$cnt]["ratesIn"]  = $input[$i]["rates"][$j]["ratesIn"];
					$tmp_input[$cnt]["ratesOut"] = $input[$i]["rates"][$j]["ratesOut"];
					$cnt++;
				}
			}

			for( $i = 0, $iMax = count($tmp_input); $i < $iMax; $i++ ){
				$update["ratesIn"]               = $tmp_input[$i]["ratesIn"];
				$update["ratesOut"]              = $tmp_input[$i]["ratesOut"];
				$update["updateDatetime"]["com"] = "now()";

				// SQLインジェクション対応
				$sql_escape["ratesID"]  = sql_escapeString($tmp_input[$i]["ratesID"]);
				$sql_escape["payNumID"] = sql_escapeString($tmp_input[$i]["payNumID"]);

				$sql = "UPDATE {$DBName}.interestRates SET {update_set} WHERE ratesID = '{$sql_escape["ratesID"]}' AND payNumID = '{$sql_escape["payNumID"]}' ";
				sql_query( $sql, $update, "1" );
			}

			return $ret;
		}


		/*----------------------------------------------------
		  メンテナンス料の取得
		----------------------------------------------------*/
		function get_maintenanceList(  ){

			global $ini;

			// メンテナンス区分
			for($i=0; $i<count($ini["maintenanceFee"]); $i++){
				$sql_escape["mainteID"]  = sql_escapeString($ini["maintenanceFee"][$i]['id']);
				$sql_escape["mainteNum"] = sql_escapeString($i);

				$sql_maintenanceFee[] = "SELECT '{$sql_escape["mainteID"]}' as mainteID, {$sql_escape["mainteNum"]} as mainteNum ";
			}

			// リース期間
			for($i=0; $i<count($ini["lease"]["paynum"]); $i++){
				$sql_escape["paynumID"]  = sql_escapeString($ini["lease"]["paynum"][$i]['id']);

				$sql_paynum[] = "SELECT {$sql_escape["paynumID"]} as paynumID ";
			}

			// 走行距離(km)
			for($i=0; $i<count($ini["lease"]["mileage"]); $i++){
				$sql_escape["mileageID"]  = sql_escapeString($ini["lease"]["mileage"][$i]['id']);

				$sql_mileage[] = "SELECT {$sql_escape["mileageID"]} as mileageID ";
			}

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			$sql  = "SELECT ";
			$sql .= "   tbl.mainteID ";
			$sql .= " , tbl.payNumID ";
			$sql .= " , tbl.mileageID ";
			$sql .= " , COALESCE(mt.mainteFee, 0) AS mainteFee ";
			$sql .= "FROM ( ";
			$sql .= "    SELECT mt.mainteNum, mt.mainteID , lp.paynumID , lm.mileageID ";
			$sql .= "    FROM (" . implode( " UNION ALL ", $sql_maintenanceFee )  . ") as mt ";
			$sql .= "       , (" . implode( " UNION ALL ", $sql_paynum )  . ") as lp ";
			$sql .= "       , (" . implode( " UNION ALL ", $sql_mileage ) . ") as lm ";
			$sql .= "    ORDER BY mt.mainteNum ";
			$sql .= ") as tbl ";
			$sql .= "LEFT JOIN {$DBName}.maintenanceFee AS mt ON tbl.mainteID = mt.mainteID AND tbl.paynumID = mt.paynumID AND tbl.mileageID = mt.mileageID ";
			$sql .= "ORDER BY tbl.mainteNum , tbl.paynumID, tbl.mileageID";
			$tbl  = sql_query( $sql );

			// 取得データをまとめる
			for( $i = 0, $iMax = count($tbl); $i < $iMax; $i++ ){
				$tmp_mainteID   = $tbl[$i]["mainteID"];
				$tmp_payNumID   = $tbl[$i]["payNumID"];
				$tmp_mileageID  = $tbl[$i]["mileageID"];
				$tmp_ret[$tmp_mainteID][] = $tbl[$i];
			}

			for( $i = 0, $iMax = count($ini["maintenanceFee"]); $i < $iMax; $i++ ){
				$key = $ini["maintenanceFee"][$i]["id"];

				$ret[$i]["mainteID"] = $ini["maintenanceFee"][$i]["id"];
				$ret[$i]["mainte"]   = $tmp_ret[$key];
			}
			return $ret;
		}


		/*----------------------------------------------------
		  メンテナンス料の更新
		----------------------------------------------------*/
		function update_maintenanceFee( $input ){

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// 登録用にデータを整形
			$cnt = 0;
			for( $i = 0, $iMax = count($input); $i < $iMax; $i++ ){

				for( $j = 0, $jMax = count($input[$i]["mainte"]); $j < $jMax; $j++ ){
					$tmp_input[$cnt]["mainteID"]  = $input[$i]["mainteID"];
					$tmp_input[$cnt]["payNumID"]  = $input[$i]["mainte"][$j]["payNumID"];
					$tmp_input[$cnt]["mileageID"] = $input[$i]["mainte"][$j]["mileageID"];
					$tmp_input[$cnt]["mainteFee"] = $input[$i]["mainte"][$j]["mainteFee"];
					$cnt++;
				}
			}

			for( $i = 0, $iMax = count($tmp_input); $i < $iMax; $i++ ){
				$update["mainteFee"]             = $tmp_input[$i]["mainteFee"];
				$update["updateDatetime"]["com"] = "now()";

				// SQLインジェクション対応
				$sql_escape["mainteID"]  = sql_escapeString($tmp_input[$i]["mainteID"]);
				$sql_escape["payNumID"]  = sql_escapeString($tmp_input[$i]["payNumID"]);
				$sql_escape["mileageID"] = sql_escapeString($tmp_input[$i]["mileageID"]);

				$sql = "UPDATE {$DBName}.maintenanceFee SET {update_set} WHERE mainteID = '{$sql_escape["mainteID"]}' AND payNumID = '{$sql_escape["payNumID"]}' AND mileageID = '{$sql_escape["mileageID"]}' ";
				sql_query( $sql, $update, "1" );
			}

			return $ret;
		}
	}
?>