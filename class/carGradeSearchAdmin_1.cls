<?php
/* -------------------------------------
	管理者管理
	for NetGRID PHP Framework v2
	最終更新: 2009-02-06
------------------------------------- */


	class carGradeSearchAdmin_1 {


	/*----------------------------------------------------
	    コンストラクタ
	----------------------------------------------------*/
		function carGradeSearchAdmin () {

		}


		/*----------------------------------------------------
		  リスト取得
		----------------------------------------------------*/
		function get_list ( $input ) {

			global $ini;

			// 車種コード
			if ( $input["searchModelCode"] != "" ) {
				$sql_escape["searchModelCode"] = sql_escapeString($input["searchModelCode"]);
				$where[] = "cg.modelCode = '{$sql_escape["searchModelCode"]}'";
			}

			// メーカーコード
			if ( $input["searchMakerCode"] != "" ) {
				$sql_escape["searchMakerCode"] = sql_escapeString($input["searchMakerCode"]);
				$where[] = "cg.makerCode = '{$sql_escape["searchMakerCode"]}'";
			}

			// 車種名
			if ( $input["searchModelName"] != "" ) {
				$sql_escape["searchModelName"] = sql_escapeString($input["searchModelName"]);
				$where[] = "cg.modelName LIKE '%{$sql_escape["searchModelName"]}%'";
			}

			if ( count( $where ) > 0 ) {
				$sql_where = "WHERE " . @implode( " AND ", $where );
			}

			// DB名取得
			$DBName = get_DBName( "work" );

			// 件数の取得
			$sql = "SELECT count(*) AS cnt FROM {$DBName}.carGrade as cg {$sql_where}";
			$tbl = sql_query( $sql, "single" );

			// ページ情報の取得
			$pageInfo = adjust_pageState( $tbl["cnt"], $ini["pageLimit"]["carGradeSearchAdmin"], $input["pageNum"] );

			// SQLインジェクション対応
			$sql_escape["limitStart"] = sql_escapeString($pageInfo["limitStart"]);
			$sql_escape["pageLimit"]  = sql_escapeString($ini["pageLimit"]["carGradeSearchAdmin"]);

			$sql  = "SELECT cg.* , mt.mainteID, mt.mainteState ";
			$sql .= "FROM {$DBName}.carGrade as cg ";
			$sql .= "LEFT JOIN {$DBName}.maintenance as mt ";
			$sql .= "ON cg.makerCode = mt.makerCode AND cg.modelCode = mt.modelCode AND cg.carGradeID = mt.carGradeID ";
			$sql .= "{$sql_where} ";
			$sql .= "ORDER BY cg.carGradeID DESC ";
			$sql .= "LIMIT {$sql_escape["limitStart"]}, {$sql_escape["pageLimit"]}";

			$list = (array)sql_query( $sql );

			return array( $list, $pageInfo );
		}


	}


?>