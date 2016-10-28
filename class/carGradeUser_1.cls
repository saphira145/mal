<?php
/* -------------------------------------
	管理者管理
	for NetGRID PHP Framework v2
	最終更新: 2009-02-06
------------------------------------- */


	class carGradeUser_1 {


	/*----------------------------------------------------
	    コンストラクタ
	----------------------------------------------------*/
		function carGradeUser () {

		}


		/*----------------------------------------------------
		  情報取得
		----------------------------------------------------*/
		function get_info ( $carGradeID ) {

			// 車種グレード取得
			$ret["carGrade"]              = $this->get_carGradeInfo( $carGradeID );

			// オリジナル車種グレード（検索ログ用）
			$ret["orgCarGrade"]           = $ret["carGrade"];

			// 視界取得
			$ret["view"]                  = $this->get_viewInfo( $carGradeID );

			// 運転席周り取得
			$ret["seatCircumference"]     = $this->get_seatCircumferenceInfo( $carGradeID );

			// 空調取得
			$ret["airConditioning"]       = $this->get_airConditioningInfo( $carGradeID );

			// オーディオ取得
			$ret["audio"]                 = $this->get_audioInfo( $carGradeID );

			// シート・内装関係取得
			$ret["seatInterior"]          = $this->get_seatInteriorInfo( $carGradeID );

			// 外装取得
			$ret["exterior"]              = $this->get_exteriorInfo( $carGradeID );

			// 足回り取得
			$ret["footSurroundings"]      = $this->get_footSurroundingsInfo( $carGradeID );

			// 安全取得
			$ret["safety"]                = $this->get_safetyInfo( $carGradeID );


			return $ret;
		}


		/*----------------------------------------------------
		  車種グレード取得
		----------------------------------------------------*/
		function get_carGradeInfo ( $carGradeID ) {

			// ＤＢ名取得
			$DBName = get_DBName( "active" );

			// SQLインジェクション対応
			$sql_escape["carGradeID"] = sql_escapeString($carGradeID);

			$sql = "SELECT * FROM {$DBName}.carGrade WHERE carGradeID = '{$sql_escape["carGradeID"]}'";
			$ret = sql_query( $sql, "single" );

			return $ret;
		}



		/*----------------------------------------------------
		  視界取得
		----------------------------------------------------*/
		function get_viewInfo ( $carGradeID ) {

			// ＤＢ名取得
			$DBName = get_DBName( "active" );

			// SQLインジェクション対応
			$sql_escape["carGradeID"] = sql_escapeString($carGradeID);

			$sql = "SELECT * FROM {$DBName}.view WHERE carGradeID = '{$sql_escape["carGradeID"]}'";
			$ret = sql_query( $sql, "single" );

			return $ret;
		}



		/*----------------------------------------------------
		  運転席周り取得
		----------------------------------------------------*/
		function get_seatCircumferenceInfo ( $carGradeID ) {

			// ＤＢ名取得
			$DBName = get_DBName( "active" );

			// SQLインジェクション対応
			$sql_escape["carGradeID"] = sql_escapeString($carGradeID);

			$sql = "SELECT * FROM {$DBName}.seatCircumference WHERE carGradeID = '{$sql_escape["carGradeID"]}'";
			$ret = sql_query( $sql, "single" );

			return $ret;
		}



		/*----------------------------------------------------
		  空調取得
		----------------------------------------------------*/
		function get_airConditioningInfo ( $carGradeID ) {

			// ＤＢ名取得
			$DBName = get_DBName( "active" );

			// SQLインジェクション対応
			$sql_escape["carGradeID"] = sql_escapeString($carGradeID);

			$sql = "SELECT * FROM {$DBName}.airConditioning WHERE carGradeID = '{$sql_escape["carGradeID"]}'";
			$ret = sql_query( $sql, "single" );

			return $ret;
		}



		/*----------------------------------------------------
		  オーディオ取得
		----------------------------------------------------*/
		function get_audioInfo ( $carGradeID ) {

			// ＤＢ名取得
			$DBName = get_DBName( "active" );

			// SQLインジェクション対応
			$sql_escape["carGradeID"] = sql_escapeString($carGradeID);

			$sql = "SELECT * FROM {$DBName}.audio WHERE carGradeID = '{$sql_escape["carGradeID"]}'";
			$ret = sql_query( $sql, "single" );

			return $ret;
		}



		/*----------------------------------------------------
		  シート・内装関係取得
		----------------------------------------------------*/
		function get_seatInteriorInfo ( $carGradeID ) {

			// ＤＢ名取得
			$DBName = get_DBName( "active" );

			// SQLインジェクション対応
			$sql_escape["carGradeID"] = sql_escapeString($carGradeID);

			$sql = "SELECT * FROM {$DBName}.seatInterior WHERE carGradeID = '{$sql_escape["carGradeID"]}'";
			$ret = sql_query( $sql, "single" );

			return $ret;
		}



		/*----------------------------------------------------
		  外装取得
		----------------------------------------------------*/
		function get_exteriorInfo ( $carGradeID ) {

			// ＤＢ名取得
			$DBName = get_DBName( "active" );

			// SQLインジェクション対応
			$sql_escape["carGradeID"] = sql_escapeString($carGradeID);

			$sql = "SELECT * FROM {$DBName}.exterior WHERE carGradeID = '{$sql_escape["carGradeID"]}'";
			$ret = sql_query( $sql, "single" );

			return $ret;
		}



		/*----------------------------------------------------
		  足回り取得
		----------------------------------------------------*/
		function get_footSurroundingsInfo ( $carGradeID ) {

			// ＤＢ名取得
			$DBName = get_DBName( "active" );

			// SQLインジェクション対応
			$sql_escape["carGradeID"] = sql_escapeString($carGradeID);

			$sql = "SELECT * FROM {$DBName}.footSurroundings WHERE carGradeID = '{$sql_escape["carGradeID"]}'";
			$ret = sql_query( $sql, "single" );

			return $ret;
		}



		/*----------------------------------------------------
		  安全取得
		----------------------------------------------------*/
		function get_safetyInfo ( $carGradeID ) {

			// ＤＢ名取得
			$DBName = get_DBName( "active" );

			// SQLインジェクション対応
			$sql_escape["carGradeID"] = sql_escapeString($carGradeID);

			$sql = "SELECT * FROM {$DBName}.safety WHERE carGradeID = '{$sql_escape["carGradeID"]}'";
			$ret = sql_query( $sql, "single" );

			return $ret;
		}



		/*----------------------------------------------------
		  表示用に変換
		----------------------------------------------------*/
		function convert_info ( $info ) {

			// 車種グレード
			$info["carGrade"]                      = $this->convert_carGradeInfo( $info["carGrade"] );

			// 視界変換
			$info["view"]                          = $this->convert_viewInfo( $info["view"] );

			// 運転席周り変換
			$info["seatCircumference"]             = $this->convert_seatCircumferenceInfo( $info["seatCircumference"] );

			// 空調変換
			$info["airConditioning"]               = $this->convert_airConditioningInfo( $info["airConditioning"] );

			// オーディオ変換
			$info["audio"]                         = $this->convert_audioInfo( $info["audio"] );

			// シート・内装関係変換
			$info["seatInterior"]                  = $this->convert_seatInteriorInfo( $info["seatInterior"] );

			// 外装変換
			$info["exterior"]                      = $this->convert_exteriorInfo( $info["exterior"] );

			// 足回り変換
			$info["footSurroundings"]              = $this->convert_footSurroundingsInfo( $info["footSurroundings"] );

			// 安全変換
			$info["safety"]                        = $this->convert_safetyInfo( $info["safety"] );


			return $info;
		}


		/*----------------------------------------------------
		  車種グレード変換
		----------------------------------------------------*/
		function convert_carGradeInfo ( $info ) {

			// 数値変換
			$info = $this->convert_numberCarGrade( $info );

			// <wbr>追加
			$info = $this->set_wbr( $info, 1 );

			return $info;
		}



		/*----------------------------------------------------
		  数値変換（車種グレード）
		----------------------------------------------------*/
		function convert_numberCarGrade ( $info ) {

			// 金額に小数点を付与
			$info["price"] = MODIFIER_add_dot( $info["price"] );

			$param[0] = 0;

			// カンマ編集
			$info["totalEmission"]          = MODIFIER_number_format( $info["totalEmission"], $param );
			$info["totalLength"]            = MODIFIER_number_format( $info["totalLength"], $param );
			$info["totalWidth"]             = MODIFIER_number_format( $info["totalWidth"], $param );
			$info["totalHeight"]            = MODIFIER_number_format( $info["totalHeight"], $param );
			$info["roomLength"]             = MODIFIER_number_format( $info["roomLength"], $param );
			$info["roomWidth"]              = MODIFIER_number_format( $info["roomWidth"], $param );
			$info["roomHeight"]             = MODIFIER_number_format( $info["roomHeight"], $param );
			$info["wheelbase"]              = MODIFIER_number_format( $info["wheelbase"], $param );
			$info["frontTread"]             = MODIFIER_number_format( $info["frontTread"], $param );
			$info["rearTread"]              = MODIFIER_number_format( $info["rearTread"], $param );
			$info["minHeight"]              = MODIFIER_number_format( $info["minHeight"], $param );
			$info["vehicleWeight"]          = MODIFIER_number_format( $info["vehicleWeight"], $param );
			$info["vehicleTotalWeight"]     = MODIFIER_number_format( $info["vehicleTotalWeight"], $param );

			return $info;
		}



		/*----------------------------------------------------
		  視界変換
		----------------------------------------------------*/
		function convert_viewInfo ( $info ) {

			// <wbr>追加
			$info = $this->set_wbr( $info );

			$info["xenonHeadlampType_{$info["xenonHeadlampType"]}"]                 = 1;
			$info["projectorHeadlampType_{$info["projectorHeadlampType"]}"]         = 1;
			$info["frontFogLampType_{$info["frontFogLampType"]}"]                   = 1;
			$info["rearFogLampType_{$info["rearFogLampType"]}"]                     = 1;
			$info["backViewMonitorType_{$info["backViewMonitorType"]}"]             = 1;
			$info["activeAFSType_{$info["activeAFSType"]}"]                         = 1;
			$info["autoLightSystemType_{$info["autoLightSystemType"]}"]             = 1;
			$info["remoteDoorMirrorType_{$info["remoteDoorMirrorType"]}"]           = 1;
			$info["storageDoorMirrorType_{$info["storageDoorMirrorType"]}"]         = 1;
			$info["heaterMirrorType_{$info["heaterMirrorType"]}"]                   = 1;
			$info["reverseMirrorType_{$info["reverseMirrorType"]}"]                 = 1;
			$info["frontUVBlockGlassType_{$info["frontUVBlockGlassType"]}"]         = 1;
			$info["rearUVBlockGlassType_{$info["rearUVBlockGlassType"]}"]           = 1;
			$info["sideUVBlockGlassType_{$info["sideUVBlockGlassType"]}"]           = 1;
			$info["frontDoorUVBlockGlassType_{$info["frontDoorUVBlockGlassType"]}"] = 1;
			$info["rearDoorUVBlockGlassType_{$info["rearDoorUVBlockGlassType"]}"]   = 1;
			$info["rearPrivacyGlassType_{$info["rearPrivacyGlassType"]}"]           = 1;
			$info["rearDoorPrivacyGlassType_{$info["rearDoorPrivacyGlassType"]}"]   = 1;
			$info["sideDoorPrivacyGlassType_{$info["sideDoorPrivacyGlassType"]}"]   = 1;
			$info["cornerRingLampType_{$info["cornerRingLampType"]}"]               = 1;
			$info["sideBlindMonitorType_{$info["sideBlindMonitorType"]}"]           = 1;
			$info["rearWiperType_{$info["rearWiperType"]}"]                         = 1;


			return $info;
		}



		/*----------------------------------------------------
		  運転席周り変換
		----------------------------------------------------*/
		function convert_seatCircumferenceInfo ( $info ) {

			// <wbr>追加
			$info = $this->set_wbr( $info );

			$info["leatherSteeringType_{$info["leatherSteeringType"]}"]                   = 1;
			$info["steeringSwitchType_{$info["steeringSwitchType"]}"]                     = 1;
			$info["powerSteeringType_{$info["powerSteeringType"]}"]                       = 1;
			$info["telescopicSteeringType_{$info["telescopicSteeringType"]}"]             = 1;
			$info["tiltSteeringType_{$info["tiltSteeringType"]}"]                         = 1;
			$info["concentratedDoorLockType_{$info["concentratedDoorLockType"]}"]         = 1;
			$info["intelligentKeyType_{$info["intelligentKeyType"]}"]                     = 1;
			$info["remoteEntrySystemType_{$info["remoteEntrySystemType"]}"]               = 1;
			$info["engineImmobilizerType_{$info["engineImmobilizerType"]}"]               = 1;
			$info["betweenCarControlSystemType_{$info["betweenCarControlSystemType"]}"]   = 1;
			$info["ASCDType_{$info["ASCDType"]}"]                                         = 1;
			$info["tachometerType_{$info["tachometerType"]}"]                             = 1;
			$info["glowMeterType_{$info["glowMeterType"]}"]                               = 1;
			$info["woodgrainPanelType_{$info["woodgrainPanelType"]}"]                     = 1;
			$info["carbonPanelType_{$info["carbonPanelType"]}"]                           = 1;
			$info["pianoPanelType_{$info["pianoPanelType"]}"]                             = 1;
			$info["metallicPanelType_{$info["metallicPanelType"]}"]                       = 1;
			$info["powerWindowType_{$info["powerWindowType"]}"]                           = 1;


			return $info;
		}



		/*----------------------------------------------------
		  空調変換
		----------------------------------------------------*/
		function convert_airConditioningInfo ( $info ) {

			// <wbr>追加
			$info = $this->set_wbr( $info );

			$info["coolerType_{$info["coolerType"]}"]                                       = 1;
			$info["airConditionerType_{$info["airConditionerType"]}"]                       = 1;
			$info["fullAirConditionerType_{$info["fullAirConditionerType"]}"]               = 1;
			$info["dualAirConditionerType_{$info["dualAirConditionerType"]}"]               = 1;
			$info["cleanFilterType_{$info["cleanFilterType"]}"]                             = 1;
			$info["pureTronType_{$info["pureTronType"]}"]                                   = 1;
			$info["pollenFilterType_{$info["pollenFilterType"]}"]                           = 1;
			$info["deodorizationCleanFilterType_{$info["deodorizationCleanFilterType"]}"]   = 1;
			$info["rearHeaterDuctType_{$info["rearHeaterDuctType"]}"]                       = 1;
			$info["mildFlowSystemType_{$info["mildFlowSystemType"]}"]                       = 1;


			return $info;
		}



		/*----------------------------------------------------
		  オーディオ変換
		----------------------------------------------------*/
		function convert_audioInfo ( $info ) {

			// <wbr>追加
			$info = $this->set_wbr( $info );

			$info["AMRadioType_{$info["AMRadioType"]}"]                               = 1;
			$info["FMRadioType_{$info["FMRadioType"]}"]                               = 1;
			$info["cassetteType_{$info["cassetteType"]}"]                             = 1;
			$info["CDType_{$info["CDType"]}"]                                         = 1;
			$info["MDType_{$info["MDType"]}"]                                         = 1;
			$info["DVDType_{$info["DVDType"]}"]                                       = 1;
			$info["TVType_{$info["TVType"]}"]                                         = 1;
			$info["naviType_{$info["naviType"]}"]                                     = 1;
			$info["speakerType_{$info["speakerType"]}"]                               = 1;
			$info["antennaType_{$info["antennaType"]}"]                               = 1;
			$info["ETCType_{$info["ETCType"]}"]                                       = 1;
			$info["ExternalJoinTerminalType_{$info["ExternalJoinTerminalType"]}"]     = 1;
			$info["musicRecordType_{$info["musicRecordType"]}"]                       = 1;
			$info["handsFreeType_{$info["handsFreeType"]}"]                           = 1;


			return $info;
		}



		/*----------------------------------------------------
		  シート・内装関係変換
		----------------------------------------------------*/
		function convert_seatInteriorInfo ( $info ) {

			// <wbr>追加
			$info = $this->set_wbr( $info );

			$info["seatGroundType_{$info["seatGroundType"]}"]                                    = 1;
			$info["powerSeatType_{$info["powerSeatType"]}"]                                      = 1;
			$info["secondPowerSeatType_{$info["secondPowerSeatType"]}"]                          = 1;
			$info["seatLifterType_{$info["seatLifterType"]}"]                                    = 1;
			$info["frontArmWrestType_{$info["frontArmWrestType"]}"]                              = 1;
			$info["secondArmWrestType_{$info["secondArmWrestType"]}"]                            = 1;
			$info["secondSeatRecliningType_{$info["secondSeatRecliningType"]}"]                  = 1;
			$info["secondSeatSlideType_{$info["secondSeatSlideType"]}"]                          = 1;
			$info["secondSeatMechanismType_{$info["secondSeatMechanismType"]}"]                  = 1;
			$info["secondSeatShapeType_{$info["secondSeatShapeType"]}"]                          = 1;
			$info["secondFoldingSeatShapeType_{$info["secondFoldingSeatShapeType"]}"]            = 1;
			$info["thirdArmWrestType_{$info["thirdArmWrestType"]}"]                              = 1;
			$info["thirdSeatSlideType_{$info["thirdSeatSlideType"]}"]                            = 1;
			$info["thirdSeatRecliningType_{$info["thirdSeatRecliningType"]}"]                    = 1;
			$info["thirdSeatMechanismType_{$info["thirdSeatMechanismType"]}"]                    = 1;
			$info["thirdSeatShapeType_{$info["thirdSeatShapeType"]}"]                            = 1;
			$info["thirdPowerSeatType_{$info["thirdPowerSeatType"]}"]                            = 1;
			$info["thirdFoldingSeatShapeType_{$info["thirdFoldingSeatShapeType"]}"]              = 1;
			$info["seatArrangementType_{$info["seatArrangementType"]}"]                          = 1;
			$info["seatTrayType_{$info["seatTrayType"]}"]                                        = 1;
			$info["ottomanType_{$info["ottomanType"]}"]                                          = 1;
			$info["autoDrivingPositionMemoryType_{$info["autoDrivingPositionMemoryType"]}"]      = 1;
			$info["carInPowerType_{$info["carInPowerType"]}"]                                    = 1;
			$info["seatBackPocketType_{$info["seatBackPocketType"]}"]                            = 1;
			$info["heaterSeatType_{$info["heaterSeatType"]}"]                                    = 1;
			$info["airConditionerSeatType_{$info["airConditionerSeatType"]}"]                    = 1;
			$info["floorStorageType_{$info["floorStorageType"]}"]                                = 1;


			return $info;
		}



		/*----------------------------------------------------
		  外装変換
		----------------------------------------------------*/
		function convert_exteriorInfo ( $info ) {

			// <wbr>追加
			$info = $this->set_wbr( $info );

			$info["tiltuproofType_{$info["tiltuproofType"]}"]                 = 1;
			$info["glassSunroofType_{$info["glassSunroofType"]}"]             = 1;
			$info["twinSunroofType_{$info["twinSunroofType"]}"]               = 1;
			$info["roofRailType_{$info["roofRailType"]}"]                     = 1;
			$info["autoSlideDoorType_{$info["autoSlideDoorType"]}"]           = 1;
			$info["frontProtectorType_{$info["frontProtectorType"]}"]         = 1;
			$info["rearProtectorType_{$info["rearProtectorType"]}"]           = 1;
			$info["sideProtectorType_{$info["sideProtectorType"]}"]           = 1;
			$info["rearGlassHatchType_{$info["rearGlassHatchType"]}"]         = 1;


			return $info;
		}



		/*----------------------------------------------------
		  足回り変換
		----------------------------------------------------*/
		function convert_footSurroundingsInfo ( $info ) {

			// <wbr>追加
			$info = $this->set_wbr( $info );

			$info["4WASType_{$info["4WASType"]}"]                                   = 1;
			$info["powerfulBrakeType_{$info["powerfulBrakeType"]}"]                 = 1;
			$info["powerfulSuspensionType_{$info["powerfulSuspensionType"]}"]       = 1;
			$info["aluminumWheelType_{$info["aluminumWheelType"]}"]                 = 1;
			$info["spareTireType_{$info["spareTireType"]}"]                         = 1;


			return $info;
		}



		/*----------------------------------------------------
		  安全変換
		----------------------------------------------------*/
		function convert_safetyInfo ( $info ) {

			// <wbr>追加
			$info = $this->set_wbr( $info );

			$info["driverSeatSRSAirBackSystemType_{$info["driverSeatSRSAirBackSystemType"]}"]            = 1;
			$info["passengerSeatSRSAirBackSystemType_{$info["passengerSeatSRSAirBackSystemType"]}"]      = 1;
			$info["frontSRSSideAirBackSystemType_{$info["frontSRSSideAirBackSystemType"]}"]              = 1;
			$info["rearSRSSideAirBackSystemType_{$info["rearSRSSideAirBackSystemType"]}"]                = 1;
			$info["ABSType_{$info["ABSType"]}"]                                                          = 1;
			$info["brakeAssistType_{$info["brakeAssistType"]}"]                                          = 1;
			$info["TCSType_{$info["TCSType"]}"]                                                          = 1;
			$info["VDCType_{$info["VDCType"]}"]                                                          = 1;
			$info["pretensionerSeatBeltType_{$info["pretensionerSeatBeltType"]}"]                        = 1;
			$info["forceLimiterSeatBeltType_{$info["forceLimiterSeatBeltType"]}"]                        = 1;
			$info["childSeatAnchorType_{$info["childSeatAnchorType"]}"]                                  = 1;
			$info["highMountStoplampType_{$info["highMountStoplampType"]}"]                              = 1;
			$info["rearELRSeatBeltType_{$info["rearELRSeatBeltType"]}"]                                  = 1;
			$info["scissorsPowerWindowType_{$info["scissorsPowerWindowType"]}"]                          = 1;
			$info["safetyStructureBodyType_{$info["safetyStructureBodyType"]}"]                          = 1;
			$info["priCrashSeatBeltType_{$info["priCrashSeatBeltType"]}"]                                = 1;
			$info["priCrashBrakeAssistType_{$info["priCrashBrakeAssistType"]}"]                          = 1;
			$info["antiTheftAlarmType_{$info["antiTheftAlarmType"]}"]                                    = 1;
			$info["activeHeadrestType_{$info["activeHeadrestType"]}"]                                    = 1;
			$info["frontStabilizerType_{$info["frontStabilizerType"]}"]                                  = 1;
			$info["rearStabilizerType_{$info["rearStabilizerType"]}"]                                    = 1;


			return $info;
		}



		/*----------------------------------------------------
		  <wbr>追加
		----------------------------------------------------*/
		function set_wbr ( $info, $carGradeFlg=0 ) {

			if( !is_array ( $info ) ) {
				return NULL;
			}

			// 挿入文字数
			$param[0] = 10;

			foreach( $info as $fieldName => $value ) {
				if( $carGradeFlg == 1 || preg_match( "/.Name$/", $fieldName ) ) {
					$info[$fieldName] = MODIFIER_addWbr ( $value, $param );
				}
			}

			return $info;
		}



		/*----------------------------------------------------
		  リスト取得
		----------------------------------------------------*/
		function get_list ( $input ) {

			global $ini;

			// メーカーコード
			if ( $input["makerCode"] > 0 ) {
				$sql_escape["makerCode"] = sql_escapeString($input["makerCode"]);
				$where[] = "makerCode = '{$sql_escape["makerCode"]}'";
			}

			// 車種コード
			if ( $input["modelCode"] != "" ) {
				$sql_escape["modelCode"] = sql_escapeString($input["modelCode"]);
				$where[] = "modelCode = '{$sql_escape["modelCode"]}'";
			}

			if ( count( $where ) > 0 ) {
				$sql_where = "WHERE " . @implode( " AND ", $where );
			}

			// ＤＢ名取得
			$DBName = get_DBName( "active" );

			// 件数の取得
			$sql = "SELECT count(*) AS cnt FROM {$DBName}.carGrade {$sql_where}";
			$tbl = sql_query( $sql, "single" );

			// ページ情報の取得
			$pageInfo = adjust_pageState( $tbl["cnt"], $ini["pageLimit"]["carGradeUser"], $input["pageNum"] );

			// SQLインジェクション対応
			$sql_escape["limitStart"] = sql_escapeString($pageInfo["limitStart"]);
			$sql_escape["pageLimit"]  = sql_escapeString($ini["pageLimit"]["carGradeUser"]);

			// リスト取得
			$sql  = "SELECT * FROM {$DBName}.carGrade ";
			$sql .= "{$sql_where} ";
			$sql .= "ORDER BY grade DESC ";
			$sql .= "LIMIT {$sql_escape["limitStart"]}, {$sql_escape["pageLimit"]}";
			$list = (array)sql_query( $sql );

			return array( $list, $pageInfo );
		}


		/*----------------------------------------------------
		  ボディタイプの取得
		----------------------------------------------------*/
		function get_carGradeBodyModel ( $makerCode, $modelCode, $carGradeID=null ) {

			global $ini;

			// ＤＢ名取得
			$DBName = get_DBName( "active" );

			// デフォルトグレードの取得(グレード指定が無い場合)
			if( empty($carGradeID) ){
				// SQLインジェクション対応
				$sql_escape["makerCode"] = sql_escapeString($makerCode);
				$sql_escape["modelCode"] = sql_escapeString($modelCode);

				$sql = "SELECT lowPriceCarGradeID, s2wdCarGradeID, s4wdCarGradeID FROM {$DBName}.model WHERE makerCode = '{$sql_escape["makerCode"]}' AND modelCode = '{$sql_escape["modelCode"]}'";
				$tbl = sql_query( $sql, "single" );

				$arrCarGrade["s2wdCarGradeID"]     = $tbl["s2wdCarGradeID"];
				$arrCarGrade["s4wdCarGradeID"]     = $tbl["s4wdCarGradeID"];
				$arrCarGrade["lowPriceCarGradeID"] = $tbl["lowPriceCarGradeID"];

				if( count($arrCarGrade) ){
					foreach( $arrCarGrade as $key => $val){
						if( !empty($val) ){
							$carGradeID = $val;
							break;
						}
					}
				}
			}

			// SQLインジェクション対応
			$sql_escape["carGradeID"] = sql_escapeString($carGradeID);

			// ボディタイプの取得
			$sql = "SELECT bodyModel FROM {$DBName}.carGrade WHERE carGradeID = '{$sql_escape["carGradeID"]}'";
			$tbl = sql_query( $sql, "single" );

			return $tbl["bodyModel"];
		}


		/*----------------------------------------------------
		  ランキング表示データ／システム自動設定車種データ取得
		----------------------------------------------------*/
		function get_rankingData( $input ) {

			global $ini;

			// ＤＢ名取得
			$DBName_active = get_DBName( "active" );
			$DBName_Base   = get_DBName( "base" );
			
			//---------------------------------
			// WHERE句定義
			//---------------------------------
			// バリュー
			for( $i = 0; $i < count($input["theme"]); $i++ ){
				if( is_numeric($input["theme"][$i]) ){
					$tmp["theme"][] = "'" . sql_escapeString($input["theme"][$i]) ."'";
				}
			}
			if( count($tmp["theme"]) > 0 ){
				$sql_in_themeID = implode(",", $tmp["theme"]);
				$sql_escape["sql_in_themeID"] = $sql_in_themeID;
			}

			// メーカー
			for( $i = 0; $i < count($input["maker"]); $i++ ){
				if( is_numeric($input["maker"][$i]) ){
					$tmp["maker"][] = "'" . sql_escapeString($input["maker"][$i]) . "'";
				}
			}
			if( count($tmp["maker"]) > 0 ){
				$sql_in_makerCode = implode(",", $tmp["maker"]);
				$sql_escape["sql_in_makerCode"] = $sql_in_makerCode;
			}

			// ボディ
			for( $i = 0; $i < count($input["bodyModel"]); $i++ ){
				if( is_numeric($input["bodyModel"][$i]) ){
					$tmp["bodyModel"][] = "'" . sql_escapeString($input["bodyModel"][$i]) ."'";
				}
			}
			if( count($tmp["bodyModel"]) > 0 ){
				$sql_in_bodyModel = implode(",", $tmp["bodyModel"]);
				$sql_escape["sql_in_bodyModel"] = $sql_in_bodyModel;
			}

			// 価格
			if( !is_numeric($input["price"]) ){
				$input["price"] = $ini["carPriceNotID"];
			}

			$carPrice = $ini["carPrice"][$input["price"]];
			if( !empty($carPrice["priceMax"])){
				$sql_price_from = $carPrice["priceMin"];
				$sql_price_to   = $carPrice["priceMax"];

				$sql_escape["sql_price_from"] = sql_escapeString($sql_price_from);
				$sql_escape["sql_price_to"]   = sql_escapeString($sql_price_to);
			} else {
				$sql_price_from = $carPrice["priceMin"];
				$sql_escape["sql_price_from"] = sql_escapeString($sql_price_from);
			}
			// 価格「指定なし」選択時
			if( $input["price"] == "6" ){
				$sql_price_from = "";
				$sql_price_to   = "";

				$sql_escape["sql_price_from"] = sql_escapeString($sql_price_from);
				$sql_escape["sql_price_to"]   = sql_escapeString($sql_price_to);
			}

			//--------------------------------------------------------------
			// 価格が指定された場合、代表グレードの優先順位を変える
			//--------------------------------------------------------------
			if( !empty($sql_price_from) || !empty($sql_price_to) ){
				$s2wdGrade     = "2_s2wd";
				$s4wdGrade     = "3_s4wd";
				$lowPriceGrade = "1_lowPrice";
			}else{
				$s2wdGrade     = "1_s2wd";
				$s4wdGrade     = "2_s4wd";
				$lowPriceGrade = "3_lowPrice";
			}
			$sql_escape["s2wdGrade"]     = sql_escapeString($s2wdGrade);
			$sql_escape["s4wdGrade"]     = sql_escapeString($s4wdGrade);
			$sql_escape["lowPriceGrade"] = sql_escapeString($lowPriceGrade);


			//---------------------------------
			// SQL作成
			//---------------------------------
			// $sql_from_where は、modelGradeList, defaultGrade を作成するときの FROM句～WHERE句まで
			$sql_from_where  = "";
			$sql_from_where .= "    FROM ( ";
			$sql_from_where .= "        SELECT ";
			$sql_from_where .= "            m.makerCode, ";
			$sql_from_where .= "            m.modelCode, ";
			$sql_from_where .= "            m.miniPrice * 10000 miniPrice, ";
			$sql_from_where .= "            m.maxPrice * 10000 maxPrice, ";
			$sql_from_where .= "            s2wd.carGradeID, ";
			$sql_from_where .= "            CAST(s2wd.taxIncludedPrice as SIGNED) as taxIncludedPrice, ";
			$sql_from_where .= "            s2wd.bodyModel, ";
			$sql_from_where .= "            s2wd.bodyModelName, ";
			$sql_from_where .= "            '{$sql_escape["s2wdGrade"]}' as grade ";
			$sql_from_where .= "        FROM {$DBName_active}.model m ";
			$sql_from_where .= "        LEFT JOIN {$DBName_active}.carGrade s2wd ON m.s2wdCarGradeID = s2wd.carGradeID ";
			$sql_from_where .= " ";
			$sql_from_where .= "        UNION ALL ";
			$sql_from_where .= "        SELECT ";
			$sql_from_where .= "            m.makerCode, ";
			$sql_from_where .= "            m.modelCode, ";
			$sql_from_where .= "            m.miniPrice * 10000 miniPrice, ";
			$sql_from_where .= "            m.maxPrice * 10000 maxPrice, ";
			$sql_from_where .= "            s4wd.carGradeID, ";
			$sql_from_where .= "            CAST(s4wd.taxIncludedPrice as SIGNED) as taxIncludedPrice, ";
			$sql_from_where .= "            s4wd.bodyModel, ";
			$sql_from_where .= "            s4wd.bodyModelName, ";
			$sql_from_where .= "            '{$sql_escape["s4wdGrade"]}' as grade ";
			$sql_from_where .= "        FROM {$DBName_active}.model m ";
			$sql_from_where .= "        LEFT JOIN {$DBName_active}.carGrade s4wd ON m.s4wdCarGradeID = s4wd.carGradeID ";
			$sql_from_where .= " ";
			$sql_from_where .= "        UNION ALL ";
			$sql_from_where .= "        SELECT ";
			$sql_from_where .= "            m.makerCode, ";
			$sql_from_where .= "            m.modelCode, ";
			$sql_from_where .= "            m.miniPrice * 10000 miniPrice, ";
			$sql_from_where .= "            m.maxPrice * 10000 maxPrice, ";
			$sql_from_where .= "            lowPrice.carGradeID, ";
			$sql_from_where .= "            CAST(lowPrice.taxIncludedPrice as SIGNED) as taxIncludedPrice, ";
			$sql_from_where .= "            lowPrice.bodyModel, ";
			$sql_from_where .= "            lowPrice.bodyModelName, ";
			$sql_from_where .= "            '{$sql_escape["lowPriceGrade"]}' as grade ";
			$sql_from_where .= "        FROM {$DBName_active}.model m ";
			$sql_from_where .= "        LEFT JOIN {$DBName_active}.carGrade lowPrice ON m.lowPriceCarGradeID = lowPrice.carGradeID ";
			$sql_from_where .= "    ) tmp ";
			$sql_from_where .= "    WHERE tmp.taxIncludedPrice IS NOT NULL ";
			// メーカー
			if( !empty($sql_in_makerCode) ){
				$sql_from_where .= "    AND tmp.makerCode IN ( {$sql_escape["sql_in_makerCode"]} ) ";
			}
			// バリュー
			if( !empty($sql_in_themeID) ){
				$sql_from_where .= "    AND EXISTS ( ";
				$sql_from_where .= "        SELECT * ";
				$sql_from_where .= "        FROM {$DBName_active}.carTheme as ct ";
				$sql_from_where .= "        WHERE ct.makerCode = tmp.makerCode ";
				$sql_from_where .= "        AND ct.modelCode = tmp.modelCode ";
				$sql_from_where .= "        AND ct.themeID IN ( {$sql_escape["sql_in_themeID"]} ) ";
				$sql_from_where .= "        GROUP BY ct.makerCode, ct.modelCode ";
				$sql_from_where .= "        HAVING count(ct.themeID) >= '" . sql_escapeString(count($tmp["theme"])) . "' ";
				$sql_from_where .= "    ) ";
			}

			$sql_from_where .= "    AND ( ( ";
			$sql_from_where .= "            tmp.grade = '{$sql_escape["s2wdGrade"]}' ";
			// ボディタイプ
			if( !empty($sql_in_bodyModel) ){
				$sql_from_where .= "            AND tmp.bodyModel IN ( {$sql_escape["sql_in_bodyModel"]} ) ";
			}
			// 価格
			if( !empty($sql_price_from) ){
				$sql_from_where .= "            AND CAST(tmp.taxIncludedPrice as SIGNED) >= '{$sql_escape["sql_price_from"]}' ";
			}
			if( !empty($sql_price_to) ){
				$sql_from_where .= "            AND CAST(tmp.taxIncludedPrice as SIGNED) <= '{$sql_escape["sql_price_to"]}' ";
			}
			$sql_from_where .= "        ) OR ( ";
			$sql_from_where .= "            tmp.grade = '{$sql_escape["s4wdGrade"]}' ";
			// ボディタイプ
			if( !empty($sql_in_bodyModel) ){
				$sql_from_where .= "            AND tmp.bodyModel IN ( {$sql_escape["sql_in_bodyModel"]} ) ";
			}
			// 価格
			if( !empty($sql_price_from) ){
				$sql_from_where .= "            AND CAST(tmp.taxIncludedPrice as SIGNED) >= '{$sql_escape["sql_price_from"]}' ";
			}
			if( !empty($sql_price_to) ){
				$sql_from_where .= "            AND CAST(tmp.taxIncludedPrice as SIGNED) <= '{$sql_escape["sql_price_to"]}' ";
			}
			$sql_from_where .= "        ) OR ( ";
			$sql_from_where .= "            tmp.grade = '{$sql_escape["lowPriceGrade"]}' ";
			// ボディタイプ
			if( !empty($sql_in_bodyModel) ){
				$sql_from_where .= "            AND tmp.bodyModel IN ( {$sql_escape["sql_in_bodyModel"]} ) ";
			}
			// 価格
			if( !empty($sql_price_from) ){
				$sql_from_where .= "            AND CAST(tmp.taxIncludedPrice as SIGNED) >= '{$sql_escape["sql_price_from"]}' ";
			}
			if( !empty($sql_price_to) ){
				$sql_from_where .= "            AND CAST(tmp.taxIncludedPrice as SIGNED) <= '{$sql_escape["sql_price_to"]}' ";
			}
			$sql_from_where .= "        ) ";
			$sql_from_where .= "    ) ";

			//---------------------------
			// 以下、発効するSQL
			//---------------------------
			$sql  = "";
			$sql .= "SELECT ";
			$sql .= "    modelGradeList.makerCode, ";
			$sql .= "    modelGradeList.modelCode, ";
			$sql .= "    modelGradeList.miniPrice, ";
			$sql .= "    modelGradeList.maxPrice, ";
			$sql .= "    modelGradeList.carGradeID, ";
			$sql .= "    modelGradeList.grade, ";
			$sql .= "    taxIncludedPriceRange.minTaxIncludedPrice, ";
			$sql .= "    taxIncludedPriceRange.maxTaxIncludedPrice ";
			$sql .= "FROM ( ";
			$sql .= "    SELECT tmp.makerCode, tmp.modelCode, tmp.miniPrice, tmp.maxPrice, tmp.carGradeID, tmp.taxIncludedPrice, tmp.bodyModel, tmp.bodyModelName, tmp.grade ";
			$sql .= "    {$sql_from_where} ";
			$sql .= ") modelGradeList ";
			
			// modelGradeListから車種別のデフォルトグレードを取得する。この結果でmodelGradeListを絞り込む。
			$sql .= "INNER JOIN ( ";
			$sql .= "    SELECT tmp.makerCode, tmp.modelCode, MIN(grade) as grade ";
			$sql .= "    {$sql_from_where} ";
			$sql .= "    GROUP BY tmp.makerCode, tmp.modelCode ";
			$sql .= ") defaultGrade ";
			$sql .= "ON defaultGrade.makerCode = modelGradeList.makerCode AND defaultGrade.modelCode = modelGradeList.modelCode AND defaultGrade.grade = modelGradeList.grade ";

			// 車種別の価格帯
			$sql .= "LEFT JOIN ( ";
			$sql .= "    SELECT  tmp.makerCode, tmp.modelCode, MIN(tmp.taxIncludedPrice) as minTaxIncludedPrice, MAX(tmp.taxIncludedPrice) as maxTaxIncludedPrice ";
			$sql .= "    FROM ( ";
			$sql .= "        SELECT m.makerCode, m.modelCode, CAST(s2wd.taxIncludedPrice as SIGNED) as taxIncludedPrice ";
			$sql .= "        FROM {$DBName_active}.model m ";
			$sql .= "        LEFT JOIN {$DBName_active}.carGrade s2wd ON m.s2wdCarGradeID = s2wd.carGradeID ";
			$sql .= " ";
			$sql .= "        UNION ALL ";
			$sql .= "        SELECT m.makerCode, m.modelCode, CAST(s4wd.taxIncludedPrice as SIGNED) as taxIncludedPrice ";
			$sql .= "        FROM {$DBName_active}.model m ";
			$sql .= "        LEFT JOIN {$DBName_active}.carGrade s4wd ON m.s4wdCarGradeID = s4wd.carGradeID ";
			$sql .= " ";
			$sql .= "        UNION ALL ";
			$sql .= "        SELECT m.makerCode, m.modelCode, CAST(lowPrice.taxIncludedPrice as SIGNED) as taxIncludedPrice ";
			$sql .= "        FROM {$DBName_active}.model m ";
			$sql .= "        LEFT JOIN {$DBName_active}.carGrade lowPrice ON m.lowPriceCarGradeID = lowPrice.carGradeID ";
			$sql .= "    ) tmp ";
			$sql .= "    GROUP BY tmp.makerCode, tmp.modelCode ";
			$sql .= ") taxIncludedPriceRange ";
			$sql .= "ON taxIncludedPriceRange.makerCode = modelGradeList.makerCode AND taxIncludedPriceRange.modelCode = modelGradeList.modelCode ";

			// ソート順１（検索ログ）
			$sql .= "LEFT JOIN ( ";
			$sql .= "    SELECT searchLog.makerCode, searchLog.modelCode, COUNT(*) as cnt ";
			$sql .= "    FROM {$DBName_Base}.searchLog ";
			$sql .= "    WHERE searchLog.makerCode IS NOT NULL ";
			$sql .= "    AND searchLog.modelCode IS NOT NULL ";
			$sql .= "    GROUP BY searchLog.makerCode, searchLog.modelCode ";
			$sql .= ") sort1 ";
			$sql .= "ON sort1.makerCode = modelGradeList.makerCode AND sort1.modelCode = modelGradeList.modelCode ";

			// ソート順２（メーカー並び順、車種名称）
			$sql .= "LEFT JOIN ( ";
			$sql .= "    SELECT model.makerCode, model.modelCode, maker.dispNum, model.modelName ";
			$sql .= "    FROM {$DBName_active}.model ";
			$sql .= "    LEFT JOIN {$DBName_active}.maker ";
			$sql .= "    ON maker.makerCode = model.makerCode ";
			$sql .= ") sort2 ";
			$sql .= "ON sort2.makerCode = modelGradeList.makerCode AND sort2.modelCode = modelGradeList.modelCode ";

			// 検索ログ数順にソート
			$sql .= "ORDER BY sort1.cnt DESC, sort2.dispNum, sort2.modelName ";

			// 取得範囲設定
			$limitStart = ($input["pageNum"] - 1) * $ini["page"]["ranking"];

			$sql_escape["limitStart"] = sql_escapeString($limitStart);
			$sql_escape["ranking"]    = sql_escapeString($ini["page"]["ranking"]);

			$sql .= "LIMIT  {$sql_escape["limitStart"]},  {$sql_escape["ranking"]}";
			$ret = sql_query( $sql );

			return $ret;

		}


		/*----------------------------------------------------
		  対象車種数取得
		  get_carGradeList からカウント処理のみ切り出し
		----------------------------------------------------*/

		function get_carGradeNum( $input ) {

			global $ini;

			// ＤＢ名取得
			$DBName = get_DBName( "active" );

			//---------------------------------
			// WHERE句定義
			//---------------------------------
			// バリュー
			for( $i = 0; $i < count($input["theme"]); $i++ ){
				if( is_numeric($input["theme"][$i]) ){
				$tmp["theme"][] = "'" . sql_escapeString($input["theme"][$i]) ."'";
				}
			}
			if( count($tmp["theme"]) > 0 ){
				$sql_in_themeID = implode(",", $tmp["theme"]);
				$sql_escape["sql_in_themeID"] = $sql_in_themeID;
			}

			// メーカー
			for( $i = 0; $i < count($input["maker"]); $i++ ){
				if( is_numeric($input["maker"][$i]) ){
					$tmp["maker"][] = "'" . sql_escapeString($input["maker"][$i]) . "'";
				}
			}
			if( count($tmp["maker"]) > 0 ){
				$sql_in_makerCode = implode(",", $tmp["maker"]);
				$sql_escape["sql_in_makerCode"] = $sql_in_makerCode;
			}

			// ボディ
			for( $i = 0; $i < count($input["bodyModel"]); $i++ ){
				if( is_numeric($input["bodyModel"][$i]) ){
					$tmp["bodyModel"][] = "'" . sql_escapeString($input["bodyModel"][$i]) . "'";
				}
			}
			if( count($tmp["bodyModel"]) > 0 ){
				$sql_in_bodyModel = implode(",", $tmp["bodyModel"]);
				$sql_escape["sql_in_bodyModel"] = $sql_in_bodyModel;
			}

			// 価格
			if( !is_numeric($input["price"]) ){
				$input["price"] = $ini["carPriceNotID"];
			}

			$carPrice = $ini["carPrice"][$input["price"]];
			if( !empty($carPrice["priceMax"])){
				$sql_price_from = $carPrice["priceMin"];
				$sql_price_to   = $carPrice["priceMax"];

				$sql_escape["sql_price_from"] = sql_escapeString($sql_price_from);
				$sql_escape["sql_price_to"]   = sql_escapeString($sql_price_to);
			} else {
				$sql_price_from = $carPrice["priceMin"];
				$sql_escape["sql_price_from"] = sql_escapeString($sql_price_from);
			}
			// 価格「指定なし」選択時
			if( $input["price"] == "6" ){
				$sql_price_from = "";
				$sql_price_to   = "";

				$sql_escape["sql_price_from"] = sql_escapeString($sql_price_from);
				$sql_escape["sql_price_to"]   = sql_escapeString($sql_price_to);
			}

			//--------------------------------------------------------------
			// 価格が指定された場合、代表グレードの優先順位を変える
			//--------------------------------------------------------------
			if( !empty($sql_price_from) || !empty($sql_price_to) ){
				$s2wdGrade     = "2_s2wd";
				$s4wdGrade     = "3_s4wd";
				$lowPriceGrade = "1_lowPrice";
			}else{
				$s2wdGrade     = "1_s2wd";
				$s4wdGrade     = "2_s4wd";
				$lowPriceGrade = "3_lowPrice";
			}
			$sql_escape["s2wdGrade"]     = sql_escapeString($s2wdGrade);
			$sql_escape["s4wdGrade"]     = sql_escapeString($s4wdGrade);
			$sql_escape["lowPriceGrade"] = sql_escapeString($lowPriceGrade);


			//---------------------------------
			// SQL作成
			//---------------------------------
			$sql  = "";
			$sql .= "SELECT ";
			$sql .= "    modelGradeList.makerCode, modelGradeList.modelCode ";
			$sql .= "FROM ( ";
			$sql .= "    SELECT tmp.makerCode, tmp.modelCode, tmp.carGradeID, tmp.taxIncludedPrice, tmp.bodyModel, tmp.bodyModelName, tmp.grade ";
			$sql .= "    FROM ( ";
			$sql .= "        SELECT ";
			$sql .= "            m.makerCode, ";
			$sql .= "            m.modelCode, ";
			$sql .= "            s2wd.carGradeID, ";
			$sql .= "            CAST(s2wd.taxIncludedPrice as SIGNED) as taxIncludedPrice, ";
			$sql .= "            s2wd.bodyModel, ";
			$sql .= "            s2wd.bodyModelName, ";
			$sql .= "            '{$sql_escape["s2wdGrade"]}' as grade ";
			$sql .= "        FROM {$DBName}.model m ";
			$sql .= "        LEFT JOIN {$DBName}.carGrade s2wd ON m.s2wdCarGradeID = s2wd.carGradeID ";
			$sql .= " ";
			$sql .= "        UNION ALL ";
			$sql .= "        SELECT ";
			$sql .= "            m.makerCode, ";
			$sql .= "            m.modelCode, ";
			$sql .= "            s4wd.carGradeID, ";
			$sql .= "            CAST(s4wd.taxIncludedPrice as SIGNED) as taxIncludedPrice, ";
			$sql .= "            s4wd.bodyModel, ";
			$sql .= "            s4wd.bodyModelName, ";
			$sql .= "            '{$sql_escape["s4wdGrade"]}' as grade ";
			$sql .= "        FROM {$DBName}.model m ";
			$sql .= "        LEFT JOIN {$DBName}.carGrade s4wd ON m.s4wdCarGradeID = s4wd.carGradeID ";
			$sql .= " ";
			$sql .= "        UNION ALL ";
			$sql .= "        SELECT ";
			$sql .= "            m.makerCode, ";
			$sql .= "            m.modelCode, ";
			$sql .= "            lowPrice.carGradeID, ";
			$sql .= "            CAST(lowPrice.taxIncludedPrice as SIGNED) as taxIncludedPrice, ";
			$sql .= "            lowPrice.bodyModel, ";
			$sql .= "            lowPrice.bodyModelName, ";
			$sql .= "            '{$sql_escape["lowPriceGrade"]}' as grade ";
			$sql .= "        FROM {$DBName}.model m ";
			$sql .= "        LEFT JOIN {$DBName}.carGrade lowPrice ON m.lowPriceCarGradeID = lowPrice.carGradeID ";
			$sql .= "    ) tmp ";
			$sql .= "    WHERE tmp.taxIncludedPrice IS NOT NULL ";
			// メーカー
			if( !empty($sql_in_makerCode) ){
				$sql .= "    AND tmp.makerCode IN ( {$sql_escape["sql_in_makerCode"]} ) ";
			}
			// バリュー
			if( !empty($sql_in_themeID) ){
				$sql .= "    AND EXISTS ( ";
				$sql .= "        SELECT * ";
				$sql .= "        FROM {$DBName}.carTheme as ct ";
				$sql .= "        WHERE ct.makerCode = tmp.makerCode ";
				$sql .= "        AND ct.modelCode = tmp.modelCode ";
				$sql .= "        AND ct.themeID IN ( {$sql_escape["sql_in_themeID"]} ) ";
				$sql .= "        GROUP BY ct.makerCode, ct.modelCode ";
				$sql .= "        HAVING count(ct.themeID) >= '" . sql_escapeString(count($tmp["theme"])) . "' ";
				$sql .= "    ) ";
			}
			$sql .= "    AND ( ( ";
			$sql .= "            tmp.grade = '{$sql_escape["s2wdGrade"]}' ";
			// ボディタイプ
			if( !empty($sql_in_bodyModel) ){
				$sql .= "            AND tmp.bodyModel IN ( {$sql_escape["sql_in_bodyModel"]} ) ";
			}
			// 価格
			if( !empty($sql_price_from) ){
				$sql .= "            AND CAST(tmp.taxIncludedPrice as SIGNED) >= '{$sql_escape["sql_price_from"]}' ";
			}
			if( !empty($sql_price_to) ){
				$sql .= "            AND CAST(tmp.taxIncludedPrice as SIGNED) <= '{$sql_escape["sql_price_to"]}' ";
			}
			$sql .= "        ) OR ( ";
			$sql .= "            tmp.grade = '{$sql_escape["s4wdGrade"]}' ";
			// ボディタイプ
			if( !empty($sql_in_bodyModel) ){
				$sql .= "            AND tmp.bodyModel IN ( {$sql_escape["sql_in_bodyModel"]} ) ";
			}
			// 価格
			if( !empty($sql_price_from) ){
				$sql .= "            AND CAST(tmp.taxIncludedPrice as SIGNED) >= '{$sql_escape["sql_price_from"]}' ";
			}
			if( !empty($sql_price_to) ){
				$sql .= "            AND CAST(tmp.taxIncludedPrice as SIGNED) <= '{$sql_escape["sql_price_to"]}' ";
			}
			$sql .= "        ) OR ( ";
			$sql .= "            tmp.grade = '{$sql_escape["lowPriceGrade"]}' ";
			// ボディタイプ
			if( !empty($sql_in_bodyModel) ){
				$sql .= "            AND tmp.bodyModel IN ( {$sql_escape["sql_in_bodyModel"]} ) ";
			}
			// 価格
			if( !empty($sql_price_from) ){
				$sql .= "            AND CAST(tmp.taxIncludedPrice as SIGNED) >= '{$sql_escape["sql_price_from"]}' ";
			}
			if( !empty($sql_price_to) ){
				$sql .= "            AND CAST(tmp.taxIncludedPrice as SIGNED) <= '{$sql_escape["sql_price_to"]}' ";
			}
			$sql .= "        ) ";
			$sql .= "    ) ";

			$sql .= ") modelGradeList ";
			$sql .= "GROUP BY modelGradeList.makerCode, modelGradeList.modelCode ";

			$ret = sql_query( $sql );

			return count($ret);

		}


		/*----------------------------------------------------
		  車種変更画面の検索結果取得
		----------------------------------------------------*/
		function get_changeTargetCar( $input ) {

			global $ini;

			// ＤＢ名取得
			$DBName_active = get_DBName( "active" );

			//---------------------------------
			// WHERE句定義
			//---------------------------------
			// メーカー
			for( $i = 0; $i < count($input["maker"]); $i++ ){
				if( is_numeric($input["maker"][$i]) ){
					$tmp["maker"][] = "'" . sql_escapeString($input["maker"][$i]) . "'";
				}
			}
			if( count($tmp["maker"]) > 0 ){
				$sql_in_makerCode = implode(",", $tmp["maker"]);
				$sql_escape["sql_in_makerCode"] = $sql_in_makerCode;
			}

			// ボディ
			for( $i = 0; $i < count($input["bodyModel"]); $i++ ){
				if( is_numeric($input["bodyModel"][$i]) ){
					$tmp["bodyModel"][] = "'" . sql_escapeString($input["bodyModel"][$i]) . "'";
				}
			}
			if( count($tmp["bodyModel"]) > 0 ){
				$sql_in_bodyModel = implode(",", $tmp["bodyModel"]);
				$sql_escape["sql_in_bodyModel"] = $sql_in_bodyModel;
			}

			// 価格
			if( !is_numeric($input["price"]) ){
				$input["price"] = $ini["carPriceNotID"];
			}

			$carPrice = $ini["carPrice"][$input["price"]];
			if( !empty($carPrice["priceMax"])){
				$sql_price_from = $carPrice["priceMin"];
				$sql_price_to   = $carPrice["priceMax"];

				$sql_escape["sql_price_from"] = sql_escapeString($sql_price_from);
				$sql_escape["sql_price_to"]   = sql_escapeString($sql_price_to);
			} else {
				$sql_price_from = $carPrice["priceMin"];
				$sql_escape["sql_price_from"] = sql_escapeString($sql_price_from);
			}
			// 価格「指定なし」選択時
			if( $input["price"] == "6" ){
				$sql_price_from = "";
				$sql_price_to   = "";

				$sql_escape["sql_price_from"] = sql_escapeString($sql_price_from);
				$sql_escape["sql_price_to"]   = sql_escapeString($sql_price_to);
			}

			//--------------------------------------------------------------
			// 価格が指定された場合、代表グレードの優先順位を変える
			//--------------------------------------------------------------
			if( !empty($sql_price_from) || !empty($sql_price_to) ){
				$s2wdGrade     = "2_s2wd";
				$s4wdGrade     = "3_s4wd";
				$lowPriceGrade = "1_lowPrice";
			}else{
				$s2wdGrade     = "1_s2wd";
				$s4wdGrade     = "2_s4wd";
				$lowPriceGrade = "3_lowPrice";
			}
			$sql_escape["s2wdGrade"]     = sql_escapeString($s2wdGrade);
			$sql_escape["s4wdGrade"]     = sql_escapeString($s4wdGrade);
			$sql_escape["lowPriceGrade"] = sql_escapeString($lowPriceGrade);

			//---------------------------------
			// SQL作成
			//---------------------------------
			// $sql_from_where は、modelGradeList, defaultGrade を作成するときの FROM句～WHERE句まで
			$sql_from_where  = "";
			$sql_from_where .= "    FROM ( ";
			$sql_from_where .= "        SELECT ";
			$sql_from_where .= "            m.makerCode, ";
			$sql_from_where .= "            m.modelCode, ";
			$sql_from_where .= "            s2wd.carGradeID, ";
			$sql_from_where .= "            CAST(s2wd.taxIncludedPrice as SIGNED) as taxIncludedPrice, ";
			$sql_from_where .= "            s2wd.bodyModel, ";
			$sql_from_where .= "            s2wd.bodyModelName, ";
			$sql_from_where .= "            '{$sql_escape["s2wdGrade"]}' as grade ";
			$sql_from_where .= "        FROM {$DBName_active}.model m ";
			$sql_from_where .= "        LEFT JOIN {$DBName_active}.carGrade s2wd ON m.s2wdCarGradeID = s2wd.carGradeID ";
			$sql_from_where .= " ";
			$sql_from_where .= "        UNION ALL ";
			$sql_from_where .= "        SELECT ";
			$sql_from_where .= "            m.makerCode, ";
			$sql_from_where .= "            m.modelCode, ";
			$sql_from_where .= "            s4wd.carGradeID, ";
			$sql_from_where .= "            CAST(s4wd.taxIncludedPrice as SIGNED) as taxIncludedPrice, ";
			$sql_from_where .= "            s4wd.bodyModel, ";
			$sql_from_where .= "            s4wd.bodyModelName, ";
			$sql_from_where .= "            '{$sql_escape["s4wdGrade"]}' as grade ";
			$sql_from_where .= "        FROM {$DBName_active}.model m ";
			$sql_from_where .= "        LEFT JOIN {$DBName_active}.carGrade s4wd ON m.s4wdCarGradeID = s4wd.carGradeID ";
			$sql_from_where .= " ";
			$sql_from_where .= "        UNION ALL ";
			$sql_from_where .= "        SELECT ";
			$sql_from_where .= "            m.makerCode, ";
			$sql_from_where .= "            m.modelCode, ";
			$sql_from_where .= "            lowPrice.carGradeID, ";
			$sql_from_where .= "            CAST(lowPrice.taxIncludedPrice as SIGNED) as taxIncludedPrice, ";
			$sql_from_where .= "            lowPrice.bodyModel, ";
			$sql_from_where .= "            lowPrice.bodyModelName, ";
			$sql_from_where .= "            '{$sql_escape["lowPriceGrade"]}' as grade ";
			$sql_from_where .= "        FROM {$DBName_active}.model m ";
			$sql_from_where .= "        LEFT JOIN {$DBName_active}.carGrade lowPrice ON m.lowPriceCarGradeID = lowPrice.carGradeID ";
			$sql_from_where .= "    ) tmp ";
			$sql_from_where .= "    WHERE tmp.taxIncludedPrice IS NOT NULL ";
			// メーカー
			if( !empty($sql_in_makerCode) ){
				$sql_from_where .= "    AND tmp.makerCode IN ( {$sql_escape["sql_in_makerCode"]} ) ";
			}

			$sql_from_where .= "    AND ( ( ";
			$sql_from_where .= "            tmp.grade = '{$sql_escape["s2wdGrade"]}' ";
			// ボディタイプ
			if( !empty($sql_in_bodyModel) ){
				$sql_from_where .= "            AND tmp.bodyModel IN ( {$sql_escape["sql_in_bodyModel"]} ) ";
			}
			// 価格
			if( !empty($sql_price_from) ){
				$sql_from_where .= "            AND CAST(tmp.taxIncludedPrice as SIGNED) >= '{$sql_escape["sql_price_from"]}' ";
			}
			if( !empty($sql_price_to) ){
				$sql_from_where .= "            AND CAST(tmp.taxIncludedPrice as SIGNED) <= '{$sql_escape["sql_price_to"]}' ";
			}
			$sql_from_where .= "        ) OR ( ";
			$sql_from_where .= "            tmp.grade = '{$sql_escape["s4wdGrade"]}' ";
			// ボディタイプ
			if( !empty($sql_in_bodyModel) ){
				$sql_from_where .= "            AND tmp.bodyModel IN ( {$sql_escape["sql_in_bodyModel"]} ) ";
			}
			// 価格
			if( !empty($sql_price_from) ){
				$sql_from_where .= "            AND CAST(tmp.taxIncludedPrice as SIGNED) >= '{$sql_escape["sql_price_from"]}' ";
			}
			if( !empty($sql_price_to) ){
				$sql_from_where .= "            AND CAST(tmp.taxIncludedPrice as SIGNED) <= '{$sql_escape["sql_price_to"]}' ";
			}
			$sql_from_where .= "        ) OR ( ";
			$sql_from_where .= "            tmp.grade = '{$sql_escape["lowPriceGrade"]}' ";
			// ボディタイプ
			if( !empty($sql_in_bodyModel) ){
				$sql_from_where .= "            AND tmp.bodyModel IN ( {$sql_escape["sql_in_bodyModel"]} ) ";
			}
			// 価格
			if( !empty($sql_price_from) ){
				$sql_from_where .= "            AND CAST(tmp.taxIncludedPrice as SIGNED) >= '{$sql_escape["sql_price_from"]}' ";
			}
			if( !empty($sql_price_to) ){
				$sql_from_where .= "            AND CAST(tmp.taxIncludedPrice as SIGNED) <= '{$sql_escape["sql_price_to"]}' ";
			}
			$sql_from_where .= "        ) ";
			$sql_from_where .= "    ) ";


			//---------------------------
			// 以下、発効するSQL
			//---------------------------
			$sql  = "";
			$sql .= "SELECT ";
			$sql .= "    modelGradeList.makerCode, ";
			$sql .= "    modelGradeList.modelCode, ";
			$sql .= "    modelGradeList.carGradeID, ";
			$sql .= "    modelGradeList.grade, ";
			$sql .= "    modelGradeList.bodyModel, ";
			$sql .= "    makerModelList.dispNum, ";
			$sql .= "    makerModelList.makerName, ";
			$sql .= "    makerModelList.modelName, ";
			$sql .= "    makerModelList.modelNameEng ";
			$sql .= "FROM ( ";
			$sql .= "    SELECT tmp.makerCode, tmp.modelCode, tmp.carGradeID, tmp.taxIncludedPrice, tmp.bodyModel, tmp.bodyModelName, tmp.grade ";
			$sql .= "    {$sql_from_where} ";
			$sql .= ") modelGradeList ";
			
			// modelGradeListから車種別のデフォルトグレードを取得する。この結果でmodelGradeListを絞り込む。
			$sql .= "INNER JOIN ( ";
			$sql .= "    SELECT tmp.makerCode, tmp.modelCode, MIN(grade) as grade ";
			$sql .= "    {$sql_from_where} ";
			$sql .= "    GROUP BY tmp.makerCode, tmp.modelCode ";
			$sql .= ") defaultGrade ";
			$sql .= "ON defaultGrade.makerCode = modelGradeList.makerCode AND defaultGrade.modelCode = modelGradeList.modelCode AND defaultGrade.grade = modelGradeList.grade ";

			// メーカー車種情報
			$sql .= "LEFT JOIN ( ";
			$sql .= "    SELECT model.makerCode, model.modelCode, maker.dispNum, maker.makerName, model.modelName, model.modelNameEng ";
			$sql .= "    FROM {$DBName_active}.model ";
			$sql .= "    LEFT JOIN {$DBName_active}.maker ";
			$sql .= "    ON maker.makerCode = model.makerCode ";
			$sql .= ") makerModelList ";
			$sql .= "ON makerModelList.makerCode = modelGradeList.makerCode AND makerModelList.modelCode = modelGradeList.modelCode ";

			$tmp1 = sql_query( $sql );

			// 名称で並べ替え
			$codelist = array();
			$tmp2["lux"] = array();
			$tmp2["entry"] = array();

			if( count($tmp1) > 0 ){
				foreach($tmp1 as $value){
					// 優先名称を通常名称に更新
					$value["bodyModelID"] = $value["bodyModel"];
					$value["bodyModel"]   = get_bodyTypeName($value["bodyModel"]);

					// クラスを分けつつ並び替え（メーカー表示順、ボディタイプ表示順、車種名昇順）
					if( get_makerClassFlg($value["makerCode"]) ){
						//Lux.クラス
						$tmp2["lux"][ str_pad($value["dispNum"], 3, "0", STR_PAD_LEFT) . "," . str_pad($value["bodyModelID"], 3, "0", STR_PAD_LEFT) . "," . $value["modelName"] ] = $value;
					} else {
						//entryクラス
						$tmp2["entry"][ str_pad($value["dispNum"], 3, "0", STR_PAD_LEFT) . "," . str_pad($value["bodyModelID"], 3, "0", STR_PAD_LEFT) . "," . $value["modelName"] ] = $value;
					}
				}

				ksort($tmp2);
				ksort($tmp2["entry"]);
				ksort($tmp2["lux"]);

				$ret = array();
				foreach($tmp2 as $key => $list){
					foreach($list as $value){
						$ret[] = $value;
					}
				}
			}

			return $ret;

		}


		/*----------------------------------------------------
		  グレード情報をタグ出力用文言に変換する
		  装備タイプの画像についてはimgタグごと設定する
		----------------------------------------------------*/
		function convert_disp ( $info ) {

			//----------------------------
			// 車種グレード
			//----------------------------
			$infoNew = $info["carGrade"];

			//---------------------------------
			// 車種グレード（基本スペック情報）
			//---------------------------------
			
			// 車型
			$infoNew["bodyModel"]     = isset( $info["carGrade"]["bodyModel"] ) ? $info["carGrade"]["bodyModel"] : "&nbsp;";
			$infoNew["bodyModelName"] = isset( $info["carGrade"]["bodyModelName"] ) ? get_bodyTypeName($info["carGrade"]["bodyModel"]) : "&nbsp;";

			// 車両本体価格
			$infoNew["taxIncludedPrice"] = isset( $info["carGrade"]["taxIncludedPrice"] ) ? "&yen; " . number_format($info["carGrade"]["taxIncludedPrice"]) ." &ndash;" : "&nbsp;";

			// 乗車定員
			$infoNew["capacity"] = isset( $info["carGrade"]["capacity"] ) ? $info["carGrade"]["capacity"] . "人" : "&nbsp;";

			// 駆動方式／排気量
			if( isset( $info["carGrade"]["driveSystem"] ) && isset( $info["carGrade"]["totalEmission"] ) ){
				$infoNew["driveSystem_totalEmission"] = $info["carGrade"]["driveSystem"] . "／" . $info["carGrade"]["totalEmission"] . " cc";
			}else if( isset( $info["carGrade"]["driveSystem"] ) ){
				$infoNew["driveSystem_totalEmission"] = $info["carGrade"]["driveSystem"];
			}else if( isset( $info["carGrade"]["totalEmission"] ) ){
				$infoNew["driveSystem_totalEmission"] = $info["carGrade"]["totalEmission"] . " cc";
			}else{
				$infoNew["driveSystem_totalEmission"] = "&nbsp;";
			}

			// 燃料消費率 JC08
			$infoNew["fuelConsumptionRateJC08mode"] = isset( $info["carGrade"]["fuelConsumptionRateJC08mode"] ) ? $info["carGrade"]["fuelConsumptionRateJC08mode"] . " km/l" : "－";

			// 燃料消費率 10-15
			$infoNew["fuelConsumptionRate10_15mode"] = isset( $info["carGrade"]["fuelConsumptionRate10_15mode"] ) ? $info["carGrade"]["fuelConsumptionRate10_15mode"] . " km/l" : "－";

			// 全長
			$infoNew["totalLength"] = isset( $info["carGrade"]["totalLength"] ) ? $info["carGrade"]["totalLength"] . " mm" : "&nbsp;";

			// 全幅
			$infoNew["totalWidth"] = isset( $info["carGrade"]["totalWidth"] ) ? $info["carGrade"]["totalWidth"] . " mm" : "&nbsp;";

			// 全高
			$infoNew["totalHeight"] = isset( $info["carGrade"]["totalHeight"] ) ? $info["carGrade"]["totalHeight"] . " mm" : "&nbsp;";

			//---------------------------------
			// 車種グレード（型式タイプ）
			//---------------------------------
			// 車名型式
			$infoNew["carNameModel"] = isset( $info["carGrade"]["carNameModel"] ) ? $info["carGrade"]["carNameModel"] : "&nbsp;";

			// ルーフ形状
			$infoNew["roofModel"] = isset( $info["carGrade"]["roofModel"] ) ? $info["carGrade"]["roofModel"] : "&nbsp;";

			// ドア数
			$infoNew["door"] = isset( $info["carGrade"]["door"] ) ? $info["carGrade"]["door"] . "ドア" : "&nbsp;";

			// トランスミッション
			$infoNew["transmission"] = isset( $info["carGrade"]["transmission"] ) ? $info["carGrade"]["transmission"] : "&nbsp;";

			// 駆動方式名称
			$infoNew["driveSystemName"] = isset( $info["carGrade"]["driveSystemName"] ) ? $info["carGrade"]["driveSystemName"] : "&nbsp;";

			//---------------------------------
			// 車種グレード（寸法）
			//---------------------------------
			// 全長
			$infoNew["totalLength"] = isset( $info["carGrade"]["totalLength"] ) ? $info["carGrade"]["totalLength"] . " mm" : "&nbsp;";

			// 全幅
			$infoNew["totalWidth"] = isset( $info["carGrade"]["totalWidth"] ) ? $info["carGrade"]["totalWidth"] . " mm" : "&nbsp;";

			// 全高
			$infoNew["totalHeight"] = isset( $info["carGrade"]["totalHeight"] ) ? $info["carGrade"]["totalHeight"] . " mm" : "&nbsp;";

			// 室内寸法 長
			$infoNew["roomLength"] = isset( $info["carGrade"]["roomLength"] ) ? $info["carGrade"]["roomLength"] . " mm" : "&nbsp;";

			// 室内寸法 幅
			$infoNew["roomWidth"] = isset( $info["carGrade"]["roomWidth"] ) ? $info["carGrade"]["roomWidth"] . " mm" : "&nbsp;";

			// 室内寸法 高
			$infoNew["roomHeight"] = isset( $info["carGrade"]["roomHeight"] ) ? $info["carGrade"]["roomHeight"] . " mm" : "&nbsp;";

			// ホイールベース
			$infoNew["wheelbase"] = isset( $info["carGrade"]["wheelbase"] ) ? $info["carGrade"]["wheelbase"] . " mm" : "&nbsp;";

			// トレッド 前
			$infoNew["frontTread"] = isset( $info["carGrade"]["frontTread"] ) ? $info["carGrade"]["frontTread"] . " mm" : "&nbsp;";

			// トレッド 後
			$infoNew["rearTread"] = isset( $info["carGrade"]["rearTread"] ) ? $info["carGrade"]["rearTread"] . " mm" : "&nbsp;";

			// 最低地上高
			$infoNew["minHeight"] = isset( $info["carGrade"]["minHeight"] ) ? $info["carGrade"]["minHeight"] . " mm" : "&nbsp;";

			// 種別
			$infoNew["type"] = isset( $info["carGrade"]["type"] ) ? $info["carGrade"]["type"] : "&nbsp;";

			//---------------------------------
			// 車種グレード（重量・定員）
			//---------------------------------
			// 車両重量
			$infoNew["vehicleWeight"] = isset( $info["carGrade"]["vehicleWeight"] ) ? $info["carGrade"]["vehicleWeight"] . " kg" : "&nbsp;";

			// 車両総重量
			$infoNew["vehicleTotalWeight"] = isset( $info["carGrade"]["vehicleTotalWeight"] ) ? $info["carGrade"]["vehicleTotalWeight"] . " kg" : "&nbsp;";

			// 乗車定員
			$infoNew["capacity"] = isset( $info["carGrade"]["capacity"] ) ? $info["carGrade"]["capacity"] . "人" : "&nbsp;";

			//---------------------------------
			// 車種グレード（性能）
			//---------------------------------
			// 最小回転半径
			$infoNew["turningCircle"] = isset( $info["carGrade"]["turningCircle"] ) ? $info["carGrade"]["turningCircle"] . " m" : "&nbsp;";

			// 燃料消費率 JC08
			$infoNew["fuelConsumptionRateJC08mode"] = isset( $info["carGrade"]["fuelConsumptionRateJC08mode"] ) ? $info["carGrade"]["fuelConsumptionRateJC08mode"] . " km/l" : "－";

			// 燃料消費率 10-15
			$infoNew["fuelConsumptionRate10_15mode"] = isset( $info["carGrade"]["fuelConsumptionRate10_15mode"] ) ? $info["carGrade"]["fuelConsumptionRate10_15mode"] . " km/l" : "－";

			// 適合規制・認定レベル
			$infoNew["recognitionLevel"] = isset( $info["carGrade"]["recognitionLevel"] ) ? $info["carGrade"]["recognitionLevel"] : "&nbsp;";

			//---------------------------------
			// 車種グレード（諸装置）
			//---------------------------------
			// 駆動方式
			$infoNew["driveSystem"] = isset( $info["carGrade"]["driveSystem"] ) ? $info["carGrade"]["driveSystem"] : "&nbsp;";

			// ハンドル位置
			$infoNew["handlePosition"] = isset( $info["carGrade"]["handlePosition"] ) ? $info["carGrade"]["handlePosition"] : "&nbsp;";

			// ステアリングギヤ形式
			$infoNew["steeringGearModel"] = isset( $info["carGrade"]["steeringGearModel"] ) ? $info["carGrade"]["steeringGearModel"] : "&nbsp;";

			// サスペンション 前
			$infoNew["frontSuspension"] = isset( $info["carGrade"]["frontSuspension"] ) ? $info["carGrade"]["frontSuspension"] : "&nbsp;";

			// サスペンション 後
			$infoNew["rearSuspension"] = isset( $info["carGrade"]["rearSuspension"] ) ? $info["carGrade"]["rearSuspension"] : "&nbsp;";

			// 主ブレーキ 前
			$infoNew["frontMainBrake"] = isset( $info["carGrade"]["frontMainBrake"] ) ? $info["carGrade"]["frontMainBrake"] : "&nbsp;";

			// 主ブレーキ 後
			$infoNew["rearMainBrake"] = isset( $info["carGrade"]["rearMainBrake"] ) ? $info["carGrade"]["rearMainBrake"] : "&nbsp;";

			// タイヤ 前
			$infoNew["frontTire"] = isset( $info["carGrade"]["frontTire"] ) ? $info["carGrade"]["frontTire"] : "&nbsp;";

			// タイヤ 後
			$infoNew["rearTire"] = isset( $info["carGrade"]["rearTire"] ) ? $info["carGrade"]["rearTire"] : "&nbsp;";

			//---------------------------------
			// 車種グレード（エンジン主要諸元）
			//---------------------------------
			// エンジン型式
			$infoNew["engineModel"] = isset( $info["carGrade"]["engineModel"] ) ? $info["carGrade"]["engineModel"] : "&nbsp;";

			// 種類・シリンダー数
			$infoNew["cylinderType"] = isset( $info["carGrade"]["cylinderType"] ) ? $info["carGrade"]["cylinderType"] : "&nbsp;";

			// エンジン種類
			$infoNew["engineKind"] = isset( $info["carGrade"]["engineKind"] ) ? $info["carGrade"]["engineKind"] : "&nbsp;";

			// 気筒配列
			$infoNew["cylinderArr"] = isset( $info["carGrade"]["cylinderArr"] ) ? $info["carGrade"]["cylinderArr"] : "&nbsp;";

			// 気筒数
			$infoNew["cylinderAmount"] = isset( $info["carGrade"]["cylinderAmount"] ) ? $info["carGrade"]["cylinderAmount"] : "&nbsp;";

			// バルブ数
			$infoNew["valveAmount"] = isset( $info["carGrade"]["valveAmount"] ) ? $info["carGrade"]["valveAmount"] : "&nbsp;";

			// シリンダー内径
			$infoNew["cylinderBore"] = isset( $info["carGrade"]["cylinderBore"] ) ? $info["carGrade"]["cylinderBore"] . " mm" : "&nbsp;";

			// シリンダー行程
			$infoNew["cylinderStroke"] = isset( $info["carGrade"]["cylinderStroke"] ) ? $info["carGrade"]["cylinderStroke"] . " mm" : "&nbsp;";

			// 総排気量
			$infoNew["totalEmission"] = isset( $info["carGrade"]["totalEmission"] ) ? $info["carGrade"]["totalEmission"] . " cc" : "&nbsp;";

			// 圧縮比
			$infoNew["compressionRatio"] = isset( $info["carGrade"]["compressionRatio"] ) ? $info["carGrade"]["compressionRatio"] : "&nbsp;";

			// 最高出力
			$infoNew["maxPower"] = isset( $info["carGrade"]["maxPower"] ) ? $info["carGrade"]["maxPower"] : "&nbsp;";

			// 最大トルク
			$infoNew["maxTorque"] = isset( $info["carGrade"]["maxTorque"] ) ? $info["carGrade"]["maxTorque"] : "&nbsp;";

			// 燃料供給装置
			$infoNew["fuelSupplySystem"] = isset( $info["carGrade"]["fuelSupplySystem"] ) ? $info["carGrade"]["fuelSupplySystem"] : "&nbsp;";

			// 使用燃料
			$infoNew["useFuel"] = isset( $info["carGrade"]["useFuel"] ) ? $info["carGrade"]["useFuel"] : "&nbsp;";

			// 給油口位置
			$infoNew["fillOpeningPosition"] = isset( $info["carGrade"]["fillOpeningPosition"] ) ? $info["carGrade"]["fillOpeningPosition"] : "&nbsp;";

			// タンク容量
			$infoNew["tankVolume"] = isset( $info["carGrade"]["tankVolume"] ) ? $info["carGrade"]["tankVolume"] . " L" : "&nbsp;";

			$info["carGrade"] = $infoNew;



			//----------------------------
			// 視界
			//----------------------------
			$infoNew = $info["view"];

			// キセノンヘッドランプ
			$infoNew["xenonHeadlampDisp"] = $this->getItemTypeImg( $info["view"]["xenonHeadlampType"], $info["view"]["xenonHeadlampName"] );

			// プロジェクターヘッドランプ
			$infoNew["projectorHeadlampDisp"] = $this->getItemTypeImg( $info["view"]["projectorHeadlampType"], $info["view"]["projectorHeadlampName"] );

			// フォグランプ（フロント）
			$infoNew["frontFogLampDisp"] = $this->getItemTypeImg( $info["view"]["frontFogLampType"], $info["view"]["frontFogLampName"] );

			// フォグランプ（リヤ）
			$infoNew["rearFogLampDisp"] = $this->getItemTypeImg( $info["view"]["rearFogLampType"], $info["view"]["rearFogLampName"] );

			// バックビューモニター
			$infoNew["backViewMonitorDisp"] = $this->getItemTypeImg( $info["view"]["backViewMonitorType"], $info["view"]["backViewMonitorName"] );

			// アクティブＡＦＳ
			$infoNew["activeAFSDisp"] = $this->getItemTypeImg( $info["view"]["activeAFSType"], $info["view"]["activeAFSName"] );

			// オートライトシステム
			$infoNew["autoLightSystemDisp"] = $this->getItemTypeImg( $info["view"]["autoLightSystemType"], $info["view"]["autoLightSystemName"] );

			// 電動リモコンドアミラー
			$infoNew["remoteDoorMirrorDisp"] = $this->getItemTypeImg( $info["view"]["remoteDoorMirrorType"], $info["view"]["remoteDoorMirrorName"] );

			// 電動格納式ドアミラー
			$infoNew["storageDoorMirrorDisp"] = $this->getItemTypeImg( $info["view"]["storageDoorMirrorType"], $info["view"]["storageDoorMirrorName"] );

			// ヒーターミラー
			$infoNew["heaterMirrorDisp"] = $this->getItemTypeImg( $info["view"]["heaterMirrorType"], $info["view"]["heaterMirrorName"] );

			// リバース電動ミラー
			$infoNew["reverseMirrorDisp"] = $this->getItemTypeImg( $info["view"]["reverseMirrorType"], $info["view"]["reverseMirrorName"] );

			// ＵＶカットガラス（フロント）
			$infoNew["frontUVBlockGlassDisp"] = $this->getItemTypeImg( $info["view"]["frontUVBlockGlassType"], $info["view"]["frontUVBlockGlassName"] );

			// ＵＶカットガラス（リヤ）
			$infoNew["rearUVBlockGlassDisp"] = $this->getItemTypeImg( $info["view"]["rearUVBlockGlassType"], $info["view"]["rearUVBlockGlassName"] );

			// ＵＶカットガラス（サイド）
			$infoNew["sideUVBlockGlassDisp"] = $this->getItemTypeImg( $info["view"]["sideUVBlockGlassType"], $info["view"]["sideUVBlockGlassName"] );

			// ＵＶカットガラス（フロントドア）
			$infoNew["frontDoorUVBlockGlassDisp"] = $this->getItemTypeImg( $info["view"]["frontDoorUVBlockGlassType"], $info["view"]["frontDoorUVBlockGlassName"] );

			// ＵＶカットガラス（リヤドア）
			$infoNew["rearDoorUVBlockGlassDisp"] = $this->getItemTypeImg( $info["view"]["rearDoorUVBlockGlassType"], $info["view"]["rearDoorUVBlockGlassName"] );

			// プライバシーガラス（リヤ）
			$infoNew["rearPrivacyGlassDisp"] = $this->getItemTypeImg( $info["view"]["rearPrivacyGlassType"], $info["view"]["rearPrivacyGlassName"] );

			// プライバシーガラス（リヤドア）
			$infoNew["rearDoorPrivacyGlassDisp"] = $this->getItemTypeImg( $info["view"]["rearDoorPrivacyGlassType"], $info["view"]["rearDoorPrivacyGlassName"] );

			// プライバシーガラス（サイド）
			$infoNew["sideDoorPrivacyGlassDisp"] = $this->getItemTypeImg( $info["view"]["sideDoorPrivacyGlassType"], $info["view"]["sideDoorPrivacyGlassName"] );

			// コーナーリングランプ
			$infoNew["cornerRingLampDisp"] = $this->getItemTypeImg( $info["view"]["cornerRingLampType"], $info["view"]["cornerRingLampName"] );

			// サイドブラインドモニター
			$infoNew["sideBlindMonitorDisp"] = $this->getItemTypeImg( $info["view"]["sideBlindMonitorType"], $info["view"]["sideBlindMonitorName"] );

			// リヤワイパー
			$infoNew["rearWiperDisp"] = $this->getItemTypeImg( $info["view"]["rearWiperType"], $info["view"]["rearWiperName"] );

			$info["view"] = $infoNew;




			//----------------------------
			// 運転席まわり
			//----------------------------
			$infoNew = $info["seatCircumference"];

			// 本革巻きステアリング
			$infoNew["leatherSteeringDisp"] = $this->getItemTypeImg( $info["seatCircumference"]["leatherSteeringType"], $info["seatCircumference"]["leatherSteeringName"] );

			// ステアリングスイッチ
			$infoNew["steeringSwitchDisp"] = $this->getItemTypeImg( $info["seatCircumference"]["steeringSwitchType"], $info["seatCircumference"]["steeringSwitchName"] );

			// パワーステアリング
			$infoNew["powerSteeringDisp"] = $this->getItemTypeImg( $info["seatCircumference"]["powerSteeringType"], $info["seatCircumference"]["powerSteeringName"] );

			// テレスコピックステアリング
			$infoNew["telescopicSteeringDisp"] = $this->getItemTypeImg( $info["seatCircumference"]["telescopicSteeringType"], $info["seatCircumference"]["telescopicSteeringName"] );

			// チルトステアリング
			$infoNew["tiltSteeringDisp"] = $this->getItemTypeImg( $info["seatCircumference"]["tiltSteeringType"], $info["seatCircumference"]["tiltSteeringName"] );

			// 集中ドアロック
			$infoNew["concentratedDoorLockDisp"] = $this->getItemTypeImg( $info["seatCircumference"]["concentratedDoorLockType"], $info["seatCircumference"]["concentratedDoorLockName"] );

			// インテリジェントキー
			$infoNew["intelligentKeyDisp"] = $this->getItemTypeImg( $info["seatCircumference"]["intelligentKeyType"], $info["seatCircumference"]["intelligentKeyName"] );

			// リモートコントロールエントリーシステム
			$infoNew["remoteEntrySystemDisp"] = $this->getItemTypeImg( $info["seatCircumference"]["remoteEntrySystemType"], $info["seatCircumference"]["remoteEntrySystemName"] );

			// エンジンイモビライザー
			$infoNew["engineImmobilizerDisp"] = $this->getItemTypeImg( $info["seatCircumference"]["engineImmobilizerType"], $info["seatCircumference"]["engineImmobilizerName"] );

			// 車間自動制御システム
			$infoNew["remoteEntrySystemDisp"] = $this->getItemTypeImg( $info["seatCircumference"]["remoteEntrySystemType"], $info["seatCircumference"]["remoteEntrySystemName"] );

			// ASCD（オートスピードコントロール装置
			$infoNew["ASCDDisp"] = $this->getItemTypeImg( $info["seatCircumference"]["ASCDType"], $info["seatCircumference"]["ASCDName"] );

			// タコメーター
			$infoNew["tachometerDisp"] = $this->getItemTypeImg( $info["seatCircumference"]["tachometerType"], $info["seatCircumference"]["tachometerName"] );

			// 自発光メーター
			$infoNew["glowMeterDisp"] = $this->getItemTypeImg( $info["seatCircumference"]["glowMeterType"], $info["seatCircumference"]["glowMeterName"] );

			// 木目調パネル
			$infoNew["woodgrainPanelDisp"] = $this->getItemTypeImg( $info["seatCircumference"]["woodgrainPanelType"], $info["seatCircumference"]["woodgrainPanelName"] );

			// カーボン調パネル
			$infoNew["carbonPanelDisp"] = $this->getItemTypeImg( $info["seatCircumference"]["carbonPanelType"], $info["seatCircumference"]["carbonPanelName"] );

			// ピアノ調パネル
			$infoNew["pianoPanelDisp"] = $this->getItemTypeImg( $info["seatCircumference"]["pianoPanelType"], $info["seatCircumference"]["pianoPanelName"] );

			// メタリック調パネル
			$infoNew["metallicPanelDisp"] = $this->getItemTypeImg( $info["seatCircumference"]["metallicPanelType"], $info["seatCircumference"]["metallicPanelName"] );

			// パワーウインドウ
			$infoNew["powerWindowDisp"] = $this->getItemTypeImg( $info["seatCircumference"]["powerWindowType"], $info["seatCircumference"]["powerWindowName"] );


			$info["seatCircumference"] = $infoNew;


			//----------------------------
			// 空調
			//----------------------------
			$infoNew = $info["airConditioning"];

			// クーラー
			$infoNew["coolerDisp"] = $this->getItemTypeImg( $info["airConditioning"]["coolerType"], $info["airConditioning"]["coolerName"] );

			// エアコン
			$infoNew["airConditionerDisp"] = $this->getItemTypeImg( $info["airConditioning"]["airConditionerType"], $info["airConditioning"]["airConditionerName"] );

			// フルオートエアコン
			$infoNew["fullAirConditionerDisp"] = $this->getItemTypeImg( $info["airConditioning"]["fullAirConditionerType"], $info["airConditioning"]["fullAirConditionerName"] );

			// デュアルエアコン
			$infoNew["dualAirConditionerDisp"] = $this->getItemTypeImg( $info["airConditioning"]["dualAirConditionerType"], $info["airConditioning"]["dualAirConditionerName"] );

			// クリーンフィルター
			$infoNew["cleanFilterDisp"] = $this->getItemTypeImg( $info["airConditioning"]["cleanFilterType"], $info["airConditioning"]["cleanFilterName"] );

			// ピュアトロン
			$infoNew["pureTronDisp"] = $this->getItemTypeImg( $info["airConditioning"]["pureTronType"], $info["airConditioning"]["pureTronName"] );

			// 花粉フィルター
			$infoNew["pollenFilterDisp"] = $this->getItemTypeImg( $info["airConditioning"]["pollenFilterType"], $info["airConditioning"]["pollenFilterName"] );

			// 新脱臭機能付クリーンフィルター
			$infoNew["deodorizationCleanFilterDisp"] = $this->getItemTypeImg( $info["airConditioning"]["deodorizationCleanFilterType"], $info["airConditioning"]["deodorizationCleanFilterName"] );

			// リヤヒーターダクト
			$infoNew["rearHeaterDuctDisp"] = $this->getItemTypeImg( $info["airConditioning"]["rearHeaterDuctType"], $info["airConditioning"]["rearHeaterDuctName"] );

			// マイルドフローシステム
			$infoNew["mildFlowSystemDisp"] = $this->getItemTypeImg( $info["airConditioning"]["mildFlowSystemType"], $info["airConditioning"]["mildFlowSystemName"] );

			$info["airConditioning"] = $infoNew;


			//----------------------------
			// オーディオ
			//----------------------------
			$infoNew = $info["audio"];

			// ＡＭ電子チューナーラジオ
			$infoNew["AMRadioDisp"] = $this->getItemTypeImg( $info["audio"]["AMRadioType"], $info["audio"]["AMRadioName"] );

			// ＦＭ電子チューナーラジオ
			$infoNew["FMRadioDisp"] = $this->getItemTypeImg( $info["audio"]["FMRadioType"], $info["audio"]["FMRadioName"] );

			// カセット
			$infoNew["cassetteDisp"] = $this->getItemTypeImg( $info["audio"]["cassetteType"], $info["audio"]["cassetteName"] );

			// ＣＤ
			$infoNew["CDDisp"] = $this->getItemTypeImg( $info["audio"]["CDType"], $info["audio"]["CDName"] );

			// ＭＤ
			$infoNew["MDDisp"] = $this->getItemTypeImg( $info["audio"]["MDType"], $info["audio"]["MDName"] );

			// ＤＶＤビデオ再生
			$infoNew["DVDDisp"] = $this->getItemTypeImg( $info["audio"]["DVDType"], $info["audio"]["DVDName"] );

			// ＴＶ
			$infoNew["TVDisp"] = $this->getItemTypeImg( $info["audio"]["TVType"], $info["audio"]["TVName"] );

			// ナビゲーションシステム
			$infoNew["naviDisp"] = $this->getItemTypeImg( $info["audio"]["naviType"], $info["audio"]["naviName"] );

			// スピーカー
			$infoNew["speakerDisp"] = $this->getItemTypeImg( $info["audio"]["speakerType"], $info["audio"]["speakerName"] );

			// アンテナ
			$infoNew["antennaDisp"] = $this->getItemTypeImg( $info["audio"]["antennaType"], $info["audio"]["antennaName"] );

			// ETCユニット
			$infoNew["ETCDisp"] = $this->getItemTypeImg( $info["audio"]["ETCType"], $info["audio"]["ETCName"] );

			// 外部接続端子
			$infoNew["ExternalJoinTerminalDisp"] = $this->getItemTypeImg( $info["audio"]["ExternalJoinTerminalType"], $info["audio"]["ExternalJoinTerminalName"] );

			// ミュージック録音再生
			$infoNew["musicRecordDisp"] = $this->getItemTypeImg( $info["audio"]["musicRecordType"], $info["audio"]["musicRecordName"] );

			// ハンズフリーフォン
			$infoNew["handsFreeDisp"] = $this->getItemTypeImg( $info["audio"]["handsFreeType"], $info["audio"]["handsFreeName"] );

			$info["audio"] = $infoNew;


			//----------------------------
			// シート・内装関係
			//----------------------------
			$infoNew = $info["seatInterior"];

			// シート地
			$infoNew["seatGroundDisp"] = $this->getItemTypeImg( $info["seatInterior"]["seatGroundType"], $info["seatInterior"]["seatGroundName"] );

			// 運転席・助手席パワーシート
			$infoNew["powerSeatDisp"] = $this->getItemTypeImg( $info["seatInterior"]["powerSeatType"], $info["seatInterior"]["powerSeatName"] );

			// セカンドパワーシート
			$infoNew["secondPowerSeatDisp"] = $this->getItemTypeImg( $info["seatInterior"]["secondPowerSeatType"], $info["seatInterior"]["secondPowerSeatName"] );

			// シートリフター
			$infoNew["seatLifterDisp"] = $this->getItemTypeImg( $info["seatInterior"]["seatLifterType"], $info["seatInterior"]["seatLifterName"] );

			// フロントアームレスト
			$infoNew["frontArmWrestDisp"] = $this->getItemTypeImg( $info["seatInterior"]["frontArmWrestType"], $info["seatInterior"]["frontArmWrestName"] );

			// リヤ（セカンド）アームレスト
			$infoNew["secondArmWrestDisp"] = $this->getItemTypeImg( $info["seatInterior"]["secondArmWrestType"], $info["seatInterior"]["secondArmWrestName"] );

			// リヤ（セカンド）シートリクライニング
			$infoNew["secondSeatRecliningDisp"] = $this->getItemTypeImg( $info["seatInterior"]["secondSeatRecliningType"], $info["seatInterior"]["secondSeatRecliningName"] );

			// リヤ（セカンド）シートスライド
			$infoNew["secondSeatSlideDisp"] = $this->getItemTypeImg( $info["seatInterior"]["secondSeatSlideType"], $info["seatInterior"]["secondSeatSlideName"] );

			// リヤ（セカンド）シート機構
			$infoNew["secondSeatMechanismDisp"] = $this->getItemTypeImg( $info["seatInterior"]["secondSeatMechanismType"], $info["seatInterior"]["secondSeatMechanismName"] );

			// リヤ（セカンド）シート形状
			$infoNew["secondSeatShapeDisp"] = $this->getItemTypeImg( $info["seatInterior"]["secondSeatShapeType"], $info["seatInterior"]["secondSeatShapeName"] );

			// リヤ（セカンド）可倒式シート
			$infoNew["secondFoldingSeatShapeDisp"] = $this->getItemTypeImg( $info["seatInterior"]["secondFoldingSeatShapeType"], $info["seatInterior"]["secondFoldingSeatShapeName"] );

			// サードアームレスト
			$infoNew["thirdArmWrestDisp"] = $this->getItemTypeImg( $info["seatInterior"]["thirdArmWrestType"], $info["seatInterior"]["thirdArmWrestName"] );

			// サードシートスライド
			$infoNew["thirdSeatSlideDisp"] = $this->getItemTypeImg( $info["seatInterior"]["thirdSeatSlideType"], $info["seatInterior"]["thirdSeatSlideName"] );

			// サードシートリクライニング
			$infoNew["thirdSeatRecliningDisp"] = $this->getItemTypeImg( $info["seatInterior"]["thirdSeatRecliningType"], $info["seatInterior"]["thirdSeatRecliningName"] );

			// サードシート機構
			$infoNew["thirdSeatMechanismDisp"] = $this->getItemTypeImg( $info["seatInterior"]["thirdSeatMechanismType"], $info["seatInterior"]["thirdSeatMechanismName"] );

			// サードシート形状
			$infoNew["thirdSeatShapeDisp"] = $this->getItemTypeImg( $info["seatInterior"]["thirdSeatShapeType"], $info["seatInterior"]["thirdSeatShapeName"] );

			// サードパワーシート
			$infoNew["thirdPowerSeatDisp"] = $this->getItemTypeImg( $info["seatInterior"]["thirdPowerSeatType"], $info["seatInterior"]["thirdPowerSeatName"] );

			// サード可倒式シート
			$infoNew["thirdFoldingSeatShapeDisp"] = $this->getItemTypeImg( $info["seatInterior"]["thirdFoldingSeatShapeType"], $info["seatInterior"]["thirdFoldingSeatShapeName"] );

			// シートアレンジ
			$infoNew["seatArrangementDisp"] = $this->getItemTypeImg( $info["seatInterior"]["seatArrangementType"], $info["seatInterior"]["seatArrangementName"] );

			// シートトレイ
			$infoNew["seatTrayDisp"] = $this->getItemTypeImg( $info["seatInterior"]["seatTrayType"], $info["seatInterior"]["seatTrayName"] );

			// オットマン
			$infoNew["ottomanDisp"] = $this->getItemTypeImg( $info["seatInterior"]["ottomanType"], $info["seatInterior"]["ottomanName"] );

			// オートドライビングポジションメモリー
			$infoNew["autoDrivingPositionMemoryDisp"] = $this->getItemTypeImg( $info["seatInterior"]["autoDrivingPositionMemoryType"], $info["seatInterior"]["autoDrivingPositionMemoryName"] );

			// 車内電源
			$infoNew["carInPowerDisp"] = $this->getItemTypeImg( $info["seatInterior"]["carInPowerType"], $info["seatInterior"]["carInPowerName"] );

			// シートバックポケット
			$infoNew["seatBackPocketDisp"] = $this->getItemTypeImg( $info["seatInterior"]["seatBackPocketType"], $info["seatInterior"]["seatBackPocketName"] );

			// ヒーターシート
			$infoNew["heaterSeatDisp"] = $this->getItemTypeImg( $info["seatInterior"]["heaterSeatType"], $info["seatInterior"]["heaterSeatName"] );

			// エアコンディションシート
			$infoNew["airConditionerSeatDisp"] = $this->getItemTypeImg( $info["seatInterior"]["airConditionerSeatType"], $info["seatInterior"]["airConditionerSeatName"] );

			// 床下収納
			$infoNew["floorStorageDisp"] = $this->getItemTypeImg( $info["seatInterior"]["floorStorageType"], $info["seatInterior"]["floorStorageName"] );

			$info["seatInterior"] = $infoNew;


			//----------------------------
			// 外装
			//----------------------------
			$infoNew = $info["exterior"];

			// チルトアップルーフ
			$infoNew["tiltuproofDisp"] = $this->getItemTypeImg( $info["exterior"]["tiltuproofType"], $info["exterior"]["tiltuproofName"] );

			// ガラスサンルーフ
			$infoNew["glassSunroofDisp"] = $this->getItemTypeImg( $info["exterior"]["glassSunroofType"], $info["exterior"]["glassSunroofName"] );

			// ツインサンルーフ
			$infoNew["twinSunroofDisp"] = $this->getItemTypeImg( $info["exterior"]["twinSunroofType"], $info["exterior"]["twinSunroofName"] );

			// ルーフレール
			$infoNew["roofRailDisp"] = $this->getItemTypeImg( $info["exterior"]["roofRailType"], $info["exterior"]["roofRailName"] );

			// オートスライドドア
			$infoNew["autoSlideDoorDisp"] = $this->getItemTypeImg( $info["exterior"]["autoSlideDoorType"], $info["exterior"]["autoSlideDoorName"] );

			// フロントプロテクター
			$infoNew["frontProtectorDisp"] = $this->getItemTypeImg( $info["exterior"]["frontProtectorType"], $info["exterior"]["frontProtectorName"] );

			// リヤプロテクター
			$infoNew["rearProtectorDisp"] = $this->getItemTypeImg( $info["exterior"]["rearProtectorType"], $info["exterior"]["rearProtectorName"] );

			// サイドシルプロテクター
			$infoNew["sideProtectorDisp"] = $this->getItemTypeImg( $info["exterior"]["sideProtectorType"], $info["exterior"]["sideProtectorName"] );

			// リヤガラス開閉機構（＝ガラスハッチ）
			$infoNew["rearGlassHatchDisp"] = $this->getItemTypeImg( $info["exterior"]["rearGlassHatchType"], $info["exterior"]["rearGlassHatchName"] );

			$info["exterior"] = $infoNew;


			//----------------------------
			// 足まわり
			//----------------------------
			$infoNew = $info["footSurroundings"];

			// ４ＷＡＳ
			$infoNew["4WASDisp"] = $this->getItemTypeImg( $info["footSurroundings"]["4WASType"], $info["footSurroundings"]["4WASName"] );

			// 強化ブレーキ
			$infoNew["powerfulBrakeDisp"] = $this->getItemTypeImg( $info["footSurroundings"]["powerfulBrakeType"], $info["footSurroundings"]["powerfulBrakeName"] );

			// 強化サスペンション
			$infoNew["powerfulSuspensionDisp"] = $this->getItemTypeImg( $info["footSurroundings"]["powerfulSuspensionType"], $info["footSurroundings"]["powerfulSuspensionName"] );

			// アルミロードホイール
			$infoNew["aluminumWheelDisp"] = $this->getItemTypeImg( $info["footSurroundings"]["aluminumWheelType"], $info["footSurroundings"]["aluminumWheelName"] );

			// スペアタイヤ
			$infoNew["spareTireDisp"] = $this->getItemTypeImg( $info["footSurroundings"]["spareTireType"], $info["footSurroundings"]["spareTireName"] );

			$info["footSurroundings"] = $infoNew;


			// 安全変換
			$infoNew = $info["safety"];

			//----------------------------
			// 安全
			//----------------------------
			// 運転席SRSエアバックシステム
			$infoNew["driverSeatSRSAirBackSystemDisp"] = $this->getItemTypeImg( $info["safety"]["driverSeatSRSAirBackSystemType"], $info["safety"]["driverSeatSRSAirBackSystemName"] );

			// 助手席SRSエアバックシステム
			$infoNew["passengerSeatSRSAirBackSystemDisp"] = $this->getItemTypeImg( $info["safety"]["passengerSeatSRSAirBackSystemType"], $info["safety"]["passengerSeatSRSAirBackSystemName"] );

			// 前席SRSサイドエアバックシステム（SRSカーテンエアバックシステム）
			$infoNew["frontSRSSideAirBackSystemDisp"] = $this->getItemTypeImg( $info["safety"]["frontSRSSideAirBackSystemType"], $info["safety"]["frontSRSSideAirBackSystemName"] );

			// 後席SRSサイドエアバックシステム（SRSカーテンエアバックシステム）
			$infoNew["rearSRSSideAirBackSystemDisp"] = $this->getItemTypeImg( $info["safety"]["rearSRSSideAirBackSystemType"], $info["safety"]["rearSRSSideAirBackSystemName"] );

			// ABS（アンチロックブレーキシステム）
			$infoNew["ABSDisp"] = $this->getItemTypeImg( $info["safety"]["ABSType"], $info["safety"]["ABSName"] );

			// ブレーキアシスト
			$infoNew["brakeAssistDisp"] = $this->getItemTypeImg( $info["safety"]["brakeAssistType"], $info["safety"]["brakeAssistName"] );

			// TCS（トラクションコントロールシステム）
			$infoNew["TCSDisp"] = $this->getItemTypeImg( $info["safety"]["TCSType"], $info["safety"]["TCSName"] );

			// VDC（ビークルダイナミクスコントロール）
			$infoNew["VDCDisp"] = $this->getItemTypeImg( $info["safety"]["VDCType"], $info["safety"]["VDCName"] );

			// プリテンショナーシートベルト
			$infoNew["pretensionerSeatBeltDisp"] = $this->getItemTypeImg( $info["safety"]["pretensionerSeatBeltType"], $info["safety"]["pretensionerSeatBeltName"] );

			// フォースリミッターシートベルト
			$infoNew["forceLimiterSeatBeltDisp"] = $this->getItemTypeImg( $info["safety"]["forceLimiterSeatBeltType"], $info["safety"]["forceLimiterSeatBeltName"] );

			// チャイルドシート用アンカー
			$infoNew["childSeatAnchorDisp"] = $this->getItemTypeImg( $info["safety"]["childSeatAnchorType"], $info["safety"]["childSeatAnchorName"] );

			// ハイマウントストップランプ
			$infoNew["highMountStoplampDisp"] = $this->getItemTypeImg( $info["safety"]["highMountStoplampType"], $info["safety"]["highMountStoplampName"] );

			// 後席ELR付3点式シートベルト
			$infoNew["rearELRSeatBeltDisp"] = $this->getItemTypeImg( $info["safety"]["rearELRSeatBeltType"], $info["safety"]["rearELRSeatBeltName"] );

			// 挟み込み防止機能付パワーウインドウ
			$infoNew["scissorsPowerWindowDisp"] = $this->getItemTypeImg( $info["safety"]["scissorsPowerWindowType"], $info["safety"]["scissorsPowerWindowName"] );

			// 衝突安全ボディ
			$infoNew["safetyStructureBodyDisp"] = $this->getItemTypeImg( $info["safety"]["safetyStructureBodyType"], $info["safety"]["safetyStructureBodyName"] );

			// プリクラッシュシートベルト
			$infoNew["priCrashSeatBeltDisp"] = $this->getItemTypeImg( $info["safety"]["priCrashSeatBeltType"], $info["safety"]["priCrashSeatBeltName"] );

			// プリクラッシュブレーキアシスト
			$infoNew["priCrashBrakeAssistDisp"] = $this->getItemTypeImg( $info["safety"]["priCrashBrakeAssistType"], $info["safety"]["priCrashBrakeAssistName"] );

			// 盗難防止アラーム
			$infoNew["antiTheftAlarmDisp"] = $this->getItemTypeImg( $info["safety"]["antiTheftAlarmType"], $info["safety"]["antiTheftAlarmName"] );

			// アクティブヘッドレスト
			$infoNew["activeHeadrestDisp"] = $this->getItemTypeImg( $info["safety"]["activeHeadrestType"], $info["safety"]["activeHeadrestName"] );

			// フロントスタビライザー
			$infoNew["frontStabilizerDisp"] = $this->getItemTypeImg( $info["safety"]["frontStabilizerType"], $info["safety"]["frontStabilizerName"] );

			// リヤスタビライザー
			$infoNew["rearStabilizerDisp"] = $this->getItemTypeImg( $info["safety"]["rearStabilizerType"], $info["safety"]["rearStabilizerName"] );

			$info["safety"] = $infoNew;

			return $info;

		}

		function getItemTypeImg( $type, $name ){
			$tag = "";
			switch( $type ){
				case "1" :
					$tag = "<span class='fa fa-ellipsis-h'></span>" . " " . $name;
					break;
				case "2" :
					$tag = "<span class='fa fa-circle'></span>" . " " . $name;
					break;
				case "3" :
					$tag = "<span class='fa fa-times'></span>" . " " . $name;
					break;
				case "4" :
					$tag = "<span class='fa fa-tag mop'>MOP</span>" . " " . $name;
					break;
				case "5" :
					$tag = "<span class='fa fa-tag dop'>DOP</span>" . " " . $name;
					break;
				default :
					$tag = "" . $name;
					break;
			}
			return $tag;
		}
	}


?>