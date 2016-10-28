<?php
/* -------------------------------------
	管理者管理
	for NetGRID PHP Framework v2
	最終更新: 2009-02-06
------------------------------------- */


	class modelUser_1 {


	/*----------------------------------------------------
	    コンストラクタ
	----------------------------------------------------*/
		function memberUser () {

		}


		/*----------------------------------------------------
		  情報取得
		----------------------------------------------------*/
		function get_info ( $makerCode, $modelCode ) {

			// ＤＢ名取得
			$DBName = get_DBName( "active" );

			// SQLインジェクション対応
			$sql_escape["makerCode"] = sql_escapeString($makerCode);
			$sql_escape["modelCode"] = sql_escapeString($modelCode);

			$sql = "SELECT * FROM {$DBName}.model WHERE makerCode = '{$sql_escape["makerCode"]}' AND modelCode = '{$sql_escape["modelCode"]}'";
			$ret = sql_query( $sql, "single" );

			$ret["price"]["mini"]          = $ret["miniPrice"];
			$ret["price"]["max"]           = $ret["maxPrice"];
			$ret["totalLength"]["mini"]    = $ret["miniTotalLength"];
			$ret["totalLength"]["max"]     = $ret["maxTotalLength"];
			$ret["totalWidth"]["mini"]     = $ret["miniTotalWidth"];
			$ret["totalWidth"]["max"]      = $ret["maxTotalWidth"];
			$ret["totalHeight"]["mini"]    = $ret["miniTotalHeight"];
			$ret["totalHeight"]["max"]     = $ret["maxTotalHeight"];
			$ret["announcementDay"]        = db2val_dateType1( $ret["announcementDay"] );
			$ret["topUpdateDay"]           = db2val_dateType1( $ret["topUpdateDay"] );


			return $ret;
		}


		/*----------------------------------------------------
		  表示用に変更
		----------------------------------------------------*/
		function convert_info ( $info ) {

			// メーカー名取得
			$info["makerName"]               = get_makerName( $info["makerCode"], "active" );
			
			// メーカー車種名
			$info["makerCarName"]            = $info["makerName"] . "　" . $info["modelName"];
			
			// 画像取得
			$photoName = get_carGradeBodyPhotoName ( $info["makerCode"], $info["modelCode"], $info["spec"]["carGrade"]["carGradeID"], 1 );
			if( $photoName != "noImage" ) {
				$info["carBodyPhotoName"]      = $photoName;
			}
			else{
				$info["carBodyPhotoName"]        = get_carBodyPhotoName ( $info["makerCode"], $info["modelCode"], 1 );
			}

			return $info;
		}


		/*----------------------------------------------------
			代表車種グレード(デフォルト)の取得
		----------------------------------------------------*/
		function get_defaultCarGrade ( $makerCode, $modelCode, $bodyModel=null ) {

			if( empty($makerCode) || empty($modelCode) ){
				return NULL;
			}

			// ＤＢ名取得
			$DBName = get_DBName( "active" );

			$sql = "";
			$sql .= "SELECT modelList.carGradeID ";
			$sql .= "FROM ( ";
			$sql .= "    SELECT ";
			$sql .= "        m.makerCode, ";
			$sql .= "        m.modelCode, ";
			$sql .= "        s2wd.carGradeID, ";
			$sql .= "        s2wd.bodyModel, ";
			$sql .= "        s2wd.bodyModelName, ";
			$sql .= "        '1_s2wd' as grade ";
			$sql .= "    FROM {$DBName}.model m ";
			$sql .= "    LEFT JOIN {$DBName}.carGrade s2wd ON m.s2wdCarGradeID = s2wd.carGradeID ";
			$sql .= " ";
			$sql .= "    UNION ALL ";
			$sql .= "    SELECT ";
			$sql .= "        m.makerCode, ";
			$sql .= "        m.modelCode, ";
			$sql .= "        s4wd.carGradeID, ";
			$sql .= "        s4wd.bodyModel, ";
			$sql .= "        s4wd.bodyModelName, ";
			$sql .= "        '2_s4wd' as grade ";
			$sql .= "    FROM {$DBName}.model m ";
			$sql .= "    LEFT JOIN {$DBName}.carGrade s4wd ON m.s4wdCarGradeID = s4wd.carGradeID ";
			$sql .= " ";
			$sql .= "    UNION ALL ";
			$sql .= "    SELECT ";
			$sql .= "        m.makerCode, ";
			$sql .= "        m.modelCode, ";
			$sql .= "        lowPrice.carGradeID, ";
			$sql .= "        lowPrice.bodyModel, ";
			$sql .= "        lowPrice.bodyModelName, ";
			$sql .= "        '3_lowPrice' as grade ";
			$sql .= "    FROM {$DBName}.model m ";
			$sql .= "    LEFT JOIN {$DBName}.carGrade lowPrice ON m.lowPriceCarGradeID = lowPrice.carGradeID ";
			$sql .= ") modelList ";
			$sql .= "WHERE 1=1 ";

			// メーカー
			if( !empty($makerCode) ){
				$sql_escape["makerCode"] = sql_escapeString($makerCode);
				$sql .= "AND modelList.makerCode = '{$sql_escape["makerCode"]}' ";
			}

			// 車種
			if( !empty($modelCode) ){
				$sql_escape["modelCode"] = sql_escapeString($modelCode);
				$sql .= "AND modelList.modelCode = '{$sql_escape["modelCode"]}' ";
			}

			// ボディタイプ
			if( !empty($bodyModel[0]) ){
				$sql_escape["bodyModel"] = sql_escapeString($bodyModel[0]);
				$sql .= "AND modelList.bodyModel = '{$sql_escape["bodyModel"]}' ";
			}

			$sql .= "AND modelList.carGradeID IS NOT NULL ";
			$sql .= "ORDER BY modelList.grade ";
			$sql .= "LIMIT 1 ";

			$ret  = sql_query( $sql, "single" );

			return array($ret["carGradeID"]);

		}


		/*----------------------------------------------------
		  車種グレードリストの取得
		----------------------------------------------------*/
		function get_carGradeIDList ( $makerCode, $modelCode ) {
			
			if( empty($makerCode) || empty($modelCode) ){
				return NULL;
			}

			// ＤＢ名取得
			$DBName = get_DBName( "active" );

			// SQLインジェクション対応
			$sql_escape["makerCode"] = sql_escapeString($makerCode);
			$sql_escape["modelCode"] = sql_escapeString($modelCode);

			$sql = "SELECT lowPriceCarGradeID, s2wdCarGradeID, s4wdCarGradeID FROM {$DBName}.model WHERE makerCode = '{$sql_escape["makerCode"]}' AND modelCode = '{$sql_escape["modelCode"]}'";
			$tbl = sql_query( $sql, "single" );

			$arrCarGrade["s2wdCarGradeID"]     = $tbl["s2wdCarGradeID"];
			$arrCarGrade["s4wdCarGradeID"]     = $tbl["s4wdCarGradeID"];
			$arrCarGrade["lowPriceCarGradeID"] = $tbl["lowPriceCarGradeID"];
			$cnt = 0;

			foreach( $arrCarGrade as $key => $val){
				if( !empty($val) ){
					$ret[$cnt]["ID"]   = $val;
					$ret[$cnt]["name"] = $key;
					$cnt++;
				}
			}

			return $ret;
		}

	}


?>