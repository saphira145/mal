<?php


	class consistencyAdmin_1 {


	/*----------------------------------------------------
	    コンストラクタ
	----------------------------------------------------*/
		function consistencyAdmin_1 () {

		}


		/*----------------------------------------------------
		   代表車種グレードチェック対象の取得
		----------------------------------------------------*/
		function get_modelList(){
			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// チェック対象のデータ取得(全車種)
			$sql  = "SELECT mk.makerName, m.* ";
			$sql .= "FROM {$DBName}.model as m ";
			$sql .= "INNER JOIN {$DBName}.maker as mk on m.makerCode = mk.makerCode ";
			$sql .= "ORDER BY mk.dispNum, m.modelName ";
			$ret["list"] = (array)sql_query( $sql );
			
			return $ret["list"];
		}

		/*----------------------------------------------------
		   テーマチェック対象の取得
		----------------------------------------------------*/
		function get_themeList(){

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			$sql  = "SELECT * ";
			$sql .= "FROM {$DBName}.themeMst as tm, {$DBName}.themeRecommend as tr ";
			$sql .= "WHERE tm.statusType = '100' ";
			$sql .= "  AND tm.themeID = tr.themeID ";
			$sql .= "ORDER BY dispNum , tm.themeID, tr.bodyModel ";
			$ret["list"] = (array)sql_query( $sql );

			return $ret["list"];
		}

		/*----------------------------------------------------
		   新型車チェック対象の取得
		----------------------------------------------------*/
		function get_newCarList( $lixtCnt=3 , $DB="work" ){

			// ＤＢ名取得
			$DBName_base = get_DBName( "base" );
			$DBName      = get_DBName( $DB );

			// SQLインジェクション対応
			$sql_escape["lixtCnt"] = sql_escapeString($lixtCnt);

			// チェックデータの取得(配列)
			$sql  = "SELECT n.newCarNum, m.* ";
			$sql .= "FROM {$DBName_base}.newCar as n";
			$sql .= "   , {$DBName}.model as m ";
			$sql .= "WHERE n.makerCode = m.makerCode AND n.modelCode = m.modelCode ";
			$sql .= "ORDER BY newCarNum LIMIT {$sql_escape["lixtCnt"]}";
			$ret= (array)sql_query( $sql );
			return $ret;
		}

		/*----------------------------------------------------
		   グレード詳細情報の取得
		----------------------------------------------------*/
		function get_carGradeInfo( $carGradeID, $makerCode, $modelCode, $DB="work" ){

			if( empty($carGradeID) ){
				return null;
			}

			// ＤＢ名取得
			$DBName = get_DBName( $DB );

			// SQLインジェクション対応
			$sql_escape["carGradeID"] = sql_escapeString($carGradeID);
			$sql_escape["makerCode"]  = sql_escapeString($makerCode);
			$sql_escape["modelCode"]  = sql_escapeString($modelCode);

			$sql  = "SELECT * ";
			$sql .= "FROM {$DBName}.carGrade ";
			$sql .= "WHERE carGradeID = '{$sql_escape["carGradeID"]}' AND makerCode = '{$sql_escape["makerCode"]}' AND modelCode = '{$sql_escape["modelCode"]}'";
			$info = (array)sql_query( $sql, "single" );

			return $info;
		}


		/*----------------------------------------------------
		   リース料(残価・仕入れ値)情報の取得
		----------------------------------------------------*/
		function get_leaseCnt( $carGradeID, $makerCode, $modelCode, $DB="work" ){

			if( empty($carGradeID) ){
				return null;
			}

			// ＤＢ名取得
			$DBName = get_DBName( $DB );

			// SQLインジェクション対応
			$sql_escape["carGradeID"] = sql_escapeString($carGradeID);
			$sql_escape["makerCode"]  = sql_escapeString($makerCode);
			$sql_escape["modelCode"]  = sql_escapeString($modelCode);

			$sql  = "SELECT ( ";
			$sql .= "    SELECT CASE WHEN count(*) > 0 THEN 1 ELSE 0 END ";
			$sql .= "    FROM {$DBName}.leaseValue ";
			$sql .= "    WHERE carGradeID = '{$sql_escape["carGradeID"]}' AND makerCode = '{$sql_escape["makerCode"]}' AND modelCode = '{$sql_escape["modelCode"]}' ";
			$sql .= ") as leaseValue ";
			$sql .= ",( ";
			$sql .= "    SELECT CASE WHEN count(*) > 0 THEN 1 ELSE 0 END ";
			$sql .= "    FROM {$DBName}.lease ";
			$sql .= "    WHERE carGradeID = '{$sql_escape["carGradeID"]}' AND makerCode = '{$sql_escape["makerCode"]}' AND modelCode = '{$sql_escape["modelCode"]}' ";
			$sql .= ") as lease ";
			$info = sql_query( $sql, "single" );

			return $info;
		}


		/*----------------------------------------------------
		   代表車種グレードチェック(対象車種に代表車種グレードが設定されているか確認)
		----------------------------------------------------*/
		function check_carGrade( $input, $DB="work" ){

			global $ini;

			$makerCode = $input["makerCode"];
			$modelCode = $input["modelCode"];
			if( empty($makerCode) && empty($modelCode) ){
				return false;
			}

			// ＤＢ名取得
			$DBName = get_DBName( $DB );

			// SQLインジェクション対応
			$sql_escape["makerCode"] = sql_escapeString($makerCode);
			$sql_escape["modelCode"] = sql_escapeString($modelCode);

			// 車種グレードの存在確認(代表グレード以外も含む)
			$sql  = "SELECT count(*) as cnt ";
			$sql .= "FROM {$DBName}.carGrade as cg ";
			$sql .= "WHERE cg.makerCode = '{$sql_escape["makerCode"]}' AND cg.modelCode = '{$sql_escape["modelCode"]}' ";
			$ret  = sql_query( $sql , "single" );

			if( !empty($ret["cnt"]) ){
				// データチェック
				$noSetCnt = 0;
				$tmp_carGradeNum = 0;
				for( $i=0 , $iMax = count($ini["carGrade"]); $i < $iMax; $i++ ){
					$tmp_carGradeID  = $ini["carGrade"][$i]["ID"];

					if( !empty($input[$tmp_carGradeID]) ){
						// グレードの存在確認
						$tmp_carGradeInfo = $this->get_carGradeInfo($input[$tmp_carGradeID], $makerCode, $modelCode ,$DB );

						if( count( $tmp_carGradeInfo ) == 0 ){
							// 存在なし
							$logFlg = "g_unmatch";
							$carGrade[$tmp_carGradeNum]["ID"]    = $tmp_carGradeID;
							$carGrade[$tmp_carGradeNum]["KeyNo"] = $i;
							$tmp_carGradeNum++;
						}
					} else {
						// グレード設定なし
						$noSetCnt++;
					}
				}

				if($noSetCnt == count($ini["carGrade"])){
					// 代表グレード未設定
					$logFlg = "g_undefined";
				}
			} else {
				// グレードなし
				$logFlg = "g_nodata";
			}

			return array($logFlg, $carGrade);
		}


		/*----------------------------------------------------
		   車種の存在チェック
		----------------------------------------------------*/
		function check_model ( $input ) {

			if( count($input) == 0 ){
				$logFlg = "m_undefined";
			}
			return array($logFlg, $input);
		}


		/*----------------------------------------------------
		   メンテナンスチェック
		----------------------------------------------------*/
		function check_maintenance ( $input, $DB="work" ) {

			global $ini;

			$makerCode = $input["makerCode"];
			$modelCode = $input["modelCode"];
			if( empty($makerCode) && empty($modelCode) ){
				return false;
			}

			// ＤＢ名取得
			$DBName = get_DBName( $DB );

			// SQLインジェクション対応
			$sql_escape["makerCode"] = sql_escapeString($makerCode);
			$sql_escape["modelCode"] = sql_escapeString($modelCode);

			// 車種グレードの存在確認(代表グレード以外も含む)
			$sql     = "SELECT * ";
			$sql    .= "FROM {$DBName}.maintenance as mt ";
			$sql    .= "WHERE mt.makerCode = '{$sql_escape["makerCode"]}' AND mt.modelCode = '{$sql_escape["modelCode"]}' ";
			$tmpList = (array)sql_query( $sql );

			for( $i = 0; $i < count($tmpList); $i++ ){
				$list[ $tmpList[$i]["carGradeID"] ] = $tmpList[$i];
			}

			// データチェック
			if( count($list) > 0 ){
				$tmp_carGradeNum = 0;
				for( $i=0 , $iMax = count($ini["carGrade"]); $i < $iMax; $i++ ){
					$tmp_carGradeID  = $ini["carGrade"][$i]["ID"];

					if( !empty($input[$tmp_carGradeID]) ){
						// データチェック(メンテナンス区分)
						if( empty($list[ $input[$tmp_carGradeID] ]["mainteID"]) ){
							$logFlg["mt_undefined"] = 1;
						} else if( empty($list[ $input[$tmp_carGradeID] ]["mainteState"]) ){
							$logFlg["mt_undetermined"] = 1;
						}
					}

					if( !empty($logFlg) ){
						// 存在なし
						$carGrade[$tmp_carGradeNum]["ID"]    = $tmp_carGradeID;
						$carGrade[$tmp_carGradeNum]["KeyNo"] = $i;
						$tmp_carGradeNum++;
					}
				}
			} else {
				// 存在なし
				$logFlg["mt_unmatch"] = 1;
			}

			return array($logFlg, $carGrade);
		}


		/*----------------------------------------------------
		   ボディタイプチェック(テーマ)
		----------------------------------------------------*/
		function check_themeBodyType ( $makerCode, $modelCode, $bodyModel ) {

			global $ini;

			if( empty($makerCode) && empty($modelCode) ){
				return null;
			}

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// SQLインジェクション対応
			$sql_escape["makerCode"] = sql_escapeString($makerCode);
			$sql_escape["modelCode"] = sql_escapeString($modelCode);
			$sql_escape["bodyModel"] = sql_escapeString($bodyModel);

			// 車種データの取得
			$sql  = "SELECT * ";
			$sql .= "FROM {$DBName}.model as m ";
			$sql .= "INNER JOIN {$DBName}.carGrade as cg ON m.lowPriceCarGradeID = cg.carGradeID OR m.s2wdCarGradeID = cg.carGradeID OR m.s4wdCarGradeID = cg.carGradeID ";
			$sql .= "WHERE m.makerCode = '{$sql_escape["makerCode"]}' AND m.modelCode = '{$sql_escape["modelCode"]}' AND cg.bodyModel = '{$sql_escape["bodyModel"]}' ";
			$tbl  = (array)sql_query( $sql );

			// データチェック(対象車種無し)
			if( count($tbl) == 0 ){
				$logFlg = "b_unmatch";
			}

			return $logFlg;
		}


		/*----------------------------------------------------
		   テーマ設定チェック(テーマ)
		----------------------------------------------------*/
		function check_themeSet ( $themeID, $makerCode, $modelCode ) {

			global $ini;

			if( empty($themeID) && empty($makerCode) && empty($modelCode) ){
				return null;
			}

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// SQLインジェクション対応
			$sql_escape["makerCode"] = sql_escapeString($makerCode);
			$sql_escape["modelCode"] = sql_escapeString($modelCode);
			$sql_escape["themeID"]   = sql_escapeString($themeID);

			// 車種データの取得
			$sql  = "SELECT * ";
			$sql .= "FROM {$DBName}.carTheme ";
			$sql .= "WHERE makerCode = '{$sql_escape["makerCode"]}' AND modelCode = '{$sql_escape["modelCode"]}' AND themeID = '{$sql_escape["themeID"]}' ";
			$tbl  = (array)sql_query( $sql );

			// データチェック(対象車種無し)
			if( count($tbl) == 0 ){
				$logFlg = "t_undefined";

			}

			return $logFlg;
		}


		/*----------------------------------------------------
		   リース料チェック(代表車種グレードに残価が設定されているか確認)
		----------------------------------------------------*/
		function check_lease( $input, $DB="work" ){

			global $ini;

			$makerCode = $input["makerCode"];
			$modelCode = $input["modelCode"];
			if( empty($makerCode) && empty($modelCode) ){
				return false;
			}

			// データチェック
			$tmp_carGradeNum = 0;
			for( $i=0 , $iMax = count($ini["carGrade"]); $i < $iMax; $i++ ){
				$tmp_carGradeID  = $ini["carGrade"][$i]["ID"];

				if( !empty($input[$tmp_carGradeID]) ){
					// グレード、リース料の存在確認
					$tmp_leaseCnt    = $this->get_leaseCnt($input[$tmp_carGradeID], $makerCode, $modelCode ,$DB );

					if( $tmp_leaseCnt["leaseValue"] == 0 || $tmp_leaseCnt["lease"] == 0){
						$logFlg = "l_undefined";
						$carGrade[$tmp_carGradeNum]["ID"]    = $tmp_carGradeID;
						$carGrade[$tmp_carGradeNum]["KeyNo"] = $i;
						$tmp_carGradeNum++;

						// 存在なし(調達価格、諸税)
						if( $tmp_leaseCnt["lease"] == 0 ){
							$lease["l_undefined"] = 1;
						}

						// 存在なし(残価、メンテ料)
						if( $tmp_leaseCnt["leaseValue"] == 0 ){
							$lease["lv_undefined"] = 1;
						}

					}
				}
			}

			return array($logFlg, $carGrade, $lease);
		}


		/*----------------------------------------------------
		   リース料チェック(代表車種グレードに残価が設定されているか確認)
		----------------------------------------------------*/
		function check_leaseZero( $input, $DB="work" ){

			global $ini;

			$makerCode = $input["makerCode"];
			$modelCode = $input["modelCode"];
			if( empty($makerCode) && empty($modelCode) ){
				return false;
			}

			// ＤＢ名取得
			$DBName = get_DBName( $DB );

			for( $i=0 , $iMax = count($ini["carGrade"]); $i < $iMax; $i++ ){
				$sql_escape["carGradeID"] = sql_escapeString($ini["carGrade"][$i]["ID"]);
				$sql_escape["gradeID"]    = sql_escapeString($i);

				$tmp_sql   = "SELECT m.{$sql_escape["carGradeID"]} ";
				$tmp_sql  .= "     , lv.contractID ";
				$tmp_sql  .= "     , lv.payNumID ";
				$tmp_sql  .= "     , lv.mileageID ";
				$tmp_sql  .= "     , m.makerCode ";
				$tmp_sql  .= "     , m.modelCode ";
				$tmp_sql  .= "     , l.procurementCost ";
				$tmp_sql  .= "     , lv.voluntaryInsurance ";
				$tmp_sql  .= "     , l.costLegal ";
				$tmp_sql  .= "     , l.costActing ";
				$tmp_sql  .= "     , l.costManagement ";
				$tmp_sql  .= "     , lv.residualValue ";
				$tmp_sql  .= "     , '{$sql_escape["gradeID"]}' as gradeID ";
				$tmp_sql  .= "     , '{$sql_escape["carGradeID"]}' as grade ";
				$tmp_sql  .= "FROM {$DBName}.leaseValue as lv ";
				$tmp_sql  .= "   , {$DBName}.model as m ";
				$tmp_sql  .= "   , {$DBName}.lease as l ";
				$tmp_sql  .= "WHERE m.{$sql_escape["carGradeID"]} = lv.carGradeID AND lv.makerCode = m.makerCode AND lv.modelCode = m.modelCode ";
				$tmp_sql  .= "  AND m.{$sql_escape["carGradeID"]} = l.carGradeID AND lv.makerCode = l.makerCode AND lv.modelCode = l.modelCode ";

				$sql_list[] = $tmp_sql;
			}

			if( !empty( $sql_list ) ){
				$sql_union = "" . @implode( " UNION ", $sql_list );

				// SQLインジェクション対応
				$sql_escape["makerCode"] = sql_escapeString($makerCode);
				$sql_escape["modelCode"] = sql_escapeString($modelCode);

				$sql   = "SELECT * ";
				$sql  .= "FROM ( {$sql_union} ) as tbl ";
				$sql  .= "WHERE tbl.makerCode = '{$sql_escape["makerCode"]}' ";
				$sql  .= "  AND tbl.modelCode = '{$sql_escape["modelCode"]}' ";
				$sql  .= "ORDER BY gradeID, contractID , payNumID, mileageID ";
				$tmp_leaseInfo  = (array)sql_query( $sql );
			}

			for( $i=0 , $iMax = count($tmp_leaseInfo); $i < $iMax; $i++ ){
				for( $j=0 , $jMax = count($ini["consistency"]["lease"]); $j < $jMax; $j++ ){
					$key = $ini["consistency"]["lease"][$j]["ID"];
					if( empty($tmp_leaseInfo[$i][$key]) ){
						// 0円あり
						$tmpKeyNo[] = $j;
					}
				}
			}

			if( count($tmpKeyNo) > 0 ){
				$logFlg = "l_zero";
				$lease["keyNameNo"] = array_unique($tmpKeyNo);
			}
			return array($logFlg, $lease);
		}




		/*----------------------------------------------------
		   ログ出力用データ作成
		----------------------------------------------------*/
		function convert_logData( $input ){

			global $ini;
			$list   = array(   array( "key" => 0, "list" => $input["noGradeCheckList"]             , "info" => array( "title" => "車種グレード"           , "DB" => "work" ))
							,  array( "key" => 1, "list" => $input["gradeCheckList"]               , "info" => array( "title" => "代表車種グレード"       , "DB" => "work" ))
							,  array( "key" => 2, "list" => $input["themeCheckList"]               , "info" => array( "title" => "バリュー(おすすめ車種)" , "DB" => "work" ))
							,  array( "key" => 3, "list" => $input["newCarCheckList"]["active"]    , "info" => array( "title" => "新型車チェック(active)" , "DB" => "active" ))
							,  array( "key" => 4, "list" => $input["newCarCheckList"]["work"]      , "info" => array( "title" => "新型車チェック(work)"   , "DB" => "work" ))
							,  array( "key" => 5, "list" => $input["leaseCheckList"]["l"]          , "info" => array( "title" => "リース料"               , "DB" => "work" ))
							,  array( "key" => 5, "list" => $input["leaseCheckList"]["lv"]         , "info" => array( "title" => "リース料"               , "DB" => "work" ))
							,  array( "key" => 6, "list" => $input["maintenanceCheckList"]["mtum"] , "info" => array( "title" => "メンテナンス区分"       , "DB" => "work" ))
							,  array( "key" => 6, "list" => $input["maintenanceCheckList"]["mtut"] , "info" => array( "title" => "メンテナンス区分"       , "DB" => "work" ))
							,  array( "key" => 6, "list" => $input["maintenanceCheckList"]["mtut"] , "info" => array( "title" => "メンテナンス区分"       , "DB" => "work" ))
						);

			foreach( $list as $checkList ){

				if( count($checkList["list"]) == 0 ){
					continue;
				}

				for( $i=0 , $iMax = count($checkList["list"]); $i < $iMax; $i++ ){
					$tmp_listData = $checkList["list"][$i];

					/*-- エラー区分の選別の設定 --*/
					switch( $tmp_listData["check"] ){
						case "g_unmatch"       : $msg = "モデルチェンジなどのデータ入替により、代表車種グレードに選ばれている車種グレードが無くなりました。";  break;
						case "g_undefined"     : $msg = "代表車種グレードが1つも選ばれていません。";                                                           break;
						case "g_nodata"        : $msg = "代表車種グレードが1つも選ばれていません。(車種グレード情報なし)";                                     break;
						case "g_nograde"       : $msg = "車種グレード情報が登録されていません。";                                                              break;
						case "m_undefined"     : $msg = "終売などのため、現在システムに登録されていません。";                                                  break;
						case "b_unmatch"       : $msg = "ボディタイプが異なります。";                                                                          break;
						case "t_undefined"     : $msg = "バリュー自動設定の選定基準から外れたため、該当バリューが設定されてません。";                          break;
						case "l_undefined"     : $msg = "調達価格・諸税(登録法定費用、資金管理料金など)が登録されていません。";                                break;
						case "lv_undefined"    : $msg = "残価・任意保険料が登録されていません。";                                                                break;
						case "mt_unmatch"      : $msg = "代表車種グレードのメンテナンス区分が登録されていません。";                                                              break;
						case "mt_undefined"    : $msg = "代表車種グレードのメンテナンス区分が確定されていません。";                                                              break;
						case "mt_undetermined" : $msg = "代表車種グレードのメンテナンス区分が設定されていません。";                                                              break;
					}
					$logList[] = "ERROR：【{$checkList["info"]["title"]}】 " . $msg;

					/*-- 基本情報の出力 --*/
					switch( $checkList["key"] ){
						case 0 :	// 車種グレード
						case 1 :	// 代表車種グレード
						case 3 :	// 新型車チェック(active)
						case 4 :	// 新型車チェック(work)
						case 5 :	// リース料
						case 6 :	// メンテナンス区分
									$logList[] = " makerCode" . " -> " . $tmp_listData["model"]["makerCode"] . " (" . $tmp_listData["model"]["makerName"] . ")";
									$logList[] = " modelCode" . " -> " . $tmp_listData["model"]["modelCode"] . " (" . $tmp_listData["model"]["modelName"] . ")";
									break;

						case 2 :	// バリュー(おすすめ車種)
									$logList[] = " themeID         " . " -> " . $tmp_listData["theme"]["themeID"]   . " (" . $tmp_listData["theme"]["themeName"] . ")";
									$logList[] = " bodyType        " . " -> " . $tmp_listData["bodyType"]["num"]    . " (" . $tmp_listData["bodyType"]["name"] . ")";
									$logList[] = " basisOfSelection" . " -> " . str_replace(array("\r\n", "\r", "\n"), "", $tmp_listData["theme"]["basisOfSelection"]);
									$logList[] = " makerCode       " . " -> " . $tmp_listData["model"]["makerCode"] . " (" . $tmp_listData["model"]["makerName"] . ")";
									$logList[] = " modelCode       " . " -> " . $tmp_listData["model"]["modelCode"] . " (" . $tmp_listData["model"]["modelName"] . ")";
									break;
					}

					/*-- 代表グレード情報の出力 --*/
					for( $j=0 , $jMax = count($ini["carGrade"]); $j < $jMax; $j++ ){
						unset($tmp);
						$keyName = $ini["carGrade"][$j]["ID"];

						// グレード情報の取得
						if( !empty($tmp_listData["model"][$keyName]) ){
							$tmp["carGradeInfo"] = $this->get_carGradeInfo($tmp_listData["model"][$keyName], $tmp_listData["model"]["makerCode"], $tmp_listData["model"]["modelCode"], $checkList["info"]["DB"]);

							// エラー対象の判定
							switch( $checkList["key"] ){
								case 0 :	// 車種グレード
								case 1 :	// 代表車種グレード
								case 2 :	// バリュー(おすすめ車種)
								case 3 :	// 新型車チェック(active)
								case 4 :	// 新型車チェック(work)
									if( !empty($tmp_listData["carGrade"][$j]) ){
										$tmp["ngMark"]  = " [No data]";
									} else {
										$tmp["tmpModelInfo"]["makerCode"] = $tmp["carGradeInfo"]["makerCode"] . " (" . $tmp["carGradeInfo"]["makerName"] . ")";
										$tmp["tmpModelInfo"]["modelCode"] = $tmp["carGradeInfo"]["modelCode"] . " (" . $tmp["carGradeInfo"]["modelName"] . ")";
										$tmp["tmpModelInfo"]["bodyType"]  = $tmp["carGradeInfo"]["bodyModel"] . " (" . $tmp["carGradeInfo"]["bodyModelName"] . ")";

										if( $tmp_listData["bodyType"]["num"] && $tmp_listData["bodyType"]["num"] != $tmp["carGradeInfo"]["bodyModel"] ){
											$tmp["unmatchMark"]  = " [unmatch]";
										}
									}
									break;

								case 6 :	// メンテナンス区分
									$tmp["tmpModelInfo"]["makerCode"] = $tmp["carGradeInfo"]["makerCode"] . " (" . $tmp["carGradeInfo"]["makerName"] . ")";
									$tmp["tmpModelInfo"]["modelCode"] = $tmp["carGradeInfo"]["modelCode"] . " (" . $tmp["carGradeInfo"]["modelName"] . ")";
									$tmp["tmpModelInfo"]["bodyType"]  = $tmp["carGradeInfo"]["bodyModel"] . " (" . $tmp["carGradeInfo"]["bodyModelName"] . ")";
									break;

								case 5 :	// リース料
									if( !empty($tmp_listData["carGrade"][$j]) ){
										$tmp["ngMark"]  = " [Not set]";
									}

									$tmp["tmpModelInfo"]["makerCode"] = $tmp["carGradeInfo"]["makerCode"] . " (" . $tmp["carGradeInfo"]["makerName"] . ")";
									$tmp["tmpModelInfo"]["modelCode"] = $tmp["carGradeInfo"]["modelCode"] . " (" . $tmp["carGradeInfo"]["modelName"] . ")";
									$tmp["tmpModelInfo"]["bodyType"]  = $tmp["carGradeInfo"]["bodyModel"] . " (" . $tmp["carGradeInfo"]["bodyModelName"] . ")";
									break;

							}
						}

						// グレード情報の出力
						$logList[] = " {$keyName}";
						$logList[] = "  carGradeID" . " -> " . $tmp_listData["model"][$keyName] . $tmp["ngMark"];
						$logList[] = "  makerCode " . " -> " . $tmp["tmpModelInfo"]["makerCode"];
						$logList[] = "  modelCode " . " -> " . $tmp["tmpModelInfo"]["modelCode"];
						$logList[] = "  bodyType  " . " -> " . $tmp["tmpModelInfo"]["bodyType"] . $tmp["unmatchMark"];
					}
				}
			}

			return $logList;

		}



		/*----------------------------------------------------
		   ログ出力
		----------------------------------------------------*/
		function output_logData( $input, $logDatetime, $memberID ){

			global $path, $class;

			//logファイル名生成
			$logData  = date('Ymd\THis');
			$logUser  = $class["session"]->memberID;
			$fileName = "consistency_" . $logUser . "_" . $logData . ".log";

			//logファイルの保存先
			$filePath = $path["consistency"]["logDir"] . "/" . $fileName;

			// 開始
			$fp   = fopen( $filePath, "a" );
			$txts = "[".date('c')."] START";
			fputs( $fp, $txts . "\r\n" );
			fclose( $fp );

			// ログの出力
			for( $i = 0, $iMax = count($input); $i < $iMax; $i++ ){
				$fp   = fopen( $filePath, "a" );
				$txts = "[".date('c')."] " . $input[$i] ;
				fputs( $fp, $txts . "\r\n" );
				fclose( $fp );
			}

			// 終了
			$fp   = fopen( $filePath, "a" );
			$txts = "[".date('c')."] END" ;
			fputs( $fp, $txts . "\r\n" );
			fclose( $fp );

		}


	}

?>