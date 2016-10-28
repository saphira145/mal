<?php
/* -------------------------------------
	管理者管理
	for NetGRID PHP Framework v2
	最終更新: 2009-02-06
------------------------------------- */


	class topModel_1 {


	/*----------------------------------------------------
	    コンストラクタ
	----------------------------------------------------*/
		function topModel () {

		}


		/*----------------------------------------------------
			検索条件の取得
		----------------------------------------------------*/
		function get_rankingSearchFormData() {
			
			global $ini;

			// ＤＢ名取得
			$DBName = get_DBName( "active" );

			// メーカー
			$sql  = "SELECT mk.makerCode, mk.makerName, count(tbl.carGradeID) as carCnt ";
			$sql .= "FROM ( ";
			$sql .= "    SELECT m.makerCode, m.modelCode, cg.carGradeID ";
			$sql .= "    FROM {$DBName}.model as m ";
			$sql .= "    LEFT JOIN {$DBName}.carGrade as cg ON m.lowPriceCarGradeID = cg.carGradeID OR m.s2wdCarGradeID  = cg.carGradeID OR m.s4wdCarGradeID  = cg.carGradeID ";
			$sql .= "    GROUP BY m.makerCode, m.modelCode ";
			$sql .= ") as tbl ";
			$sql .= "INNER JOIN {$DBName}.maker as mk ON mk.makerCode = tbl.makerCode ";
			$sql .= "GROUP BY mk.makerCode, mk.makerName ";
			$sql .= "HAVING carCnt > 0 ";
			$sql .= "ORDER BY mk.dispNum ";
			$tmpMakerList = sql_query( $sql );

			// クラスによって段落を分ける
			for( $i = 0; $i < count($tmpMakerList); $i++ ){
				if( get_makerClassFlg($tmpMakerList[$i]["makerCode"]) ){
					//Lux.クラス
					$tmp_list["maker"]["lux"][] = $tmpMakerList[$i];
				} else {
					//entryクラス
					$tmp_list["maker"]["entry"][] = $tmpMakerList[$i];
				}
			}

			// クラスごとに１段に表示する件数まで空の配列を設定する
			$listArr = array("makerCode" => "", "makerName" => "", "carCnt" => 0,);
			foreach ($tmp_list["maker"] as $key => $vList){
				$tmp_list["makerList"][$key] = array();
				if( $vList ){
					$cnt = @ceil(count($vList) / $ini["makerBoxNum"]) * $ini["makerBoxNum"];
					$tmp_list["makerList"][$key] = array_pad($vList, $cnt , $listArr);
				}
			}

			// クラスをまとめる
			if( isset($tmp_list["makerList"]["entry"]) && isset($tmp_list["makerList"]["lux"]) ){
				$list["makerList"] = array_merge($tmp_list["makerList"]["entry"], $tmp_list["makerList"]["lux"]);
			} else if( !isset($tmp_list["makerList"]["entry"]) && isset($tmp_list["makerList"]["lux"]) ) {
				//Lux.クラスのみ
				$list["makerList"] = $tmp_list["makerList"]["lux"];
			} else {
				//entryクラスのみ
				$list["makerList"] = $tmp_list["makerList"]["entry"];
			}

			// ボディタイプ
			$sql  = "SELECT tbl.bodyModel, count(tbl.bodyModel) as carCnt ";
			$sql .= "FROM ( ";
			$sql .= "    SELECT cg.bodyModel ";
			$sql .= "    FROM {$DBName}.model as m ";
			$sql .= "    LEFT JOIN {$DBName}.carGrade as cg ON m.lowPriceCarGradeID = cg.carGradeID OR m.s2wdCarGradeID  = cg.carGradeID OR m.s4wdCarGradeID  = cg.carGradeID ";
			$sql .= "    GROUP BY m.makerCode, m.modelCode , cg.bodyModel ";
			$sql .= "    HAVING cg.bodyModel is not NULL ";
			$sql .= ") as tbl ";
			$sql .= "GROUP BY tbl.bodyModel ";
			$tmp_getBodyTypeList = sql_query( $sql );
			$bodyCnt = 0;
			for( $i=0; $i<count($ini["bodyType"]); $i++ ){
				foreach ($tmp_getBodyTypeList as $value){
					if( $ini["bodyType"][$i]["ID"] == $value["bodyModel"] ){
						$list["bodyTypeList"][$bodyCnt]           = $ini["bodyType"][$i];
						$list["bodyTypeList"][$bodyCnt]["carCnt"] = $value["carCnt"];
						$bodyCnt++;
						break;
					}
				}
			}


			// テーマ
			$sql  = "SELECT tm.themeID, tm.themeName, tm.nameAbbreviation, tm.iconNo, count(tbl.carGradeID) as carCnt ";
			$sql .= "FROM ( ";
			$sql .= "    SELECT m.makerCode, m.modelCode, cg.carGradeID ";
			$sql .= "    FROM {$DBName}.model as m ";
			$sql .= "    LEFT JOIN {$DBName}.carGrade as cg ON m.lowPriceCarGradeID = cg.carGradeID OR m.s2wdCarGradeID  = cg.carGradeID OR m.s4wdCarGradeID  = cg.carGradeID ";
			$sql .= "    WHERE cg.carGradeID IS NOT NULL ";
			$sql .= "    GROUP BY m.makerCode, m.modelCode ";
			$sql .= ") as tbl ";
			$sql .= "INNER JOIN {$DBName}.carTheme as ct ON ct.modelCode = tbl.modelCode AND ct.makerCode = tbl.makerCode ";
			$sql .= "INNER JOIN {$DBName}.themeMst as tm ON tm.themeID = ct.themeID ";
			$sql .= "WHERE tm.statusType = 100 ";
			$sql .= "GROUP BY tm.themeID, tm.themeName, tm.nameAbbreviation, tm.iconNo ";
			$sql .= "ORDER BY tm.dispNum ";
			$list["themeList"] = sql_query( $sql );

			for( $i=0; $i<count($list["themeList"]); $i++ ){
				foreach ( $ini["themeIcon"] as $k => $v ) {
					if( $list["themeList"][$i]["iconNo"] == $v["id"] ){
						$list["themeList"][$i]["iconPath"] = $v["path"];
					}
				}
			}

			// 定価区分

			// CASE作成
			for( $i=0; $i<count($ini["carGrade"]); $i++ ){
				$carGrade = $ini["carGrade"][$i];
				$sql_escape["carGradeID"] = sql_escapeString($carGrade["ID"]);

				$where["case"][] = "WHEN m.{$sql_escape["carGradeID"]} > 0 THEN m.{$sql_escape["carGradeID"]} ";
			}

			if ( count( $where["case"] ) > 0 ) {
				$sql_case = @implode( $where["case"] );
			}

			for( $i=1; $i<=count($ini["carPrice"]); $i++ ){
				$carPrice = $ini["carPrice"][$i];
				$sql_escape["carPriceID"] = sql_escapeString($carPrice["ID"]);

				// WHERE句作成
				if( !empty($carPrice["priceMax"])){
					// FROM～TO
					$sql_escape["priceMin"] = sql_escapeString($carPrice["priceMin"]);
					$sql_escape["priceMax"] = sql_escapeString($carPrice["priceMax"]);
					$sql_where = "kakaku.taxIncludedPrice >= '{$sql_escape["priceMin"]}' AND kakaku.taxIncludedPrice <= '{$sql_escape["priceMax"]}' ";
				} else {
					// FROM～
					$sql_escape["priceMin"] = sql_escapeString($carPrice["priceMin"]);
					$sql_where = "kakaku.taxIncludedPrice >= '{$sql_escape["priceMin"]}' ";
				}
				$tmp_sql .= "";
				$tmp_sql  = "SELECT {$sql_escape["carPriceID"]} as carPriceID, COUNT(*) as carCnt ";
				$tmp_sql .= "FROM ( ";
				$tmp_sql .= "    SELECT  ";
				$tmp_sql .= "        m.makerCode,  ";
				$tmp_sql .= "        m.modelCode,  ";
				$tmp_sql .= "        CAST(s2wd.taxIncludedPrice as SIGNED) as s2wd,  ";
				$tmp_sql .= "        CAST(s4wd.taxIncludedPrice as SIGNED) as s4wd,  ";
				$tmp_sql .= "        CAST(lowPrice.taxIncludedPrice as SIGNED) as lowPrice,  ";

//---【暫定対応】  2014/10/02の代表グレード設定にて最廉価が登録されていない車種ができた為、一時的に全代表グレードをチェックする ---
/*				$tmp_sql .= "        CASE ";
				$tmp_sql .= "            WHEN m.s2wdCarGradeID     > 0 THEN 's2wd' ";
				$tmp_sql .= "            WHEN m.s4wdCarGradeID     > 0 THEN 's4wd' ";
				$tmp_sql .= "            WHEN m.lowPriceCarGradeID > 0 THEN 'lowPrice' ";
				$tmp_sql .= "        END grade, ";
				$tmp_sql .= "        CAST(lowPrice.taxIncludedPrice as SIGNED) as taxIncludedPrice ";	// 最廉価のグレード金額を使用する
*/

				$tmp_sql .= "        CASE ";
				$tmp_sql .= "            WHEN m.lowPriceCarGradeID > 0 THEN 'lowPrice' ";
				$tmp_sql .= "            WHEN m.s2wdCarGradeID     > 0 THEN 's2wd' ";
				$tmp_sql .= "            WHEN m.s4wdCarGradeID     > 0 THEN 's4wd' ";
				$tmp_sql .= "        END grade, ";
				$tmp_sql .= "        CASE ";
				$tmp_sql .= "            WHEN m.lowPriceCarGradeID > 0 THEN CAST(lowPrice.taxIncludedPrice as SIGNED) ";
				$tmp_sql .= "            WHEN m.s2wdCarGradeID     > 0 THEN CAST(s2wd.taxIncludedPrice as SIGNED) ";
				$tmp_sql .= "            WHEN m.s4wdCarGradeID     > 0 THEN CAST(s4wd.taxIncludedPrice as SIGNED) ";
				$tmp_sql .= "        END taxIncludedPrice ";
//---------------------------------------------


				$tmp_sql .= "    FROM {$DBName}.model m ";
				$tmp_sql .= "    LEFT JOIN {$DBName}.carGrade s2wd ";
				$tmp_sql .= "    ON m.s2wdCarGradeID = s2wd.carGradeID ";
				$tmp_sql .= "    LEFT JOIN {$DBName}.carGrade s4wd ";
				$tmp_sql .= "    ON m.s4wdCarGradeID = s4wd.carGradeID ";
				$tmp_sql .= "    LEFT JOIN {$DBName}.carGrade lowPrice ";
				$tmp_sql .= "    ON m.lowPriceCarGradeID = lowPrice.carGradeID ";
				$tmp_sql .= ") kakaku ";
				$tmp_sql .= "WHERE kakaku.taxIncludedPrice IS NOT NULL ";
				$tmp_sql .= "AND {$sql_where} ";
                
				$sql_list[] = $tmp_sql;
			}
			
			if( !empty( $sql_list ) ){
				$sql = "" . @implode( " UNION ", $sql_list );
				$tmp_getcarPriceList = sql_query( $sql );

				for( $i=1; $i<=count($ini["carPrice"]); $i++ ){
					foreach ($tmp_getcarPriceList as $value){
						if( $ini["carPrice"][$i]["ID"] == $value["carPriceID"] ){
							$list["carPriceList"][$i -1]           = $ini["carPrice"][$i];
							$list["carPriceList"][$i -1]["carCnt"] = $value["carCnt"];
							break;
						}
					}
				}
			}

			return $list;
		}

	}


?>