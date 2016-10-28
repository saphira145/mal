<?php

	class consistencyAdmin_1 {

	/*----------------------------------------------------
	    コンストラクタ
	----------------------------------------------------*/
		function consistencyAdmin_1 () {
		}


		/*----------------------------------------------------
		   車種グレードの取得
		----------------------------------------------------*/
		function get_carGradeList(){
			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			$sql  = "SELECT * ";
			$sql .= "FROM {$DBName}.carGrade ";
			$sql .= "ORDER BY makerCode, modelCode, carGradeID";
			$list = sql_query( $sql );

			for( $i = 0, $iMax = count($list); $i < $iMax; $i++ ){
				$key = $list[$i]["makerCode"] . "_" . $list[$i]["modelCode"];
				$ret[$key][$list[$i]["carGradeID"]] = $list[$i];
			}

			return $ret;
		}


		/*----------------------------------------------------
		   車種の取得
		----------------------------------------------------*/
		function get_modelList( $DB="work" ){
			// ＤＢ名取得
			$DBName = get_DBName( $DB );

			$sql  = "SELECT tbl.* ";
			$sql .= "FROM ";
			$sql .= "( SELECT  mk.makerName ";
			$sql .= "     , mk.dispNum ";
			$sql .= "     , m.* ";
			$sql .= "  FROM {$DBName}.model AS m , {$DBName}.maker AS mk ";
			$sql .= "  WHERE mk.makerCode = m.makerCode ";
			$sql .= ") as tbl ";
			$sql .= "ORDER BY tbl.dispNum , tbl.modelName ";
			$ret  = (array)sql_query( $sql );

			return $ret;
		}


		/*----------------------------------------------------
		   メンテナンス区分の取得
		----------------------------------------------------*/
		function get_maintenanceList(){
			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			$sql  = "SELECT * ";
			$sql .= "FROM {$DBName}.maintenance ";
			$list = (array)sql_query( $sql );

			for( $i = 0, $iMax = count($list); $i < $iMax; $i++ ){
				$key = $list[$i]["makerCode"] . "_" . $list[$i]["modelCode"];
				$ret[$key][$list[$i]["carGradeID"]] = $list[$i];
			}

			return $ret;
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
			$ret  = (array)sql_query( $sql );

			return $ret;
		}


		/*----------------------------------------------------
		   テーマチェック対象の取得
		----------------------------------------------------*/
		function get_carThemeList(){

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			$sql  = "SELECT * ";
			$sql .= "FROM {$DBName}.carTheme ";
			$list = (array)sql_query( $sql );

			for( $i = 0, $iMax = count($list); $i < $iMax; $i++ ){
				$key = $list[$i]["makerCode"] . "_" . $list[$i]["modelCode"];
				$ret[$key][$list[$i]["themeID"]] = $list[$i];
			}

			return $ret;
		}


		/*----------------------------------------------------
		   新型車チェック対象の取得
		----------------------------------------------------*/
		function get_newCarList( $lixtCnt=3 , $DB="work" ){

			// ＤＢ名取得
			$DBName_base = get_DBName( "base" );

			// SQLインジェクション対応
			$sql_escape["lixtCnt"] = sql_escapeString($lixtCnt);

			// チェックデータの取得(配列)
			$sql  = "SELECT * ";
			$sql .= "FROM {$DBName_base}.newCar ";
			$sql .= "ORDER BY newCarNum LIMIT {$sql_escape["lixtCnt"]}";
			$ret  = (array)sql_query( $sql );

			return $ret;
		}


		/*----------------------------------------------------
		   リース料情報の取得
		----------------------------------------------------*/
		function get_leaseCnt(){

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			$sql   = "SELECT carGradeID, makerCode, modelCode, CASE WHEN count(carGradeID) > 0 THEN 1 ELSE 0 END as cnt ";
			$sql  .= "FROM {$DBName}.leaseValue ";
			$sql  .= "GROUP BY carGradeID, makerCode, modelCode ";
			$list1 = (array)sql_query( $sql );

			for( $i = 0, $iMax = count($list1); $i < $iMax; $i++ ){
				$key = $list1[$i]["makerCode"] . "_" . $list1[$i]["modelCode"];
				$ret[$key][$list1[$i]["carGradeID"]]["leaseValue"] = $list1[$i]["cnt"];
			}

			$sql   = "SELECT carGradeID, makerCode, modelCode, CASE WHEN count(carGradeID) > 0 THEN 1 ELSE 0 END as cnt ";
			$sql  .= "FROM {$DBName}.lease ";
			$sql  .= "GROUP BY carGradeID, makerCode, modelCode ";
			$list2 = (array)sql_query( $sql );

			for( $i = 0, $iMax = count($list2); $i < $iMax; $i++ ){
				$key = $list2[$i]["makerCode"] . "_" . $list2[$i]["modelCode"];
				$ret[$key][$list2[$i]["carGradeID"]]["lease"] = $list2[$i]["cnt"];
			}

			return $ret;
		}


		/*----------------------------------------------------
		   リース料0円情報の取得
		----------------------------------------------------*/
		function get_leaseZero(){

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			//
			$sql   = "SELECT carGradeID, makerCode, modelCode, min(residualValue) as residualValue, min(voluntaryInsurance) as voluntaryInsurance ";
			$sql  .= "FROM {$DBName}.leaseValue ";
			$sql  .= "WHERE residualValue = 0 ";
			$sql  .= "   OR voluntaryInsurance = 0 ";
			$sql  .= "GROUP BY carGradeID, makerCode, modelCode ";
			$list1 = (array)sql_query( $sql );

			for( $i = 0, $iMax = count($list1); $i < $iMax; $i++ ){
				$key = $list1[$i]["makerCode"] . "_" . $list1[$i]["modelCode"];
				$ret[$key][$list1[$i]["carGradeID"]]["residualValue"] = $list1[$i]["residualValue"];
				$ret[$key][$list1[$i]["carGradeID"]]["voluntaryInsurance"] = $list1[$i]["voluntaryInsurance"];
			}

			$sql   = "SELECT carGradeID, makerCode, modelCode, min(procurementCost) as procurementCost, min(costLegal) as costLegal, min(costActing) as costActing, min(costManagement) as costManagement ";
			$sql  .= "FROM {$DBName}.lease ";
			$sql  .= "WHERE procurementCost = 0 ";
			$sql  .= "   OR costLegal = 0 ";
			$sql  .= "   OR costActing = 0 ";
			$sql  .= "   OR costManagement = 0 ";
			$sql  .= "GROUP BY carGradeID, makerCode, modelCode ";
			$list2 = (array)sql_query( $sql );

			for( $i = 0, $iMax = count($list2); $i < $iMax; $i++ ){
				$key = $list2[$i]["makerCode"] . "_" . $list2[$i]["modelCode"];
				$ret[$key][$list2[$i]["carGradeID"]]["procurementCost"] = $list2[$i]["procurementCost"];
				$ret[$key][$list2[$i]["carGradeID"]]["costLegal"]       = $list2[$i]["costLegal"];
				$ret[$key][$list2[$i]["carGradeID"]]["costActing"]      = $list2[$i]["costActing"];
				$ret[$key][$list2[$i]["carGradeID"]]["costManagement"]  = $list2[$i]["costManagement"];
			}

			return $ret;
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
		   車種グレードチェック
		----------------------------------------------------*/
		function check_carGrade( $modelData, $carGradeData, $DB="work" ){

			global $ini;

			if( !empty($carGradeData) ){
				// データチェック
				$noSetCnt = 0;
				$tmp_carGradeNum = 0;
				for( $i=0 , $iMax = count($ini["carGrade"]); $i < $iMax; $i++ ){
					unset($gradeCode);
					$tmp_carGradeID  = $ini["carGrade"][$i]["ID"];
					$gradeCode       = $modelData[$tmp_carGradeID];

					if( !empty($gradeCode) ){
						// グレードの存在確認
						if( empty($carGradeData[$gradeCode]) ){
							// 存在なし
							$logFlg = "g_unmatch";
							$ret[$tmp_carGradeNum]["ID"]    = $tmp_carGradeID;
							$ret[$tmp_carGradeNum]["KeyNo"] = $i;
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

			return array($logFlg, $ret);
		}


		/*----------------------------------------------------
		   ボディタイプチェック(テーマ)
		----------------------------------------------------*/
		function check_themeBodyType ( $modelData, $carGradeData, $bodyModel ) {

			global $ini;

			for( $i=0 , $iMax = count($ini["carGrade"]); $i < $iMax; $i++ ){
				unset($gradeCode);
				$tmp_carGradeID  = $ini["carGrade"][$i]["ID"];
				$gradeCode       = $modelData[$tmp_carGradeID];

				// ボディタイプの保持
				$key = $carGradeData[$gradeCode]["bodyModel"];
				if( $key ){
					$arrBodyModel[$key] = 1;
				}
			}

			// ボディタイプが一致しない
			if( !$arrBodyModel[$bodyModel] ){
				$logFlg = "b_unmatch";
			}

			return $logFlg;
		}


		/*----------------------------------------------------
		   メンテナンスチェック
		----------------------------------------------------*/
		function check_maintenance ( $modelData, $maintenanceData, $carGradeData ) {

			global $ini;

			// データチェック
			if( count($maintenanceData) > 0 ){
				$tmp_carGradeNum["mt_undefined"]    = 0;
				$tmp_carGradeNum["mt_undetermined"] = 0;
				for( $i=0 , $iMax = count($ini["carGrade"]); $i < $iMax; $i++ ){
					unset($gradeCode);
					$tmp_carGradeID  = $ini["carGrade"][$i]["ID"];
					$gradeCode       = $modelData[$tmp_carGradeID];

					if( !empty( $gradeCode ) ){
						if( !empty($carGradeData[$gradeCode]) ){
							// データチェック(メンテナンス区分)
							if( empty($maintenanceData[ $gradeCode ]["mainteID"]) ){
								$logFlg["mt_undefined"] = 1;

								$carGrade["mt_undefined"][$tmp_carGradeNum["mt_undefined"]]["ID"]    = $tmp_carGradeID;
								$carGrade["mt_undefined"][$tmp_carGradeNum["mt_undefined"]]["KeyNo"] = $i;
								$tmp_carGradeNum["mt_undefined"]++;

							} else if( empty($maintenanceData[ $gradeCode ]["mainteState"]) ){
								$logFlg["mt_undetermined"] = 1;
								$carGrade["mt_undetermined"][$tmp_carGradeNum["mt_undetermined"]]["ID"]    = $tmp_carGradeID;
								$carGrade["mt_undetermined"][$tmp_carGradeNum["mt_undetermined"]]["KeyNo"] = $i;
								$tmp_carGradeNum["mt_undetermined"]++;
							}
						}
					}
				}
			} else {
				// 存在なし
				$logFlg["mt_unmatch"] = 1;
			}

			return array($logFlg, $carGrade);
		}


		/*----------------------------------------------------
		   リース料チェック(代表車種グレードに残価が設定されているか確認)
		----------------------------------------------------*/
		function check_lease( $modelData, $leaseData, $carGradeData ) {

			global $ini;

			// データチェック
			$tmp_carGradeNum = 0;
			for( $i=0 , $iMax = count($ini["carGrade"]); $i < $iMax; $i++ ){
				unset($gradeCode);
				$tmp_carGradeID  = $ini["carGrade"][$i]["ID"];
				$gradeCode       = $modelData[$tmp_carGradeID];

				if( !empty( $gradeCode ) ){

					if( !empty($carGradeData[$gradeCode]) ){
						if( $leaseData[$gradeCode]["leaseValue"] == 0 || $leaseData[$gradeCode]["lease"] == 0){
							$logFlg = 1;
							$carGrade[$tmp_carGradeNum]["ID"]    = $tmp_carGradeID;
							$carGrade[$tmp_carGradeNum]["KeyNo"] = $i;
							$tmp_carGradeNum++;

							// 存在なし(調達価格、諸税)
							if( $leaseData[$gradeCode]["lease"] == 0 ){
								$lease["l_undefined"] = 1;
							}

							// 存在なし(残価、メンテ料)
							if( $leaseData[$gradeCode]["leaseValue"] == 0 ){
								$lease["lv_undefined"] = 1;
							}
						}
					}
				}
			}

			return array($logFlg, $carGrade, $lease);
		}


		/*----------------------------------------------------
		   リース料チェック(代表車種グレードに残価が設定されているか確認)
		----------------------------------------------------*/
		function check_leaseZero( $modelData, $leaseZeroData ){

			global $ini;

			if( empty($leaseZeroData) ){
				return array($logFlg, $lease);
			}

			// 0円チェック
			for( $i=0 , $iMax = count($ini["carGrade"]); $i < $iMax; $i++ ){
				unset($gradeCode);
				$tmp_carGradeID  = $ini["carGrade"][$i]["ID"];
				$gradeCode       = $modelData[$tmp_carGradeID];

				for( $j=0 , $jMax = count($ini["consistency"]["lease"]); $j < $jMax; $j++ ){
					$key = $ini["consistency"]["lease"][$j]["ID"];
					if( !empty( $gradeCode ) ){
						if( isset($leaseZeroData[$gradeCode][$key]) && empty($leaseZeroData[$gradeCode][$key]) ){
							$tmpKeyNo[] = $j;
						}
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
			$carGradeList = $this->get_carGradeList();

			global $ini;
			$list = array( 
						   array( "key" => 0, "list" => $input["noGradeCheckList"]             , "info" => array( "title" => "車種グレード"           , "DB" => "work" ))
						,  array( "key" => 1, "list" => $input["gradeCheckList"]               , "info" => array( "title" => "代表車種グレード"       , "DB" => "work" ))
						,  array( "key" => 2, "list" => $input["themeCheckList"]               , "info" => array( "title" => "バリュー(おすすめ車種)" , "DB" => "work" ))
						,  array( "key" => 3, "list" => $input["newCarCheckList"]["active"]    , "info" => array( "title" => "新型車チェック(active)" , "DB" => "active" ))
						,  array( "key" => 4, "list" => $input["newCarCheckList"]["work"]      , "info" => array( "title" => "新型車チェック(work)"   , "DB" => "work" ))
						,  array( "key" => 6, "list" => $input["maintenanceCheckList"]["mtum"] , "info" => array( "title" => "メンテナンス区分"       , "DB" => "work" ))
						,  array( "key" => 6, "list" => $input["maintenanceCheckList"]["mtuf"] , "info" => array( "title" => "メンテナンス区分"       , "DB" => "work" ))
						,  array( "key" => 6, "list" => $input["maintenanceCheckList"]["mtut"] , "info" => array( "title" => "メンテナンス区分"       , "DB" => "work" ))
						,  array( "key" => 5, "list" => $input["leaseCheckList"]["l"]          , "info" => array( "title" => "リース料"               , "DB" => "work" ))
						,  array( "key" => 5, "list" => $input["leaseCheckList"]["lv"]         , "info" => array( "title" => "リース料"               , "DB" => "work" ))
					);

			foreach( $list as $checkList ){
				if( count($checkList["list"]) == 0 ){
					continue;
				}

				for( $i=0 , $iMax = count($checkList["list"]); $i < $iMax; $i++ ){
					$tmp_listData = $checkList["list"][$i];

					// エラー区分の選別の設定
					switch( $tmp_listData["check"] ){
						case "g_unmatch"       : $msg = "モデルチェンジなどのデータ入替により、代表車種グレードに選ばれている車種グレードが無くなりました。";  break;
						case "g_undefined"     : $msg = "代表車種グレードが1つも選ばれていません。";                                                           break;
						case "g_nodata"        : $msg = "代表車種グレードが1つも選ばれていません。(車種グレード情報なし)";                                     break;
						case "g_nograde"       : $msg = "車種グレード情報が登録されていません。";                                                              break;
						case "m_undefined"     : $msg = "終売などのため、現在システムに登録されていません。";                                                  break;
						case "b_unmatch"       : $msg = "ボディタイプが異なります。";                                                                          break;
						case "t_undefined"     : $msg = "バリュー自動設定の選定基準から外れたため、該当バリューが設定されてません。";                          break;
						case "l_undefined"     : $msg = "調達価格・諸税(登録法定費用、資金管理料金など)が登録されていません。";                                break;
						case "lv_undefined"    : $msg = "残価・任意保険料が登録されていません。";                                                              break;
						case "mt_unmatch"      : $msg = "メンテナンス区分が登録されていません。";                                                              break;
						case "mt_undefined"    : $msg = "代表車種グレードのメンテナンス区分が登録されていません。";                                            break;
						case "mt_undetermined" : $msg = "代表車種グレードのメンテナンス区分が確定されていません。";                                            break;
					}
					$logList[] = "ERROR：【{$checkList["info"]["title"]}】 " . $msg;

					//基本情報の出力
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

					// 代表グレード情報の出力
					for( $j=0 , $jMax = count($ini["carGrade"]); $j < $jMax; $j++ ){
						unset($tmp, $gradeCode);
						$keyName   = $ini["carGrade"][$j]["ID"];
						$gradeCode = $tmp_listData["model"][$keyName];

						// グレード情報の取得
						if( !empty($gradeCode) ){
							$getKey = $tmp_listData["model"]["makerCode"] ."_" . $tmp_listData["model"]["modelCode"];
							$tmp["carGradeInfo"] = $carGradeList[$getKey][$gradeCode];

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

								case 5 :	// リース料
								case 6 :	// メンテナンス区分
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
						$logList[] = "  carGradeID" . " -> " . $gradeCode . $tmp["ngMark"];
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
			$logData  = date("Ymd\THis");
			$logUser  = $class["session"]->memberID;
			$fileName = "consistency_" . $logUser . "_" . $logData . ".log";

			//logファイルの保存先
			$filePath = $path["consistency"]["logDir"] . "/" . $fileName;

			// 開始
			$fp   = fopen( $filePath, "a" );
			$txts = "[".date("c")."] START";
			fputs( $fp, $txts . "\r\n" );
			fclose( $fp );

			// ログの出力
			for( $i = 0, $iMax = count($input); $i < $iMax; $i++ ){
				$fp   = fopen( $filePath, "a" );
				$txts = "[".date("c")."] " . $input[$i] ;
				fputs( $fp, $txts . "\r\n" );
				fclose( $fp );
			}

			// 終了
			$fp   = fopen( $filePath, "a" );
			$txts = "[".date("c")."] END" ;
			fputs( $fp, $txts . "\r\n" );
			fclose( $fp );

		}


	}

?>