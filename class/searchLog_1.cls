<?php
/* -------------------------------------
	管理者管理
	for NetGRID PHP Framework v2
	最終更新: 2009-02-06
------------------------------------- */


	class searchLog_1 {


	/*----------------------------------------------------
	    コンストラクタ
	----------------------------------------------------*/
		function searchLog () {

		}

		/*----------------------------------------------------
		    検索ログ登録
		----------------------------------------------------*/
		function insert_DB ( $input, $searchDatetime ) {

			// ＤＢ名取得
			$DBName = get_DBName( "base" );

			// 検索条件の登録
			if( $input["parameter"]["from"] == "ranking" ){

				unset( $insert );
				$insert["searchType"]     = 2;
				$insert["searchDatetime"] = $searchDatetime;

				// メーカー名の取得
				for( $i = 0, $iMax = count($input["search"]["maker"]); $i < $iMax; $i++ ){
					$tmp_maker["ID"][]   = $input["search"]["maker"][$i]["ID"];
					$tmp_maker["name"][] = "'" . get_makerName( $input["search"]["maker"][$i]["ID"] , "active") . "'";
				}
				if ( count( $tmp_maker["ID"] ) > 0 ) {
					$insert["searchMaker"]     = @implode( "," , $tmp_maker["ID"] );
					$insert["searchMakerName"] = @implode( "," , $tmp_maker["name"] );
				}

				// ボディタイプ名の取得
				for( $i = 0, $iMax = count($input["search"]["type"]); $i < $iMax; $i++ ){
					$tmp_type["ID"][]   = $input["search"]["type"][$i]["ID"];
					$tmp_type["name"][] = "'" . get_bodyTypeName( $input["search"]["type"][$i]["ID"]) . "'";
				}
				if ( count( $tmp_type["ID"] ) > 0 ) {
					$insert["searchBodyType"]     = @implode( "," , $tmp_type["ID"] );
					$insert["searchBodyTypeName"] = @implode( "," , $tmp_type["name"] );
				}

				// テーマ名の取得
				for( $i = 0, $iMax = count($input["search"]["theme"]); $i < $iMax; $i++ ){
					$get_themeName = get_themeName( $input["search"]["theme"][$i]["ID"] , "active");

					$tmp_theme["ID"][]   = $input["search"]["theme"][$i]["ID"];
					$tmp_theme["name"][] = "'". $get_themeName["themeName"] . "'";
				}
				if ( count( $tmp_theme["ID"] ) > 0 ) {
					$insert["searchTheme"]     = @implode( "," , $tmp_theme["ID"] );
					$insert["searchThemeName"] = @implode( "," , $tmp_theme["name"] );
				}

				// 価格名の取得
				for( $i = 0, $iMax = count($input["search"]["price"]); $i < $iMax; $i++ ){
					$tmp_price["ID"][]   = $input["search"]["price"][$i]["ID"];
					$tmp_price["name"][] = "'" . get_priceRangeName( $input["search"]["price"][$i]["ID"]) . "'";
				}
				if ( count( $tmp_price["ID"] ) > 0 ) {
					$insert["searchPrice"]     = @implode( "," , $tmp_price["ID"] );
					$insert["searchPriceName"] = @implode( "," , $tmp_price["name"] );
				}


				// 登録
				$sql = "INSERT INTO {$DBName}.searchLog {insert_value};";
				list( $affected_row, $insertID ) = sql_query( $sql, $insert );
			}
			
			// 比較車種１の登録
			if( !empty($input["model1"]["modelCode"]) && !empty($input["model1"]["makerCode"]) && !empty($input["model1"]["carGradeCode"]) && empty($input["model1"]["systemSet"]) ){
				unset( $insert );
				$insert["searchType"]     = 1;
				$insert["searchDatetime"] = $searchDatetime;
				$insert["makerCode"]      = $input["model1"]["makerCode"];
				$insert["makerName"]      = get_makerName($input["model1"]["makerCode"] , "active");
				$insert["modelCode"]      = $input["model1"]["modelCode"];
				$insert["modelName"]      = get_modelName($input["model1"]["makerCode"] , $input["model1"]["modelCode"], "active");
				$insert["carGradeID"]     = $input["model1"]["carGradeCode"];
				
				// 登録
				$sql = "INSERT INTO {$DBName}.searchLog {insert_value};";
				list( $affected_row, $insertID ) = sql_query( $sql, $insert );
			}

			// 比較車種２の登録
			if( !empty($input["model2"]["modelCode"]) && !empty($input["model2"]["makerCode"]) && !empty($input["model2"]["carGradeCode"]) && empty($input["model2"]["systemSet"])){
				unset( $insert );
				$insert["searchType"]     = 1;
				$insert["searchDatetime"] = $searchDatetime;
				$insert["makerCode"]      = $input["model2"]["makerCode"];
				$insert["makerName"]      = get_makerName($input["model2"]["makerCode"] , "active");
				$insert["modelCode"]      = $input["model2"]["modelCode"];
				$insert["modelName"]      = get_modelName($input["model2"]["makerCode"] , $input["model2"]["modelCode"], "active");
				$insert["carGradeID"]     = $input["model2"]["carGradeCode"];
				
				// 登録
				$sql = "INSERT INTO {$DBName}.searchLog {insert_value};";
				list( $affected_row, $insertID ) = sql_query( $sql, $insert );
			}

			// 比較車種３の登録
			if( !empty($input["model3"]["modelCode"]) && !empty($input["model3"]["makerCode"]) && !empty($input["model3"]["carGradeCode"]) && empty($input["model3"]["systemSet"])){
				unset( $insert );
				$insert["searchType"]     = 1;
				$insert["searchDatetime"] = $searchDatetime;
				$insert["makerCode"]      = $input["model3"]["makerCode"];
				$insert["makerName"]      = get_makerName($input["model3"]["makerCode"] , "active");
				$insert["modelCode"]      = $input["model3"]["modelCode"];
				$insert["modelName"]      = get_modelName($input["model3"]["makerCode"] , $input["model3"]["modelCode"], "active");
				$insert["carGradeID"]     = $input["model3"]["carGradeCode"];
				
				// 登録
				$sql = "INSERT INTO {$DBName}.searchLog {insert_value};";
				list( $affected_row, $insertID ) = sql_query( $sql, $insert );
			}

			// 比較車種４の登録
			if( !empty($input["model4"]["modelCode"]) && !empty($input["model4"]["makerCode"]) && !empty($input["model4"]["carGradeCode"]) && empty($input["model4"]["systemSet"])){
				unset( $insert );
				$insert["searchType"]     = 1;
				$insert["searchDatetime"] = $searchDatetime;
				$insert["makerCode"]      = $input["model4"]["makerCode"];
				$insert["makerName"]      = get_makerName($input["model4"]["makerCode"] , "active");
				$insert["modelCode"]      = $input["model4"]["modelCode"];
				$insert["modelName"]      = get_modelName($input["model4"]["makerCode"] , $input["model4"]["modelCode"], "active");
				$insert["carGradeID"]     = $input["model4"]["carGradeCode"];
				
				// 登録
				$sql = "INSERT INTO {$DBName}.searchLog {insert_value};";
				list( $affected_row, $insertID ) = sql_query( $sql, $insert );
			}
		}


	}


?>