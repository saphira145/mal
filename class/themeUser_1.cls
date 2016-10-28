<?php


	class themeUser_1 {


	/*----------------------------------------------------
	    コンストラクタ
	----------------------------------------------------*/
		function themeUser_1 () {

		}


		/*----------------------------------------------------
		  テーマリストの取得
		----------------------------------------------------*/
		function get_themeList ( $makerCode, $modelCode ) {

			// ＤＢ名取得
			$DBName = get_DBName( "active" );

			// SQLインジェクション対応
			$sql_escape["makerCode"] = sql_escapeString($makerCode);
			$sql_escape["modelCode"] = sql_escapeString($modelCode);

			$sql  = "SELECT carTheme.themeID , themeMst.priorityNum ";
			$sql .= "FROM {$DBName}.carTheme INNER JOIN {$DBName}.themeMst ON carTheme.themeID = themeMst.themeID ";
			$sql .= "WHERE themeMst.statusType = 100 ";
			$sql .= "AND carTheme.makerCode = '{$sql_escape["makerCode"]}' ";
			$sql .= "AND carTheme.modelCode = '{$sql_escape["modelCode"]}' ";
			$sql .= "ORDER BY themeMst.dispNum ";
			$themeList = (array)sql_query( $sql );

			return $themeList;
		}

		/*----------------------------------------------------
		  おすすめ車種の取得
		    $themeList: Array型
		----------------------------------------------------*/
		function get_thmemeRecomCar ( $themeList, $bodyModelID ) {

			// ＤＢ名取得
			$DBName = get_DBName( "active" );

			// おすすめ車種のメーカー・車種IDの取得
			$sql  = "SELECT makerCode, modelCode ";
			$sql .= "FROM {$DBName}.themeRecommend ";
			$sql .= "WHERE 1=1 ";
			
			// バリューが無い車種の場合、おすすめ車用「バリュー」を使用して検索する
			// @version 2014-03-12
			if( count($themeList) > 0 ){
				$sql_escape["themeID"] = sql_escapeString($themeList[0]);
				$sql .= "AND themeID = '{$sql_escape["themeID"]}' ";
			}else{
				// 当該バリューは statusType = 200
				// (131_theme.ini に記載)
				$sql .= "AND themeID = (SELECT themeID FROM {$DBName}.themeMst WHERE statusType = 200 ORDER BY priorityNum LIMIT 1) ";
			}

			$sql_escape["bodyModelID"] = sql_escapeString($bodyModelID);
			$sql .= "AND bodyModel = '{$sql_escape["bodyModelID"]}' ";
			$ret = sql_query( $sql, "single" );

			return $ret;
		}


		/*----------------------------------------------------
		  選定基準の取得
		----------------------------------------------------*/
		function get_basisOfSelectionList () {

			// ＤＢ名取得
			$DBName = get_DBName( "active" );

			$sql  = "SELECT DISTINCT tm.* ";
			$sql .= "FROM {$DBName}.model as m, {$DBName}.carTheme as ct, {$DBName}.themeMst as tm ";
			$sql .= "WHERE tm.themeID = ct.themeID ";
			$sql .= "AND   ( ct.modelCode = m.modelCode AND ct.makerCode = m.makerCode ) ";
			$sql .= "AND tm.statusType = 100 ";
			$sql .= "AND ( m.lowPriceCarGradeID IN (SELECT DISTINCT carGradeID FROM {$DBName}.carGrade) ";
			$sql .= "OR m.s2wdCarGradeID IN (SELECT DISTINCT carGradeID FROM {$DBName}.carGrade) ";
			$sql .= "OR m.s4wdCarGradeID IN (SELECT DISTINCT carGradeID FROM {$DBName}.carGrade) ) ";
			$sql .= "ORDER BY tm.dispNum ";
			$themeList = (array)sql_query( $sql );

			return $themeList;
		}

	}
?>