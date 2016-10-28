<?php
/* -------------------------------------
	管理者管理
	for NetGRID PHP Framework v2
	最終更新: 2009-02-06
------------------------------------- */


	class carModelSearchAdmin_1 {


	/*----------------------------------------------------
	    コンストラクタ
	----------------------------------------------------*/
		function carModelSearchAdmin_1 () {

		}


		/*----------------------------------------------------
		  リスト取得
		----------------------------------------------------*/
		function get_list ( $input ) {

			global $ini;

			// DB名取得
			if( empty($input["DB"]) ){
				$input["DB"] = "work";
			}
			$DBName = get_DBName( $input["DB"] );

			// メーカーコード
			unset($where);
			if ( $input["searchMakerCode"] != "" ) {
				$sql_escape["searchMakerCode"] = sql_escapeString($input["searchMakerCode"]);
				$where[] = "m.makerCode = '{$sql_escape["searchMakerCode"]}'";
			}

			// 車種名
			if ( $input["searchModelName"] != "" ) {
				$sql_escape["searchModelName"] = sql_escapeString($input["searchModelName"]);
				$where[] = "m.modelName LIKE '%{$sql_escape["searchModelName"]}%'";
			}

			// ボディタイプ
			if ( $input["searchBodyType"] != "" ) {
				unset($bodyModel_where);
				$sql_escape["searchBodyType"] = sql_escapeString($input["searchBodyType"]);

				$where[] = "bodyModel = '{$sql_escape["searchBodyType"]}'";
			}

			// テーマID
			if ( $input["themeID"] != "" ) {
				$sql_escape["themeID"] = sql_escapeString($input["themeID"]);

				$where_theme = "AND ct.makerCode = m.makerCode AND ct.modelCode = m.modelCode AND ct.themeID = '{$sql_escape["themeID"]}'";
				$sql_from    = ", {$DBName}.carTheme as ct";
				$sql_groupThemeID = ", ct.themeID";
			}


			if ( count( $where ) > 0 ) {
				$sql_where = "WHERE " . @implode( " AND ", $where );
			}

			// 件数の取得
			$sql  = "SELECT DISTINCT m.modelCode, m.modelName, mk.makerCode, mk.makerName ";
			$sql .= "FROM {$DBName}.model as m , {$DBName}.maker as mk ";
			$sql .= "{$sql_from} ";
			$sql .= "WHERE m.makerCode = mk.makerCode ";
			$sql .= "AND ( m.lowPriceCarGradeID IN (SELECT DISTINCT carGradeID FROM {$DBName}.carGrade {$sql_where} ) ";
			$sql .= "OR m.s2wdCarGradeID IN (SELECT DISTINCT carGradeID FROM {$DBName}.carGrade {$sql_where} ) ";
			$sql .= "OR m.s4wdCarGradeID IN (SELECT DISTINCT carGradeID FROM {$DBName}.carGrade {$sql_where} ) ) ";
			$sql .= "{$where_theme} ";
			$sql .= "ORDER BY mk.dispNum, m.modelName ";
			$tbl  = (array)sql_query( $sql );

			// ページ情報の取得
			$pageInfo = adjust_pageState( count($tbl), $ini["pageLimit"]["carModelSearchAdmin"], $input["pageNum"] );

			// SQLインジェクション対応
			$sql_escape["limitStart"] = sql_escapeString($pageInfo["limitStart"]);
			$sql_escape["pageLimit"]  = sql_escapeString($ini["pageLimit"]["carModelSearchAdmin"]);

			// 出力データの取得
			$sql  = "SELECT DISTINCT m.modelCode, m.modelName, mk.makerCode, mk.makerName ";
			$sql .= "FROM {$DBName}.model as m , {$DBName}.maker as mk ";
			$sql .= "{$sql_from} ";
			$sql .= "WHERE m.makerCode = mk.makerCode ";
			$sql .= "AND ( m.lowPriceCarGradeID IN (SELECT DISTINCT carGradeID FROM {$DBName}.carGrade {$sql_where} ) ";
			$sql .= "OR m.s2wdCarGradeID IN (SELECT DISTINCT carGradeID FROM {$DBName}.carGrade {$sql_where} ) ";
			$sql .= "OR m.s4wdCarGradeID IN (SELECT DISTINCT carGradeID FROM {$DBName}.carGrade {$sql_where} ) ) ";
			$sql .= "{$where_theme} ";
			$sql .= "ORDER BY mk.dispNum, m.modelName ";
			$sql .= "LIMIT {$sql_escape["limitStart"]}, {$sql_escape["pageLimit"]} ";
			$list = (array)sql_query( $sql );

			// 各データのボディタイプ取得
			for($i = 0, $iMax = count($list); $i < $iMax; $i++){
				// SQLインジェクション対応
				unset($sql_escape);
				$sql_escape["makerCode"] = sql_escapeString($list[$i]["makerCode"]);
				$sql_escape["modelCode"] = sql_escapeString($list[$i]["modelCode"]);

				$sql  = "SELECT DISTINCT bodyModel ";
				$sql .= "FROM {$DBName}.carGrade ";
				$sql .= "WHERE carGradeID IN ( SELECT lowPriceCarGradeID FROM {$DBName}.model WHERE makerCode = '{$sql_escape["makerCode"]}' AND modelCode = '{$sql_escape["modelCode"]}') ";
				$sql .= "OR carGradeID IN ( SELECT s2wdCarGradeID FROM {$DBName}.model WHERE makerCode = '{$sql_escape["makerCode"]}' AND modelCode = '{$sql_escape["modelCode"]}') ";
				$sql .= "OR carGradeID IN ( SELECT s4wdCarGradeID FROM {$DBName}.model WHERE makerCode = '{$sql_escape["makerCode"]}' AND modelCode = '{$sql_escape["modelCode"]}') ";
				$bodyModel = (array)sql_query( $sql );

				for($j = 0, $jMax = count($bodyModel); $j < $jMax; $j++){
					$list[$i]["bodyModel"][]["ID"] = $bodyModel[$j]["bodyModel"];
				}
			}

			return array( $list, $pageInfo );

		}

	}


?>