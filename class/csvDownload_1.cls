<?php
/* -------------------------------------
	管理者管理
	for NetGRID PHP Framework v2
	最終更新: 2009-02-06
------------------------------------- */


	class csvDownload_1 {


	/*----------------------------------------------------
	    コンストラクタ
	----------------------------------------------------*/
		function csvDownload () {

		}


		/*----------------------------------------------------
		    車種別の比較回数リスト取得
		----------------------------------------------------*/
		function get_modelSummaryList ( $input ) {

			// ＤＢ名取得
			$DBName = get_DBName( "base" );

			// ＤＢ名取得（アクティブ）
			$activeDBName = get_DBName( "active" );

			// ログタイプ(1:車種)
			$where[]  = "searchType = '1'";

			// 期間（ＦＲＯＭ）
			if( $input["downloadInfo"]["from"]["date"] != "" ) {
				$fromDate = val2db_dateType1( $input["downloadInfo"]["from"] );
				$sql_escape["fromDate"] = sql_escapeString($fromDate);
			}

			// 期間（ＴＯ）
			if( $input["downloadInfo"]["to"]["date"] != "" ) {
				$toDate = val2db_dateType1( $input["downloadInfo"]["to"] );
				$sql_escape["toDate"] = sql_escapeString($toDate);
			}
			$where[]  = "searchDatetime BETWEEN '{$sql_escape["fromDate"]}' AND '{$sql_escape["toDate"]}'";

			// WHERE BY句生成
			if ( count( $where ) > 0 ) {
				$sql_where = "WHERE " . @implode( " AND ", $where );
			}

			// リスト取得
			$sql  = "select * ";
			$sql .= "from ( ";
			$sql .= "  SELECT searchLog.makerName";
			$sql .= "       , searchLog.modelName ";
			$sql .= "       , COUNT(distinct searchLogID) as count ";
			$sql .= "       , dispNum ";
			$sql .= "  FROM {$DBName}.searchLog ";
			$sql .= "  LEFT JOIN {$activeDBName}.maker ";
			$sql .= "     ON searchLog.makerCode = maker.makerCode ";
			$sql .= "  {$sql_where} ";
			$sql .= "  GROUP BY searchLog.makerCode, searchLog.modelCode ";
			$sql .= ") as tbl ";
			$sql .= "ORDER BY count DESC, dispNum IS NULL, dispNum, modelName ";
			$list = (array)sql_query( $sql );

			return $list;
		}


		/*----------------------------------------------------
		    検索条件リスト取得
		----------------------------------------------------*/
		function get_searchList ( $input ) {

			// ＤＢ名取得
			$DBName = get_DBName( "base" );

			// ログタイプ(1:車種)
			$where[]  = "searchType = '2'";

			// 期間（ＦＲＯＭ）
			if( $input["downloadInfo"]["from"]["date"] != "" ) {
				$fromDate = val2db_dateType1( $input["downloadInfo"]["from"] );
				$sql_escape["fromDate"] = sql_escapeString($fromDate);

				$where[]  = "SUBSTRING( searchDatetime, 1, 10 ) >= '{$sql_escape["fromDate"]}'";
			}

			// 期間（ＴＯ）
			if( $input["downloadInfo"]["to"]["date"] != "" ) {
				$toDate = val2db_dateType1( $input["downloadInfo"]["to"] );
				$sql_escape["toDate"] = sql_escapeString($toDate);

				$where[]  = "SUBSTRING( searchDatetime, 1, 10 ) <= '{$sql_escape["toDate"]}'";
			}

			// WHERE BY句生成
			if ( count( $where ) > 0 ) {
				$sql_where = "WHERE " . @implode( " AND ", $where );
			}

			// リスト取得
			$sql  = "SELECT searchMakerName, searchBodyTypeName, searchThemeName, searchPriceName ";
			$sql .= "FROM {$DBName}.searchLog ";
			$sql .= "{$sql_where} ";
			$sql .= "ORDER BY searchDatetime ";
			$list = (array)sql_query( $sql );

			return $list;
		}


		/*----------------------------------------------------
		    全車種・バリューリスト取得
		----------------------------------------------------*/
		function get_carThemeList ( $input ) {

			global $ini, $path;


			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// 車種リストの取得
			$sql  = "SELECT tbl.* ";
			$sql .= "FROM ";
			$sql .= "( select  mk.makerCode ";
			$sql .= "     , mk.makerName ";
			$sql .= "     , m.modelCode ";
			$sql .= "     , m.modelName ";
			$sql .= "     , mk.dispNum ";
			$sql .= "  from {$DBName}.model AS m , {$DBName}.maker AS mk ";
			$sql .= "  WHERE mk.makerCode = m.makerCode ";
			$sql .= ") as tbl ";
			$sql .= "ORDER BY tbl.dispNum , tbl.modelName ";
			$modelList = (array)sql_query( $sql );

			// 各車種毎にバリュー情報を取得
			for( $i = 0, $iMax = count($modelList); $i < $iMax; $i++ ){
				// SQLインジェクション対応
				$sql_escape["makerCode"] = sql_escapeString($modelList[$i]["makerCode"]);
				$sql_escape["modelCode"] = sql_escapeString($modelList[$i]["modelCode"]);

				$sql  = "SELECT tm.themeID, tm.themeName, ct.themeID is not null as flgOnOff ";
				$sql .= "FROM {$DBName}.themeMst AS tm ";
				$sql .= "LEFT JOIN {$DBName}.carTheme AS ct ON ct.makerCode = '{$sql_escape["makerCode"]}' AND ct.modelCode = '{$sql_escape["modelCode"]}' AND tm.themeID = ct.themeID ";
				$sql .= "WHERE tm.statusType = 100 ";
				$sql .= "ORDER BY tm.dispNum ";
				$themeList = (array)sql_query( $sql );

				// リスト作成
				$list[] = array_merge($modelList[$i], array("theme" => $themeList));
			}


			return $list;
		}


		/*----------------------------------------------------
		    全グレード・リース料(残価・任意保険料)リスト取得
		----------------------------------------------------*/
		function get_leaseValueList ( $input ) {
			global $ini;

			if( empty($input["makerCode"]) ){
				return;
			}

			// SQLインジェクション対応
			$sql_escape["makerCode"] = sql_escapeString($input["makerCode"]);

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// リース形態
			for($i=0; $i<count($ini["lease"]["contract"]); $i++){
				$sql_escape["contractID"] = sql_escapeString($ini["lease"]["contract"][$i]['id']);
				$sql_contract[] = "SELECT {$sql_escape["contractID"]} as contractID ";
			}

			// リース期間
			for($i=0; $i<count($ini["lease"]["paynum"]); $i++){
				$sql_escape["paynumID"] = sql_escapeString($ini["lease"]["paynum"][$i]['id']);
				$sql_paynum[] = "SELECT {$sql_escape["paynumID"]} as paynumID ";
			}

			// 走行距離(km)
			for($i=0; $i<count($ini["lease"]["mileage"]); $i++){
				$sql_escape["mileageID"] = sql_escapeString($ini["lease"]["mileage"][$i]['id']);
				$sql_mileage[] = "SELECT {$sql_escape["mileageID"]} as mileageID ";
			}

			$sql  = "SELECT * ";
			$sql .= "FROM ( ";
			$sql .= "  SELECT * ";
			$sql .= "  FROM  (" . implode( " UNION ALL ", $sql_contract )  . ") as lc ";
			$sql .= "      , (" . implode( " UNION ALL ", $sql_paynum )  . ") as lp ";
			$sql .= "      , (" . implode( " UNION ALL ", $sql_mileage ) . ") as lm ";
			$sql .= ") as tbl ";
			$sql .= "ORDER BY contractID, paynumID, mileageID ";
			$tbl = (array)sql_query( $sql );

			// 車種リストの取得
			unset($sql);
			$sql  = "SELECT mk.makerCode ";
			$sql .= "     , mk.makerName ";
			$sql .= "     , m.modelCode ";
			$sql .= "     , m.modelName ";
			$sql .= "     , cg.bodyModel ";
			$sql .= "     , cg.carGradeID ";
			$sql .= "     , cg.grade ";
			$sql .= "     , cg.driveSystem ";
			$sql .= "     , cg.taxIncludedPrice ";
			$sql .= "     , cg.carNameModel ";
			$sql .= "     , cg.transmissionType ";
			$sql .= "     , cg.maxCapacity ";
			$sql .= "     , cg.capacity ";
			$sql .= "     , cg.useFuel ";
			$sql .= "     , cg.totalEmission ";
			$sql .= "     , lv.contractID ";
			$sql .= "     , lv.paynumID ";
			$sql .= "     , lv.mileageID ";
			$sql .= "     , COALESCE(lv.residualValue, 0) AS residualValue ";
			$sql .= "     , COALESCE(lv.voluntaryInsurance, 0) AS voluntaryInsurance ";
            $sql .= "     , lv.MALfullModel ";
            $sql .= "     , lv.MALvehicleCode ";
			$sql .= "     , CASE ";
			$sql .= "         WHEN m.s2wdCarGradeID = cg.carGradeID THEN 1 ";
			$sql .= "         WHEN m.s4wdCarGradeID = cg.carGradeID THEN 1 ";
			$sql .= "         WHEN m.lowPriceCarGradeID = cg.carGradeID THEN 1 ";
			$sql .= "         ELSE 0 ";
			$sql .= "       END carGrade ";
			$sql .= "FROM ( ";
			$sql .= "   SELECT cg1.makerCode, cg1.modelCode, cg1.carGradeID , cg1.bodyModel ";
			$sql .= "     , cg1.grade ";
			$sql .= "     , cg1.driveSystem ";
			$sql .= "     , cg1.taxIncludedPrice ";
			$sql .= "     , cg1.carNameModel ";
			$sql .= "     , cg1.transmissionType ";
			$sql .= "     , cg1.maxCapacity ";
			$sql .= "     , cg1.capacity ";
			$sql .= "     , cg1.useFuel ";
			$sql .= "     , cg1.totalEmission ";
			$sql .= "   FROM {$DBName}.carGrade as cg1 , {$DBName}.carGrade as cg2 ";
			$sql .= "   WHERE cg1.carGradeID = cg2.carGradeID ";
			$sql .= "     AND cg1.makerCode = '{$sql_escape["makerCode"]}' ";
			$sql .= ") as cg ";
			$sql .= "LEFT JOIN {$DBName}.leaseValue AS lv ";
			$sql .= "  ON cg.carGradeID = lv.carGradeID ";
			$sql .= " AND cg.makerCode = lv.makerCode ";
			$sql .= " AND cg.modelCode = lv.modelCode ";
			$sql .= ", {$DBName}.model as m ";
			$sql .= ", {$DBName}.maker as mk ";
			$sql .= "WHERE m.modelCode = cg.modelCode ";
			$sql .= "  AND m.makerCode = cg.makerCode ";
			$sql .= "  AND cg.makerCode = mk.makerCode ";
			$sql .= "ORDER BY cg.modelCode, cg.carGradeID ";
			$tmpList = (array)sql_query( $sql );

			$lictCnt = 0;
			for( $i = 0; $i < count($tmpList); $i++ ){
				// ボディタイプから車検期間を取得
				$bodyModel = get_bodyTypeInfo( $tmpList[$i]["bodyModel"] );
				$carInspectionFeeInfo = $ini["lease"]["carInspectionFee"][ $bodyModel["lease"] ];
				$tmpList[$i]["carInspection_years"]    = $carInspectionFeeInfo["years"];
				$tmpList[$i]["carInspection_nextYear"] = $carInspectionFeeInfo["nextYear"];

				// 車両本体価格(税抜き)
				$tmpList[$i]["taxIncludedPrice"] = round($tmpList[$i]["taxIncludedPrice"] / ( 1 + ( $ini["consumptionTax"] / 100 )));

				// 新たに追加されたグレードに項目を追加する
				if( $tmpList[$i]["contractID"] <> "" ){
					$list[$lictCnt] = $tmpList[$i];
					$lictCnt++;
				} else {
					for( $j = 0; $j < count($tbl); $j++ ){
						$list[$lictCnt] = $tmpList[$i];

						foreach( $tbl[$j] as $key => $val ){
							$list[$lictCnt][$key] = $val;
						}
						$lictCnt++;
					}
				}
			}

			return $list;
		}


		/*----------------------------------------------------
		    全グレード・リース料(調達価格・諸税・メンテ区分)リスト取得
		----------------------------------------------------*/
		function get_leaseList ( $input ) {

			global $ini;

			if( empty($input["makerCode"]) ){
				return;
			}

			// SQLインジェクション対応
			$sql_escape["makerCode"] = sql_escapeString($input["makerCode"]);

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// 車種リストの取得
			$sql  = "SELECT tbl.* ";
			$sql .= "     , COALESCE(l.procurementCost, 0) as procurementCost  ";
			$sql .= "     , COALESCE(l.costLegal, 0) as costLegal  ";
			$sql .= "     , COALESCE(l.costActing, 0) as costActing  ";
			$sql .= "     , COALESCE(l.costManagement, 0) as costManagement  ";
			$sql .= "     , mt.mainteID  ";
			$sql .= "     , mt.mainteState  ";
			$sql .= "FROM ( ";
			$sql .= "  SELECT mk.makerCode  ";
			$sql .= "       , mk.makerName  ";
			$sql .= "       , mk.dispNum  ";
			$sql .= "       , m.modelCode  ";
			$sql .= "       , m.modelName  ";
			$sql .= "       , cg.carGradeID  ";
			$sql .= "       , cg.grade  ";
			$sql .= "       , cg.driveSystem  ";
			$sql .= "       , cg.taxIncludedPrice  ";
			$sql .= "       , cg.carNameModel  ";
			$sql .= "       , cg.transmissionType  ";
			$sql .= "       , cg.maxCapacity  ";
			$sql .= "       , cg.capacity  ";
			$sql .= "       , cg.useFuel  ";
			$sql .= "       , cg.totalEmission  ";
			$sql .= "       , cg.bodyModel  ";
			$sql .= "       , cg.engineKind  ";
			$sql .= "       , cg.useFuelID  ";
			$sql .= "       , cg.motorKind  ";
			$sql .= "       , cg.voltageRating  ";
			$sql .= "       , cg.type  ";
			$sql .= "       , CASE cg.carGradeID  ";
			$sql .= "          WHEN m.s2wdCarGradeID THEN 1  ";
			$sql .= "          WHEN m.s4wdCarGradeID THEN 1  ";
			$sql .= "          WHEN m.lowPriceCarGradeID THEN 1 "; 
			$sql .= "          ELSE 0  ";
			$sql .= "         END carGrade  ";
			$sql .= "  FROM {$DBName}.carGrade as cg ,{$DBName}.model as m ,{$DBName}.maker AS mk  ";
			$sql .= "  WHERE cg.makerCode = m.makerCode  ";
			$sql .= "    AND cg.modelCode = m.modelCode  ";
			$sql .= "    AND m.makerCode = mk.makerCode  ";
			$sql .= "    AND mk.makerCode = {$sql_escape["makerCode"]} ";
			$sql .= ") as tbl ";
			$sql .= "LEFT JOIN {$DBName}.lease as l  ";
			$sql .= "  ON tbl.carGradeID = l.carGradeID  ";
			$sql .= "  AND tbl.makerCode = l.makerCode  ";
			$sql .= "  AND tbl.modelCode = l.modelCode  ";
			$sql .= "LEFT JOIN {$DBName}.maintenance AS mt  ";
			$sql .= "  ON tbl.carGradeID = mt.carGradeID  ";
			$sql .= " AND tbl.makerCode = mt.makerCode  ";
			$sql .= " AND tbl.modelCode = mt.modelCode  ";
			$sql .= "ORDER BY tbl.modelCode, tbl.carGradeID ";
			$list = (array)sql_query( $sql );

			for( $i = 0; $i < count($list); $i++ ){
				// ボディタイプから車検期間を取得
				$bodyModel = get_bodyTypeInfo( $list[$i]["bodyModel"] );
				$carInspectionFeeInfo = $ini["lease"]["carInspectionFee"][ $bodyModel["lease"] ];
				$list[$i]["carInspection_years"]    = $carInspectionFeeInfo["years"];
				$list[$i]["carInspection_nextYear"] = $carInspectionFeeInfo["nextYear"];

				// 車両本体価格(税抜き)
				$list[$i]["taxIncludedPrice"] = round($list[$i]["taxIncludedPrice"] / ( 1 + ( $ini["consumptionTax"] / 100 )));

				// メンテナンス区分の仮設定
				if( empty($list[$i]["mainteID"]) ){
					$list[$i]["mainteID"]    = $this->get_mainteID($list[$i]);
					$list[$i]["mainteState"] = 0;
				}
			}
			return $list;
		}

		/*----------------------------------------------------
		    メンテナンス区分の取得
		----------------------------------------------------*/
		function get_mainteID ( $input ) {

			global $ini;

			// 対象外のチェック
			for( $i = 0; $i < count($ini["mainteExcluded"]); $i++ ){
				if( $input["makerCode"] == $ini["mainteExcluded"][$i]["makerCode"] ){
					if( empty($ini["mainteExcluded"][$i]["modelCode"]) ){
						$mainteExcludedFlg = 1;
					} else if( $input["modelCode"] == $ini["mainteExcluded"][$i]["modelCode"] ) {
						$mainteExcludedFlg = 1;
					}
				}
			}

			if( $mainteExcludedFlg ){
				// 対象外
				$mainteID = $ini["mainteExcludedID"];

			} else { 
				//対象
				$useFuel  = array(
					 "R" => array("R", "H", "L")
					,"D" => array("D")
					,"E" => array("E", "T")
				);

				// 区分毎にまとめ
				for( $i = 0; $i < count($ini["maintenanceFee"]); $i++ ){
					$tmp_type    = $ini["maintenanceFee"][$i]["type"];
					$tmp_useFuel = $ini["maintenanceFee"][$i]["useFuel"];
					$tmp_hv      = $ini["maintenanceFee"][$i]["hv"];
					$arrType[$tmp_type][$tmp_useFuel][$tmp_hv][] = $ini["maintenanceFee"][$i];
				}


				// 燃料区分の確認
				if( in_array($input["useFuelID"], $useFuel["R"]) ){
					// レギュラー、ハイオク、LPE
					$useFuelName = "R";
				} else if( in_array($input["useFuelID"], $useFuel["D"]) ) {
					// 軽油
					$useFuelName = "D";
				} else if( in_array($input["useFuelID"], $useFuel["E"]) ){
					// その他
					$useFuelName = "E";
				}

				// ハイブリッドの確認(燃料が電機以外で定格電圧がある)
				$flg["hv"] = 0;

				if( ($useFuelName != "E" && $input["voltageRating"]) || 
					( $input["engineKind"] <> "" && $input["engineKind"] <> "-" && $input["motorKind"] <> "" && $input["motorKind"] <> "-" ) ){
					$flg["hv"] = 1;
				}

				// ボディタイプの識別名取得
				switch( $input["bodyModel"] ){
					case 3  :	// 軽乗用車
					case 14 :	// 軽乗用車（トール）
						$typeName = "light";
						break;

					case 9  :	// 軽バン
					case 10 :	// 軽トラック
						$typeName = "lightCargo";
						break;

					case 11 :	// 商用貨物（小型）
					case 15 :	// 商用貨物（普通）
					case 12 :	// 商用トラック
						$typeName = "cargo";
						break;

					default :	// コンパクトカー、ミニバン、セダン、ワゴン、クーペ、SUV、オープン
						if( $useFuelName == "E" && $input["type"] == "小型" ){
							$typeName = "lightPassengerUse";
						} else {
							$typeName = "passengerUse";
						}


						break;
				}

				// 排気量による絞り込み
				$checkArr = $arrType[$typeName][$useFuelName][$flg["hv"]];
				for( $i = 0; $i < count($checkArr); $i++ ){
					if( isset($checkArr[$i]["totalEmissionFrom"]) && isset($checkArr[$i]["totalEmissionTo"]) ){
						if( $input["totalEmission"] >= $checkArr[$i]["totalEmissionFrom"] && $input["totalEmission"] <= $checkArr[$i]["totalEmissionTo"] ){
							$tmp_checkMnt[] = $checkArr[$i];

						} else if( $input["totalEmission"] >= $checkArr[$i]["totalEmissionFrom"] && empty($checkArr[$i]["totalEmissionTo"]) ){
							$tmp_checkMnt[] = $checkArr[$i];

						}
					} else {
						$tmp_checkMnt[] = $checkArr[$i];
					}
				}

				if( count($tmp_checkMnt) > 1 && $input["type"] == "小型" ){
					$typeName = "lightPassengerUse";
				} else {
					$typeName = "passengerUse";
				}
				
				$mainteID = $tmp_checkMnt[0]["id"];
			}

			// メンテ区分が設定されなかった場合、対象外とする。
			if( empty($mainteID) ){
				$mainteID = $ini["mainteExcludedID"];
			}

			return $mainteID;
		}

		/*----------------------------------------------------
		    ガソリン価格取得
		----------------------------------------------------*/
		function get_gasolineList ( $input ) {

			global $ini;

			// ＤＢ名取得
			$DBName = get_DBName( "base" );

			// 車種リストの取得
			$sql  = "SELECT * ";
			$sql .= "FROM {$DBName}.gasoline ";
			$sql .= "ORDER BY regionID ";
			$list = (array)sql_query( $sql );

			for($i=0; $i<count( $list ); $i++){
				$list[$i]["regionName"] = $ini['prefecture'][$list[$i]["regionID"]]['name'];
			}

			return $list;
		}


		/*----------------------------------------------------
		    オプションリスト取得
		----------------------------------------------------*/
		function get_leaseOptionList ( $input ) {

			global $ini;

			if( empty($input["makerCode"]) ){
				return;
			}

			// SQLインジェクション対応
			$sql_escape["makerCode"] = sql_escapeString($input["makerCode"]);

			// ＤＢ名取得
			$DBName      = get_DBName( "work" );
			$DBName_base = get_DBName( "base" );

			// 登録済みのオプション最大数を取得する
			$sql  = "SELECT optionItem, max(optionID) as cnt ";
			$sql .= "FROM {$DBName_base}.leaseOption ";
			$sql .= "GROUP BY optionItem ";
			$tmp_optionMax = sql_query( $sql );

			// 件数の調整
			for( $i = 0, $iMax = count($tmp_optionMax); $i < $iMax; $i++ ){
				$optionMax[$tmp_optionMax[$i]["optionItem"]] = $tmp_optionMax[$i]["cnt"];
			}
			for( $i = 0, $iMax = count($ini["lease"]["optionItem"]); $i < $iMax; $i++ ){
				$optionItemKey = $ini["lease"]["optionItem"][$i]["id"];
				if( !isset($optionMax[$optionItemKey]) ){
					$optionMax[$optionItemKey] = $ini["lease"]["optionItem"][$i]["cnt"];
				}
			}

			for( $i = 0, $iMax = count($optionMax); $i < $iMax; $i++ ){
				unset($sql,$sql_option);
				$sql_escape["i"]   = sql_escapeString($i);

				// リストの作成
				for($j=0; $j<$optionMax[$i]; $j++){
					$sql_escape["j"] = sql_escapeString($j);
					$sql_option[] = "SELECT {$sql_escape["j"]} + 1 as optionID , {$sql_escape["i"]} as optionItem ";
				}

				$sql  = "SELECT tbl{$sql_escape["i"]}.makerCode ";
				$sql .= "     , tbl{$sql_escape["i"]}.makerName ";
				$sql .= "     , tbl{$sql_escape["i"]}.modelCode ";
				$sql .= "     , tbl{$sql_escape["i"]}.modelName ";
				$sql .= "     , COALESCE(lo.optionItem, {$sql_escape["i"]}) as optionItem ";
				$sql .= "     , tbl{$i}.optionID ";
				$sql .= "     , COALESCE(lo.optionName, '') as optionName ";
				$sql .= "     , COALESCE(lo.optionDescription, '') as optionDescription ";
				$sql .= "     , COALESCE(lo.taxIncludedPrice, 0) as taxIncludedPrice ";
				$sql .= "     , COALESCE(lo.procurementCost, 0) as procurementCost ";
				$sql .= "     , COALESCE(lo.campaignFlg, 0) as campaignFlg ";
				$sql .= "FROM (  ";
				$sql .= "   SELECT optionID, mk.makerCode, mk.makerName, m.modelCode, m.modelName, optionItem ";
				$sql .= "   FROM (  ";
				$sql .=        implode( " UNION ALL ", $sql_option );
				$sql .= "   ) as tbl ";
				$sql .= "   , {$DBName}.maker as mk , {$DBName}.model as m ";
				$sql .= "   WHERE mk.makerCode = m.makerCode ";
				$sql .= "     AND mk.makerCode = {$sql_escape["makerCode"]} ";
				$sql .= ") as tbl{$sql_escape["i"]} ";
				$sql .= "LEFT JOIN {$DBName_base}.leaseOption as lo ";
				$sql .= "ON tbl{$sql_escape["i"]}.optionID = lo.optionID AND tbl{$sql_escape["i"]}.makerCode = lo.makerCode AND tbl{$sql_escape["i"]}.modelCode = lo.modelCode AND tbl{$sql_escape["i"]}.optionItem = lo.optionItem ";
				$sql_list[] = $sql;
			}
			
			$sql  = implode( " UNION ALL ", $sql_list );
			$sql .= "ORDER BY makerCode, modelCode, optionItem, optionID ";
			$list = (array)sql_query( $sql );

			// おすすめオプション名の設定
			for( $i = 0, $iMax = count($ini["leasePreset"]["option"]); $i < $iMax; $i++ ){
				$optionName[$ini["leasePreset"]["option"][$i]["id"]] = $ini["leasePreset"]["option"][$i]["name"];
			}
			for( $i = 0, $iMax = count($list); $i < $iMax; $i++ ){
				if( $list[$i]["optionItem"] == 0 ){
					$list[$i]["optionName"] = $optionName[$list[$i]["optionID"]];

				}
			}
			return $list;
		}

		/*----------------------------------------------------
			   ファイル名取得
		----------------------------------------------------*/
		function get_fileName ( $input ) {

			// ＤＢ名取得
			$DBName = get_DBName( "base" );

			// 集計開始日
			unset( $year );
			unset( $month );
			unset( $day );

			// 集計開始日が指定されている
			if( $input["downloadInfo"]["from"]["date"] != "" ) {
				list( $year, $month, $day ) = explode( "/", $input["downloadInfo"]["from"]["date"] );
			}
			// 登録されている最も古いデータを取得
			else{
				$sql1 = "SELECT searchDatetime FROM {$DBName}.searchLog ORDER BY searchDatetime LIMIT 1";
				$tbl1 = sql_query( $sql1, "single" );
				$fromDatetime = db2val_datetime( $tbl1["searchDatetime"] );
				$year  = $fromDatetime["year"];
				$month = $fromDatetime["month"];
				$day   = $fromDatetime["day"];
			}

			// 集計開始日名取得
			$year  = sprintf( "%02d", substr( $year, 2, 2 ) );
			$month = sprintf( "%02d", $month );
			$day   = sprintf( "%02d", $day );

			$formDate = "$year$month$day";

			// 集計終了日
			unset( $year );
			unset( $month );
			unset( $day );

			// 集計終了日が指定されている
			if( $input["downloadInfo"]["to"]["date"] != "" ) {
				list( $year, $month, $day ) = explode( "/", $input["downloadInfo"]["to"]["date"] );
			}
			// 登録されている最も古いデータを取得
			else{
				$sql2 = "SELECT searchDatetime FROM {$DBName}.searchLog ORDER BY searchDatetime DESC LIMIT 1";
				$tbl2 = sql_query( $sql2, "single" );
				$toDatetime = db2val_datetime( $tbl2["searchDatetime"] );
				$year  = $toDatetime["year"];
				$month = $toDatetime["month"];
				$day   = $toDatetime["day"];
			}

			// 集計終了日名取得
			$year  = sprintf( "%02d", substr( $year, 2, 2 ) );
			$month = sprintf( "%02d", $month );
			$day   = sprintf( "%02d", $day );

			$toDate = "$year$month$day";


			// 種別？またはグレード別？
			if( $input["downloadInfo"]["outputType"] == 1 ) {
				$typeName = "車種別";
			} else{
				$typeName = "検索条件別";
			}

			// 名前作成
			$ret = "{$formDate}～{$toDate}検索結果_{$typeName}.csv";

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

	}


?>