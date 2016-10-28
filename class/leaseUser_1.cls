<?php
require_once('Math/Finance.php');

	class leaseUser_1 {

		/*----------------------------------------------------
		    コンストラクタ
		----------------------------------------------------*/
		function leaseUser_1 () {

		}

		/*----------------------------------------------------
		  利益額からリース料を算出
		----------------------------------------------------*/
		function get_profit_by_lease( $input, $profit  ){

			// 初期設定
			global $ini;
			$cnt       = 0;
			$maxCnt    = 10000;
			$finishPay = 0;

			// キャッシュOUT(現在価値)の取得
			$cacheOut = $this->get_cacheOutPV($input, $input["carAddDate"]);

			// キャッシュIN(現在価値)の取得：初回
			$pay      = 0;
			$cacheIn  = $this->get_cacheInPV($input , $pay, $input["carAddDate"]);
			$shortage = ( $cacheOut["total_pv"] + $profit) - $cacheIn["total_pv"];

			// リース料の算出(利益額を超えるまで処理を繰り返す)
			$pay      = round($shortage / $input["info"]["paynum"]["num"], -2);
			$cacheIn  = $this->get_cacheInPV($input , $pay, $input["carAddDate"]);
			$shortage = ( $cacheOut["total_pv"] + $profit) - $cacheIn["total_pv"];


			while ( $shortage > 0 ) {

				// 無限ループ回避の為、一定回数を超えたら終了とする
				if( $cnt >= $maxCnt ){
					$pay = 0;
					break;
				}

				// 一定金額増加させ、利益額を超えるリース料を探す
				$cnt++;
				$pay     += 100;
				$cacheIn  = $this->get_cacheInPV($input , $pay, $input["carAddDate"]);
				$shortage = ( $cacheOut["total_pv"] + $profit) - $cacheIn["total_pv"];
			}

			// ファイナンス
			$info["financial"]       = $pay;
			$info["financial_total"] = $pay * $input["info"]["paynum"]["num"];

			// 残価・メンテ料
			$keyID    =  $input["info"]["contract"]["id"] . "_" . $input["info"]["paynum"]["id"] .  $input["info"]["mileage"]["id"];
			$info["residualValue"]     = $input["data"]["leaseInfo"]["residualValue"][$keyID];
			$info["maintenance"]       = $input["data"]["leaseInfo"]["maintenance"][$keyID];
			$info["maintenance_total"] = $info["maintenance"] * $input["info"]["paynum"]["num"];
			$info["mainteID"]          = $input["data"]["leaseInfo"]["mainteID"];

			// リース料
			$info["lease"]       = $info["financial"] + $info["maintenance"];
			$info["lease_total"] = $info["financial_total"] + $info["maintenance_total"];

			// 利益率
			$info["rate"] = 0;
			if( $cacheIn["total"] != 0 && $cacheIn["total_pay"] != 0){
				$info["rate"] = round(($cacheIn["total_pv"] - $cacheOut["total_pv"] ) / $cacheIn["total_pay"] * 100, 2);
			}

			// 内部利益率 (IRR; Internal Rate of Return)
			$info["irr"] = $this->get_irr($cacheOut["irrList"], $cacheIn["irrList"]);

			// 利ざや
			if( $input["data"]["leaseInfo"]["vehicleFee"][ $input["info"]["msrp"]["disp"] ] != 0 ){
				$info["margins"] = round($info["lease"] / $input["data"]["leaseInfo"]["vehicleFee"][ $input["info"]["msrp"]["disp"] ]* 100, 2);
			}

			// 合計
			$info["out"]    = $cacheOut["total"];
			$info["out_pv"] = $cacheOut["total_pv"];
			$info["in"]     = $cacheIn["total"];
			$info["in_pv"]  = $cacheIn["total_pv"];

			// 利益額
			$info["profit"]  = $profit + ( $shortage * -1);

			// 諸税
			$info["taxes"]            = $cacheOut["taxes"];
			$info["tonnageTax"]       = $cacheOut["tonnageTax"];
			$info["automobileTax"]    = $cacheOut["automobileTax"];
			$info["insurancePremium"] = $cacheOut["insurancePremium"];

			return $info;
		}


		/*----------------------------------------------------
		  リース料から利益額・利益率を算出
		----------------------------------------------------*/
		function get_lease_by_profit( $input, $lease ){

			// 初期設定
			global $ini;
			$finishProfit = 0;

			// キャッシュOUT(現在価値)の取得
			$cacheOut = $this->get_cacheOutPV($input, $input["carAddDate"]);

			// キャッシュIN(現在価値)の取得
			$cacheIn  = $this->get_cacheInPV($input, $lease, $input["carAddDate"]);

			// リース料
			$info["lease"]       = $lease;
			$info["lease_total"] = $lease * $input["info"]["paynum"]["num"];

			// 残価・メンテ料
			$keyID    =  $input["info"]["contract"]["id"] . "_" .  $input["info"]["paynum"]["id"] .  $input["info"]["mileage"]["id"];
			$info["residualValue"]     = $input["data"]["leaseInfo"]["residualValue"][$keyID];
			$info["maintenance"]       = $input["data"]["leaseInfo"]["maintenance"][$keyID];
			$info["maintenance_total"] = $info["maintenance"] * $input["info"]["paynum"]["num"];
			$info["mainteID"]          = $input["info"]["mainteID"];

			// ファイナンス
			$info["financial"]       = $info["lease"] - $info["maintenance"];
			$info["financial_total"] = $info["lease_total"] - $info["maintenance_total"];

			// 利益額の算出
			$info["profit"] = $cacheIn["total_pv"] - $cacheOut["total_pv"];

			// 利益率
			$info["rate"] = 0;
			if( $cacheIn["total"] != 0 && $cacheIn["total_pay"] != 0 ){
				$info["rate"] = round($info["profit"]  / $cacheIn["total_pay"] * 100, 2);
			}

			// 内部利益率 (IRR; Internal Rate of Return)
			$info["irr"]  = $this->get_irr($cacheOut["irrList"], $cacheIn["irrList"]);

			// 利ざや
			if( $input["data"]["leaseInfo"]["vehicleFee"][ $input["info"]["msrp"]["disp"] ] != 0 ){
				$info["margins"] = round($info["lease"] / $input["data"]["leaseInfo"]["vehicleFee"][ $input["info"]["msrp"]["disp"] ]* 100, 2);
			}

			// 合計
			$info["out"]    = $cacheOut["total"];
			$info["out_pv"] = $cacheOut["total_pv"];
			$info["in"]     = $cacheIn["total"];
			$info["in_pv"]  = $cacheIn["total_pv"];

			// 諸税
			$info["taxes"]            = $cacheOut["taxes"];
			$info["tonnageTax"]       = $cacheOut["tonnageTax"];
			$info["automobileTax"]    = $cacheOut["automobileTax"];
			$info["insurancePremium"] = $cacheOut["insurancePremium"];

			return $info;
		}



		/*----------------------------------------------------
		  利益率の算出
		----------------------------------------------------*/
		function get_irr( $cacheOutList, $cacheInList ){

			// 初期設定
			$finishIrr = 0;


			$cashFlow = array();
			for( $i = 0; $i < count($cacheInList); $i++){
				$cashFlow[] = (-1 * $cacheOutList[$i]) + $cacheInList[$i];
			}

			$irr = Math_Finance::internalRateOfReturn($cashFlow, 0.01);

			if( is_numeric($irr)  ){
				$finishIrr = round($irr * 12 * 100, 2);
			}

			return $finishIrr;
		}


		/*----------------------------------------------------
		  燃料費の算出
		----------------------------------------------------*/
		function get_fuelCost( $input, $lease){

			// 区分別
			switch( $input["useFuelID"] ){
				case "H" : //ハイオク
							$gasoline = $lease["gasoline"]["highOctaneGasoline"];  
							break;
				case "R" : //レギュラー
							$gasoline = $lease["gasoline"]["regularGasoline"];  
							break;
				case "D" : //軽油
							$gasoline = $lease["gasoline"]["dieselGasoline"];  
							break;
				default  : // それ以外
							$gasoline = 0;
							break;
			}

			if( !empty( $gasoline ) && !empty($input["fuelConsumptionRateJC08mode"]) ){
				$fuelCost = $lease["mileage"]["distance"] / $input["fuelConsumptionRateJC08mode"] * $gasoline;
			}

			return $fuelCost;
		}


		/*----------------------------------------------------
		  キャッシュIN(現在価値)の取得
		  $carAddDate ：登録年月(YYYYMM)
		----------------------------------------------------*/
		function get_cacheInPV( $input , $pay , $carAddDate ){

			// 初期設定
			global $ini;

			$leaseInfo     = $input["info"];
			$leaseData     = $input["data"]["leaseInfo"];
			$irrList       = array_pad(array(), $leaseInfo["paynum"]["num"]+1 , 0);

			// サイト作成
			for( $i = 0, $iMax = $leaseInfo["paynum"]["num"]+1; $i <= $iMax; $i++ ){
				$year  = substr($carAddDate, 0, 4);
				$month = substr($carAddDate, 4, 2);
				
				$term[] = array( "term" => $i, "year" => $year, "month" => $month );

				// 翌月
				$carAddDate = date("Ymd",strtotime( $carAddDate . "+1 month"));
			}

			// リース料
			for( $i = 1, $iMax = $leaseInfo["paynum"]["num"]; $i <= $iMax; $i++ ){
				$term[$i]["in"][]    = $pay;
				$term[$i]["title"][] = "リース料";
			}

			// 残価
			$keyID =  $leaseInfo["contract"]["id"] . "_" .  $leaseInfo["paynum"]["id"] .  $leaseInfo["mileage"]["id"];
			$term[ $leaseInfo["paynum"]["num"]+1 ]["in"][] = $leaseData["residualValue"][$keyID];
			$term[ $leaseInfo["paynum"]["num"]+1 ]["title"][] = "残価";

			// 使用するサイトのみ
			unset($ret);
			for( $i = 0, $iMax = $leaseInfo["paynum"]["num"]+1; $i <= $iMax; $i++ ){
				$outSum = 0;

				if( $term[$i]["in"] ){
					$outSum = array_sum($term[$i]["in"]);


					$term[$i]["sum"]    = $outSum;
					$term[$i]["sum_pv"] = $this->get_PVInfoSubTotal($outSum, $leaseInfo["interestRates"]["in"], $i);

					$ret["list"][]     = $term[$i];
					$ret["total"]     += $term[$i]["sum"];
					$ret["total_pv"]  += $term[$i]["sum_pv"];
				}
				$ret["irrList"][] = $outSum;
			}


			// リース料
			for( $i = 1, $iMax = $leaseInfo["paynum"]["num"]; $i <= $iMax; $i++ ){
				$ret["total_pay"] += $pay;
			}

			return $ret;

		}



		/*----------------------------------------------------
		  キャッシュOUT(現在価値)の取得
		  $carAddDate ：登録年月(YYYYMM)
		----------------------------------------------------*/
		function get_cacheOutPV( $input, $carAddDate ){

			global $ini;

			$leaseInfo     = $input["info"];
			$leaseData     = $input["data"]["leaseInfo"];
			$leaseOption   = $input["data"]["leaseOption"];
			$irrList       = array_pad(array(), $leaseInfo["paynum"]["num"]+1 , 0);

			// サイト作成
			for( $i = 0, $iMax = $leaseInfo["paynum"]["num"]+1; $i <= $iMax; $i++ ){
				$year  = substr($carAddDate, 0, 4);
				$month = substr($carAddDate, 4, 2);
				$term[] = array( "term" => $i, "year" => $year, "month" => $month );

				// 翌月
				$carAddDate = date("Ymd",strtotime( $carAddDate . "+1 month"));
			}

			// サイト0(自動車取得税、重量税、自賠責保険、登録法定費用、登録代行費用、資金管理料金)
			$term[0]["out"][] = $leaseData["acquisitionTax"];				// 自動車取得税
			$term[0]["out"][] = $leaseData["tonnageTax"]["years"];			// 重量税
			$term[0]["out"][] = $leaseData["insurancePremium"]["years"];	// 自賠責保険
			$term[0]["out"][] = $leaseData["costLegal"];					// 登録法定費用
			$term[0]["out"][] = $leaseData["costActing"];					// 登録代行費用
			$term[0]["out"][] = $leaseData["costManagement"];				// 資金管理料金

			$term[0]["title"][] = "自動車取得税";
			$term[0]["title"][] = "重量税(初回)";
			$term[0]["title"][] = "自賠責保険(初回)";
			$term[0]["title"][] = "登録法定費用";
			$term[0]["title"][] = "登録代行費用";
			$term[0]["title"][] = "資金管理料金";

			$ret["tonnageTax"]       += $leaseData["tonnageTax"]["years"];
			$ret["insurancePremium"] += $leaseData["insurancePremium"]["years"];

			// サイト0(自動車税)
			$monthCnt     = 0;
			for( $i = 0; $i < 12; $i++ ){
				if( $term[$i]["month"] == 3 ){
					break;
				}
				$monthCnt++;
				
			}
			if( $monthCnt != 0 && $leaseData["carInspectionFee"]["insurance"] != "light" ){
				$automobileTax = floor(($leaseData["automobileTax"]["years"] * $monthCnt / 12) / 100) * 100;
				$term[0]["out"][] = $automobileTax;
				$term[0]["title"][] = "自動車税(" . $monthCnt . "ヶ月)";
				$ret["automobileTax"] += $automobileTax;
			}

			// 自動車税(4月のサイト)
			
			for( $i = 1, $iMax = $leaseInfo["paynum"]["num"]+1; $i <= $iMax; $i++ ){
				if( $term[$i]["month"] == $ini["lease"]["automobileTaxTermMonth"]  ){
					if( $automobileTaxCnt > 0 ){
						// 通常
						$term[$i]["out"][]   = $leaseData["automobileTax"]["nextYear"];
						$ret["automobileTax"]     += $leaseData["automobileTax"]["nextYear"];

					} else {
						// グリーン化
						$term[$i]["out"][]   = $leaseData["automobileTax"]["nextYearGreen"];
						$ret["automobileTax"]     += $leaseData["automobileTax"]["nextYearGreen"];

					}
					$automobileTaxCnt++;
					$term[$i]["title"][] = "自動車税(12ヵ月)";
					$lastTerm = $setTerm;
				}
			}

			// 自動車税(超過分)
			$term[$leaseInfo["paynum"]["num"]+1]["out"][]   = $leaseData["automobileTax"]["last"];
			$term[$leaseInfo["paynum"]["num"]+1]["title"][] = "自動車税(戻し)";
			$ret["automobileTax"]      += $leaseData["automobileTax"]["last"];

			// サイト2(車両代、オプション代)
			$term[2]["out"][] = $leaseData["vehicleFee"][ $leaseInfo["msrp"]["disp"] ];
			$term[2]["title"][] = "車両代";
			$term[2]["out"][] = $leaseOption[ $leaseInfo["msrp"]["disp"] ];
			$term[2]["title"][] = "オプション代";

			// 車検(重量税、自賠責保険)
			$years         = $leaseInfo["paynum"]["num"] / 12;
			$startYear     = $leaseData["carInspectionFee"]["years"];
			$nextYear      = $leaseData["carInspectionFee"]["nextYear"];
			$checkYear     = $nextYear;
			$tonnageTaxCnt = 0;

			for( $i = $startYear; $i < $years; $i++ ){
				if( $checkYear == $nextYear ){
					$payNum = $i * 12;

					// 自賠責
					$term[$payNum]["out"][] = $leaseData["insurancePremium"]["nextYear"];
					$term[$payNum]["title"][] = "自賠責保険(2回目以降)";

					// 重量税(2回目と2回目以降で異なる)
					if( $tonnageTaxCnt == 0 ){
						$term[$payNum]["out"][] = $leaseData["tonnageTax"]["nextYear"];
						$term[$payNum]["title"][] = "重量税(2回目)";
						$tonnageTaxCnt++;
					} else {
						$term[$payNum]["out"][] = $leaseData["tonnageTax"]["nextYears"];
						$term[$payNum]["title"][] = "重量税(2回目以降)";
					}


					$checkYear = 1;
				} else {
					$checkYear++;
				}
			}

			// 使用するサイトのみ
			for( $i = 0, $iMax = $leaseInfo["paynum"]["num"]+1; $i <= $iMax; $i++ ){
				$outSum      = 0;
				$pv_outSum   = 0;
				$maintenance = 0;

				// 合計
				if( $term[$i]["out"] ){
					$outSum    = array_sum($term[$i]["out"]);
					$pv_outSum = $this->get_PVInfoSubTotal($outSum, $leaseInfo["interestRates"]["out"], $i);
				}

				$ret["list"][]    = $term[$i];
				$ret["total"]    += $outSum;
				$ret["total_pv"] += $pv_outSum;
				$ret["irrList"][] = $outSum;
			}

			// 諸税
			$ret["taxes"] = $ret["total"] - $leaseData["vehicleFee"][ $leaseInfo["msrp"]["disp"] ];

			return $ret;
		}



		/*----------------------------------------------------
		  現在価値(合計)の算出
		----------------------------------------------------*/
		function get_PVInfoTotal($fv, $rates, $term){

			$sum = 0;
			for ($i = 1; $i <= $term; $i++) {
				$pv   = $fv / pow((1 + $rates), $i);
				$sum += $pv;
			}

			return $sum;
		}


		/*----------------------------------------------------
		  現在価値(小計)の算出
		----------------------------------------------------*/
		function get_PVInfoSubTotal($fv, $rates, $term){

			$ret = $fv / pow((1 + $rates), $term);

			return $ret;
		}


		/*----------------------------------------------------
		  車種情報(リース計算)の取得
		----------------------------------------------------*/
		function get_leaseCarInfo( $input, $lease, $DB = "active"){
			global $ini,$path;

			// ＤＢ名取得
			$DBName = get_DBName($DB);

			// SQLインジェクション対応
			$sql_escape["carGradeID"] = sql_escapeString($input["carGradeID"]);
			$sql_escape["makerCode"]  = sql_escapeString($input["makerCode"]);
			$sql_escape["modelCode"]  = sql_escapeString($input["modelCode"]);

			// 車種情報
			$sql        = "SELECT * ";
			$sql       .= "FROM {$DBName}.carGrade as cg ";
			$sql       .= "LEFT JOIN {$DBName}.lease as l ON cg.carGradeID = l.carGradeID AND cg.makerCode = l.makerCode AND cg.modelCode = l.modelCode ";
			$sql       .= "LEFT JOIN {$DBName}.maintenance as mt ON cg.carGradeID = mt.carGradeID AND cg.makerCode = mt.makerCode AND cg.modelCode = mt.modelCode ";
			$sql       .= "WHERE cg.carGradeID = '{$sql_escape["carGradeID"]}' ";
			$sql       .= "  AND cg.makerCode  = '{$sql_escape["makerCode"]}' ";
			$sql       .= "  AND cg.modelCode  = '{$sql_escape["modelCode"]}' ";
			$modelInfo = sql_query( $sql, "single" );

			if( count($modelInfo) == 0 ){
				return;
			}

			// ボディタイプから車検情報の取得
			$bodyModel = get_bodyTypeInfo( $modelInfo["bodyModel"] );
			$carInspectionFeeInfo = $ini["lease"]["carInspectionFee"][ $bodyModel["lease"] ];
			$term["years"]    = 12 * $carInspectionFeeInfo["years"] + 1;
			$term["nextYear"] = 12 * $carInspectionFeeInfo["nextYear"];

			// 車種情報(通常)
			// 車両代(車両価格、調達価格)：税抜き
			$info["leaseInfo"]["vehicleFee"]["taxIncludedPrice"] = round($modelInfo["taxIncludedPrice"] / ( 1 + ( $ini["consumptionTax"] / 100 )));
			$info["leaseInfo"]["vehicleFee"]["procurementCost"]  = $modelInfo["procurementCost"];
			
			// 自動車税(初回、2回目以降)：車両区分によって初回の自動車税が変化
			if( $carInspectionFeeInfo["insurance"] == "light" ){
				// 軽
				$info["leaseInfo"]["automobileTax"]["years"]         = 0;
				$info["leaseInfo"]["automobileTax"]["nextYearGreen"] = $modelInfo["automobileTaxNextYear"];
				$info["leaseInfo"]["automobileTax"]["nextYear"]      = $modelInfo["automobileTaxNextYear"];
				$info["leaseInfo"]["automobileTax"]["last"]          = floor( ($modelInfo["automobileTaxNextYear"]  /12 ) / 100) * 100;
			} else  {
				// 乗用・商用
				$info["leaseInfo"]["automobileTax"]["years"]         = $modelInfo["automobileTaxNextYear"];
				$info["leaseInfo"]["automobileTax"]["nextYearGreen"] = $modelInfo["automobileTaxNextYear_ART"];
				$info["leaseInfo"]["automobileTax"]["nextYear"]      = $modelInfo["automobileTaxNextYear"];
				

				// 自動車税の超過分
				$month        = number_format(substr($lease["carAddDate"], 4, 2));
				$lastMonthCnt = 1;

				if( $month < $ini["lease"]["automobileTaxOrberMonth"] ){
					$lastMonthCnt = 13 - ($ini["lease"]["automobileTaxOrberMonth"] - $month);
				} else if( $month > $ini["lease"]["automobileTaxOrberMonth"] ){
					$lastMonthCnt = $month - $ini["lease"]["automobileTaxOrberMonth"] + 1;
				}

				for( $i = 0; $i < 12; $i++ ){
					if( $term[$i]["month"] == 3 ){
						break;
					}
					$monthCnt++;
					
				}

				$tmp_automobileTaxLast = ( $modelInfo["automobileTaxNextYear"] - ( $modelInfo["automobileTaxNextYear"] * $lastMonthCnt / 12));
				$info["leaseInfo"]["automobileTax"]["last"]          = ( floor($tmp_automobileTaxLast / 100) * 100 ) * -1;
			} 

			// 自動車取得税
			$info["leaseInfo"]["acquisitionTax"]                  = $modelInfo["acquisitionTax_ART"];

			// 重量税(初回、2回目以降)：優遇税制区分(100％)によって2回目以降の重量税が変化
			$info["leaseInfo"]["tonnageTax"]["years"]            = ( $modelInfo["tonnageTax_ART"] / $carInspectionFeeInfo["tonnageTax"] ) * $carInspectionFeeInfo["years"];
			if( $modelInfo["preferentialTaxTypeFlg"] != 1){
				// 100％でない為、減税前を使用
				$info["leaseInfo"]["tonnageTax"]["nextYear"]     = ( $modelInfo["tonnageTax"] / $carInspectionFeeInfo["tonnageTax"] ) * $carInspectionFeeInfo["nextYear"];
				$info["leaseInfo"]["tonnageTax"]["nextYears"]     = ( $modelInfo["tonnageTax"] / $carInspectionFeeInfo["tonnageTax"] ) * $carInspectionFeeInfo["nextYear"];
			} else {
				// 100％の為、減税後を使用
				$info["leaseInfo"]["tonnageTax"]["nextYear"]     = ( $modelInfo["tonnageTax_ART"] / $carInspectionFeeInfo["tonnageTax"] ) * $carInspectionFeeInfo["nextYear"];
				$info["leaseInfo"]["tonnageTax"]["nextYears"]     = ( $modelInfo["tonnageTax"] / $carInspectionFeeInfo["tonnageTax"] ) * $carInspectionFeeInfo["nextYear"];
			}

			// 登録法定費用
			$info["leaseInfo"]["costLegal"]                      = $modelInfo["costLegal"];

			// 登録代行費用
			$info["leaseInfo"]["costActing"]                     = $modelInfo["costActing"];

			// 資金管理料金
			$info["leaseInfo"]["costManagement"]                 = $modelInfo["costManagement"];

			// 自賠責保険(初回、2回目以降)
			$info["leaseInfo"]["insurancePremium"]["years"]      = $ini["lease"]["insurancePremium"][ $carInspectionFeeInfo["insurance"] ][ $term["years"] ];
			$info["leaseInfo"]["insurancePremium"]["nextYear"]   = $ini["lease"]["insurancePremium"][ $carInspectionFeeInfo["insurance"] ][ $term["nextYear"] ];

			// メンテナンス料
			$info["leaseInfo"]["mainteID"] = $modelInfo["mainteID"];
			$sql_escape["mainteID"]  = sql_escapeString($modelInfo["mainteID"]);

			$sql        = "SELECT * ";
			$sql       .= "FROM {$DBName}.maintenanceFee ";
			$sql       .= "WHERE mainteID = '{$sql_escape["mainteID"]}' ";
			$sql       .= "ORDER BY payNumID, mileageID ";
			$mainteInfo = sql_query( $sql );
			for( $i = 0, $iMax = count($mainteInfo); $i < $iMax; $i++ ){
				$keyID = $ini["lease"]["contract"][0]["id"] . "_" . $mainteInfo[$i]["payNumID"] . $mainteInfo[$i]["mileageID"];
				$info["leaseInfo"]["maintenance"][$keyID]   = $mainteInfo[$i]["mainteFee"];	// メンテナンス料
			}

			// リース算出情報 
			$sql        = "SELECT * ";
			$sql       .= "FROM {$DBName}.leaseValue ";
			$sql       .= "WHERE carGradeID = '{$sql_escape["carGradeID"]}' ";
			$sql       .= "  AND makerCode  = '{$sql_escape["makerCode"]}' ";
			$sql       .= "  AND modelCode  = '{$sql_escape["modelCode"]}' ";
			$sql       .= "ORDER BY contractID, payNumID, mileageID ";
			$leaseInfo = sql_query( $sql );

			for( $i = 0, $iMax = count($leaseInfo); $i < $iMax; $i++ ){
				$keyID = $leaseInfo[$i]["contractID"] . "_" . $leaseInfo[$i]["payNumID"] . $leaseInfo[$i]["mileageID"];

				$info["leaseInfo"]["residualValue"][$keyID] = $leaseInfo[$i]["residualValue"];	// 残価
				$info["leaseInfo"]["voluntaryInsurance"][$keyID] = $leaseInfo[$i]["voluntaryInsurance"]; // 任意保険料
			}

			// 燃料費情報
			$info["leaseInfo"]["carInspectionFee"]            = $carInspectionFeeInfo;
			$info["leaseInfo"]["useFuelID"]                   = $modelInfo["useFuelID"];					// 使用ガソリン区分
			$info["leaseInfo"]["fuelConsumptionRateJC08mode"] = $modelInfo["fuelConsumptionRateJC08mode"];	// 消費モード

			// オプション情報
			$info["leaseOption"] = $this->get_leaseOptionPrice( $input["makerCode"], $input["modelCode"], $lease["option"]);

			return $info;

		}



		/*----------------------------------------------------
		  リース算出情報(金利、ガソリン価格、走行距離、リース期間)の取得
		----------------------------------------------------*/
		function get_leaseInfo( $input ){

			global $ini;

			// ＤＢ名取得
			$DBName = get_DBName("base");

			// 金利の取得
			$sql_escape["interestRates"] = sql_escapeString($input["interestRates"]);
			$sql_escape["paynum"]        = sql_escapeString($input["paynum"]);

			$sql  = "SELECT * ";
			$sql .= "FROM {$DBName}.interestRates ";
			$sql .= "WHERE ratesID = '{$sql_escape["interestRates"]}' AND paynumID = '{$sql_escape["paynum"]}' ";
			$sql .= "ORDER BY payNumID";
			$info["interestRates"] = sql_query( $sql, "single" );

			// 年利→月利、パーセント→小数
			$info["interestRates"]["in"]  = $info["interestRates"]["ratesIn"]  / 1200;
			$info["interestRates"]["out"] = $info["interestRates"]["ratesOut"] / 1200;

			// 契約形態(ファイナンス、メンテナンス)
			$info["contract"] = get_contractInfo( $input["contract"] );

			// ガソリン価格の取得
			$sql_escape["gasoline"] = sql_escapeString($input["gasoline"]);

			$sql  = "SELECT * ";
			$sql .= "FROM {$DBName}.gasoline ";
			$sql .= "WHERE regionID = '{$sql_escape["gasoline"]}' ";
			$info["gasoline"]  = sql_query( $sql, "single" );

			// 走行距離
			$info["mileage"] = get_mileageInfo( $input["mileage"] );

			// リース期間
			$info["paynum"] = get_paynumInfo( $input["paynum"] );

			// 車両代
			$info["msrp"] = get_msrpPriceInfo( $input["msrp"] );

			return $info;
		}


		/*----------------------------------------------------
		  ガソリン価格の取得
		----------------------------------------------------*/
		function get_gasolineList(){

			// ＤＢ名取得
			$DBName = get_DBName("base");

			$sql  = "SELECT * ";
			$sql .= "FROM {$DBName}.gasoline ";
			$sql .= "ORDER BY regionID ";
			$tbl  = sql_query( $sql );

			for( $i = 0, $iMax = count($tbl); $i < $iMax; $i++ ){
				$id = $tbl[$i]["regionID"];
				$ret[$id] = $tbl[$i];
			}

			return $ret;
		}


		/*----------------------------------------------------
		  選択オプションの価格取得
		----------------------------------------------------*/
		function get_leaseOptionPrice( $makerCode, $modelCode, $optionList ){
			$ret["taxIncludedPrice"] = 0;
			$ret["procurementCost"]  = 0;

			if( !empty($optionList) ){

				if( count($optionList) > 0 ){
					for( $i = 0, $iMax = count($optionList); $i < $iMax; $i++ ){
						$sql_escape["optionID"]   = sql_escapeString($optionList[$i]["optionID"]);
						$sql_escape["optionItem"] = sql_escapeString($optionList[$i]["optionItem"]);

						$sql_option[] = "( optionID = '{$sql_escape["optionID"]}'  AND optionItem = '{$sql_escape["optionItem"]}' )";
					}
					$sql_optionList = " AND (" . implode(" OR ", $sql_option) . ")";
				}

				$DBName_Base = get_DBName("base");

				$sql_escape["makerCode"] = sql_escapeString($makerCode);
				$sql_escape["modelCode"] = sql_escapeString($modelCode);

				$sql  = "SELECT COALESCE(SUM(taxIncludedPrice),0) as taxIncludedPrice, COALESCE(SUM(procurementCost),0) as procurementCost ";
				$sql .= "FROM {$DBName_Base}.leaseOption ";
				$sql .= "WHERE makerCode = '{$sql_escape["makerCode"]}' ";
				$sql .= "  AND modelCode = '{$sql_escape["modelCode"]}' ";
				$sql .= " {$sql_optionList} ";
				$sql .= "ORDER BY optionID";
				$ret = sql_query( $sql, "single" );
			}

			return $ret;
		}


		/*----------------------------------------------------
		  オプションリストの取得
		----------------------------------------------------*/
		function get_optionList( $makerCode, $modelCode ){

			global $ini;

			// ＤＢ名取得
			$DBName = get_DBName("base");

			// SQLインジェクション対応
			$sql_escape["makerCode"] = sql_escapeString($makerCode);
			$sql_escape["modelCode"] = sql_escapeString($modelCode);

			$sql  = "SELECT * ";
			$sql .= "FROM {$DBName}.leaseOption ";
			$sql .= "WHERE makerCode  = '{$sql_escape["makerCode"]}' ";
			$sql .= "  AND modelCode  = '{$sql_escape["modelCode"]}' ";
			$sql .= "ORDER BY optionItem, optionID ";
			$tbl  = sql_query( $sql );

			// オプションが未登録の場合、おすすめオプションのみ表示する
			if( count($tbl) == 0 ){
				$keyId = $ini["lease"]["optionItem"][0]["id"];
				for( $i = 0, $iMax = count($ini["leasePreset"]["option"]); $i < $iMax; $i++ ){
					$ret[ $keyId ]["option"][$i] = array( "optionID" => $ini["leasePreset"]["option"][$i]["id"]
														, "optionItem" => $keyId
														, "taxIncludedPrice" => 0
														, "procurementCost" => 0
													);
				}
			} 

			// オプション項目別に分ける
			for( $i = 0, $iMax = count($tbl); $i < $iMax; $i++ ){
				$ret[ $tbl[$i]["optionItem"] ]["option"][] = $tbl[$i];
			}

			for( $i = 0 , $iMax = count($ini["lease"]["optionItem"]); $i < $iMax; $i++ ){
				$optionItem = $ini["lease"]["optionItem"][$i]["id"];
				$ret[ $optionItem ]["item"] = $optionItem;
			}

			// おすすめオプションの場合、名称を固定にする
			$keyId = $ini["lease"]["optionItem"][0]["id"];
			for( $i = 0, $iMax = count($ini["leasePreset"]["option"]); $i < $iMax; $i++ ){
				$optionName[$ini["leasePreset"]["option"][$i]["id"]] = $ini["leasePreset"]["option"][$i]["name"];
			}

			for( $i = 0, $iMax = count($ret[ $keyId ]["option"]); $i < $iMax; $i++ ){
				$ret[ $keyId ]["option"][$i]["optionName"] = $optionName[ $ret[ $keyId ]["option"][$i]["optionID"] ];
			}

			return $ret;
		}


		/*----------------------------------------------------
		    リース期間ID
		----------------------------------------------------*/
		function get_payNumInfo ( $makerCode, $modelCode, $carGradeID ) {

			global $ini;

			// ＤＢ名取得
			$DBName = get_DBName( "active" );

			// SQLインジェクション対応
			$sql_escape["carGradeID"] = sql_escapeString($carGradeID);
			$sql_escape["makerCode"]  = sql_escapeString($makerCode);
			$sql_escape["modelCode"]  = sql_escapeString($modelCode);

			$sql = "SELECT bodyModel FROM {$DBName}.carGrade WHERE carGradeID = '{$sql_escape["carGradeID"]}' AND makerCode = '{$sql_escape["makerCode"]}' AND modelCode = '{$sql_escape["modelCode"]}'";
			$ret = sql_query( $sql, "single" );

			$bodyModel  = get_bodyTypeInfo( $ret["bodyModel"] );
			$leaseInfo  = $ini["lease"]["carInspectionFee"][ $bodyModel["lease"] ]["period"];

			for( $i = 0, $iMax = count($leaseInfo); $i < $iMax; $i++ ){
				$paynum            = get_paynumInfo( $leaseInfo[$i] );
				$lease["period"][] = $paynum;

				$lease[$paynum["class"]] = $paynum;
			}

			return $lease;
		}


		/*----------------------------------------------------
		     オプション名取得
		----------------------------------------------------*/
		function get_leaseOptionInfo ( $optionID, $optionItem, $makerCode, $modelCode ) {

			if( empty($optionID) ){
				return NULL;
			}

			global $ini;

			// ＤＢ名取得
			$DBName = get_DBName("base");

			// SQLインジェクション対応
			$sql_escape["makerCode"]  = sql_escapeString($makerCode);
			$sql_escape["modelCode"]  = sql_escapeString($modelCode);
			$sql_escape["optionID"]   = sql_escapeString($optionID);
			$sql_escape["optionItem"] = sql_escapeString($optionItem);

			$sql  = "SELECT * ";
			$sql .= "FROM {$DBName_Base}.leaseOption ";
			$sql .= "WHERE makerCode  = '{$sql_escape["makerCode"]}' ";
			$sql .= "  AND modelCode  = '{$sql_escape["modelCode"]}' ";
			$sql .= "  AND optionID   = '{$sql_escape["optionID"]}' ";
			$sql .= "  AND optionItem = '{$sql_escape["optionItem"]}' ";
			$ret = sql_query( $sql, "single" );

			// おすすめオプションの場合、名称を固定にする
			if( $optionItem == $ini["lease"]["optionItem"][0]["id"] ){
				for( $i = 0, $iMax = count($ini["leasePreset"]["option"]); $i < $iMax; $i++ ){
					$optionName[$ini["leasePreset"]["option"][$i]["id"]] = $ini["leasePreset"]["option"][$i]["name"];
				}
				$ret["optionName"] = $optionName[$optionID];
			}
			return $ret;
		}
	}



?>