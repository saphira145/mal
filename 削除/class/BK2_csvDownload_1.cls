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
			$sql  = "SELECT searchLog.makerName, searchLog.modelName, COUNT(searchLogID) as count , dispNum ";
			$sql .= "FROM {$DBName}.searchLog ";
			$sql .= "LEFT JOIN {$activeDBName}.maker ON searchLog.makerCode = maker.makerCode ";
			$sql .= "{$sql_where} ";
			$sql .= "GROUP BY searchLog.makerCode, searchLog.modelCode ";
			$sql .= "ORDER BY count DESC, maker.dispNum IS NULL, maker.dispNum, modelName ";
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
			$sql  = "SELECT mk.makerCode, mk.makerName, m.modelCode, m.modelName ";
			$sql .= "FROM {$DBName}.model AS m ";
			$sql .= "INNER JOIN {$DBName}.maker AS mk ON mk.makerCode = m.makerCode ";
			$sql .= "ORDER BY mk.dispNum , m.modelName ";
			$modelList = (array)sql_query( $sql );

			// 各車種毎にバリュー情報を取得
			for( $i = 0, $iMax = count($modelList); $i < $iMax; $i++ ){
				// SQLインジェクション対応
				$sql_escape["makerCode"] = sql_escapeString($modelList[$i]["makerCode"]);
				$sql_escape["modelCode"] = sql_escapeString($modelList[$i]["modelCode"]);

				$sql  = "SELECT tm.themeID, tm.themeName, ct.themeID is not null as flgOnOff ";
				$sql .= "FROM {$DBName}.themeMst AS tm ";
				$sql .= "LEFT JOIN {$DBName}.carTheme AS ct ON tm.themeID = ct.themeID AND ct.makerCode = '{$sql_escape["makerCode"]}' AND ct.modelCode = '{$sql_escape["modelCode"]}' ";
				$sql .= "WHERE tm.statusType = 100 ";
				$sql .= "ORDER BY tm.dispNum ";
				$themeList = (array)sql_query( $sql );

				// リスト作成
				$list[] = array_merge($modelList[$i], array("theme" => $themeList));
			}


			return $list;
		}


		/*----------------------------------------------------
		    全グレード・リース料(残価・調達価格)リスト取得
		----------------------------------------------------*/
		function get_leaseValueList ( $input ) {
			global $ini;

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
			$sql .= "FROM  (" . implode( " UNION ALL ", $sql_contract )  . ") as lc ";
			$sql .= "    , (" . implode( " UNION ALL ", $sql_paynum )  . ") as lp ";
			$sql .= "    , (" . implode( " UNION ALL ", $sql_mileage ) . ") as lm ";
			$sql .= "ORDER BY contractID, paynumID, mileageID ";
			$tbl = (array)sql_query( $sql );

			// 車種リストの取得
			unset($sql);
			$sql  = "SELECT mk.makerCode ";
			$sql .= " , mk.makerName ";
			$sql .= " , m.modelCode ";
			$sql .= " , m.modelName ";
			$sql .= " , cg.bodyModel ";
			$sql .= " , cg.carGradeID ";
			$sql .= " , cg.grade ";
			$sql .= " , cg.driveSystem ";
			$sql .= " , cg.taxIncludedPrice ";
			$sql .= " , cg.carNameModel ";
			$sql .= " , cg.transmissionType ";
			$sql .= " , cg.maxCapacity ";
			$sql .= " , cg.capacity ";
			$sql .= " , cg.useFuel ";
			$sql .= " , cg.totalEmission ";
			$sql .= " , CASE ";
			$sql .= "      WHEN cg.carGradeID = m.s2wdCarGradeID THEN 1 ";
			$sql .= "      WHEN cg.carGradeID = m.s4wdCarGradeID THEN 1 ";
			$sql .= "      WHEN cg.carGradeID = m.lowPriceCarGradeID THEN 1 ";
			$sql .= "      ELSE 0 ";
			$sql .= "   END carGrade ";
			$sql .= " , lv.contractID ";
			$sql .= " , lv.paynumID ";
			$sql .= " , lv.mileageID ";
			$sql .= " , COALESCE(lv.residualValue, 0) AS residualValue ";
			$sql .= " , COALESCE(lv.voluntaryInsurance, 0) AS voluntaryInsurance ";
			$sql .= "FROM {$DBName}.carGrade AS cg ";
			$sql .= "INNER JOIN {$DBName}.model AS m  ON cg.makerCode = m.makerCode  AND cg.modelCode = m.modelCode ";
			$sql .= "INNER JOIN {$DBName}.maker AS mk ON cg.makerCode = mk.makerCode ";
			$sql .= "LEFT JOIN {$DBName}.leaseValue AS lv ON cg.carGradeID = lv.carGradeID AND cg.makerCode = lv.makerCode AND cg.modelCode = lv.modelCode ";
			$sql .= "ORDER BY mk.dispNum , m.modelCode, cg.carGradeID, lv.contractID , lv.paynumID , lv.mileageID ";
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
		    全グレード・リース料(調達価格・諸税)リスト取得
		----------------------------------------------------*/
		function get_leaseList ( $input ) {

			global $ini;

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// 車種リストの取得
			$sql  = "SELECT mk.makerCode ";
			$sql .= " , mk.makerName ";
			$sql .= " , m.modelCode ";
			$sql .= " , m.modelName ";
			$sql .= " , cg.carGradeID ";
			$sql .= " , cg.grade ";
			$sql .= " , cg.driveSystem ";
			$sql .= " , cg.taxIncludedPrice ";
			$sql .= " , cg.carNameModel ";
			$sql .= " , cg.transmissionType ";
			$sql .= " , cg.maxCapacity ";
			$sql .= " , cg.capacity ";
			$sql .= " , cg.useFuel";
			$sql .= " , cg.totalEmission ";
			$sql .= " , COALESCE(l.procurementCost, 0) as procurementCost ";
			$sql .= " , COALESCE(l.costLegal, 0) as costLegal ";
			$sql .= " , COALESCE(l.costActing, 0) as costActing ";
			$sql .= " , COALESCE(l.costManagement, 0) as costManagement ";
			$sql .= " , mt.mainteID ";
			$sql .= " , mt.mainteState ";
			$sql .= " , cg.bodyModel ";
			$sql .= " , cg.engineKind";
			$sql .= " , cg.useFuelID ";
			$sql .= " , cg.motorKind";
			$sql .= " , cg.voltageRating ";
			$sql .= " , cg.type ";
			$sql .= " , CASE cg.carGradeID ";
			$sql .= "      WHEN m.s2wdCarGradeID THEN 1 ";
			$sql .= "      WHEN m.s4wdCarGradeID THEN 1 ";
			$sql .= "      WHEN m.lowPriceCarGradeID THEN 1 ";
			$sql .= "      ELSE 0 ";
			$sql .= "   END carGrade ";
			$sql .= "FROM {$DBName}.carGrade as cg ";
			$sql .= "LEFT JOIN {$DBName}.lease as l ON cg.carGradeID = l.carGradeID AND cg.makerCode = l.makerCode AND cg.modelCode = l.modelCode ";
			$sql .= "INNER JOIN {$DBName}.model as m  ON cg.makerCode = m.makerCode  AND cg.modelCode = m.modelCode ";
			$sql .= "INNER JOIN {$DBName}.maker AS mk ON cg.makerCode = mk.makerCode ";
			$sql .= "LEFT JOIN {$DBName}.maintenance AS mt ON cg.carGradeID = mt.carGradeID AND cg.makerCode = mt.makerCode AND cg.modelCode = mt.modelCode ";
			$sql .= "ORDER BY mk.dispNum , m.modelCode, cg.carGradeID ";
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
			$sql  = "SELECT *";
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
				$sql .= "   , {$DBName}.model as m  ";
				$sql .= "   LEFT JOIN {$DBName}.maker as mk ON mk.makerCode = m.makerCode ";
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