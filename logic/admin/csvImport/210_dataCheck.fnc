<?php

	/* ======================================================

    車種グレード

	====================================================== */

		/*----------------------------------------------------
		    車種グレードＩＤ
		----------------------------------------------------*/
		function check_carGradeID ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 数値チェック
			elseif( !is_numeric( $value ) ) {
				$err["numeric"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    車種ＩＤ
		----------------------------------------------------*/
		function check_modelID ( $value, $key, $makerCode, $modelCode ) {

			global $class, $ini;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 8 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    グレードＩＤ
		----------------------------------------------------*/
		function check_gradeID ( $value, $key, $makerCode, $modelCode ) {

			global $class, $ini;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 11 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    メーカーＣＤ
		----------------------------------------------------*/
		function check_makerCode ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 数値チェック
			elseif( !is_numeric( $value ) ) {
				$err["numeric"] = 1;
			}
			// 存在チェック
			elseif( !is_makerCode( $value ) ) {
				$err["exist"] = 1;
				$err["key"]["id"]   = $value;
				$err["key"]["name"] = "メーカーコード";
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    メーカー名称
		----------------------------------------------------*/
		function check_makerName ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 文字数チェック
			elseif( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    車種名ＣＤ
		----------------------------------------------------*/
		function check_modelCode ( $value, $key, $makerCode ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 数値チェック
			elseif( !is_numeric( $value ) ) {
				$err["numeric"] = 1;
			}
			// 存在チェック
			elseif( !is_modelCode( $value, $makerCode ) ) {
				$err["exist"] = 1;
				$err["key"]["id"]   = $value;
				$err["key"]["name"] = "車種コード";
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    車種名
		----------------------------------------------------*/
		function check_modelName ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 文字数チェック
			elseif( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    価格
		----------------------------------------------------*/
		function check_price ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 文字数チェック
			elseif( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    車型
		----------------------------------------------------*/
		function check_bodyModel ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 文字数チェック
			elseif( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}


			return $err;
		}



		/*----------------------------------------------------
		    駆動方式
		----------------------------------------------------*/
		function check_driveSystem ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 文字数チェック
			elseif( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    駆動方式名称
		----------------------------------------------------*/
		function check_driveSystemName ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    グレードＣＤ
		----------------------------------------------------*/
		function check_gradeCode ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 数値チェック
			elseif( !is_numeric( $value ) ) {
				$err["numeric"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    グレード
		----------------------------------------------------*/
		function check_grade ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 文字数チェック
			elseif( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    車名型式
		----------------------------------------------------*/
		function check_carNameModel ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 文字数チェック
			elseif( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    ルーフ形状
		----------------------------------------------------*/
		function check_roofModel ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    ドア数
		----------------------------------------------------*/
		function check_door ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    トランスミッション区分
		----------------------------------------------------*/
		function check_transmissionType ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    トランスミッション
		----------------------------------------------------*/
		function check_transmission ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    全長
		----------------------------------------------------*/
		function check_totalLength ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    全幅
		----------------------------------------------------*/
		function check_totalWidth ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    全高
		----------------------------------------------------*/
		function check_totalHeight ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    室内寸法 長
		----------------------------------------------------*/
		function check_roomLength ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    室内寸法 幅
		----------------------------------------------------*/
		function check_roomWidth ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    室内寸法 高
		----------------------------------------------------*/
		function check_roomHeight ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    ホイールベース
		----------------------------------------------------*/
		function check_wheelbase ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    トレッド 前
		----------------------------------------------------*/
		function check_frontTread ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    トレッド 後
		----------------------------------------------------*/
		function check_rearTread ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    最低地上高
		----------------------------------------------------*/
		function check_minHeight ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    種別
		----------------------------------------------------*/
		function check_type ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    荷室長
		----------------------------------------------------*/
		function check_loadRoomLength ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    荷室幅
		----------------------------------------------------*/
		function check_loadRoomWidth ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    荷室高
		----------------------------------------------------*/
		function check_loadRoomHeight ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    車両重量
		----------------------------------------------------*/
		function check_vehicleWeight ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    車両総重量
		----------------------------------------------------*/
		function check_vehicleTotalWeight ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    乗車定員
		----------------------------------------------------*/
		function check_capacity ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 文字数チェック
			elseif( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    最大積載量
		----------------------------------------------------*/
		function check_maxCapacity ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    最小回転半径
		----------------------------------------------------*/
		function check_turningCircle ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    燃料消費率 JC08モード
		----------------------------------------------------*/
		function check_fuelConsumptionRateJC08mode ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    燃料消費率 10・15モード
		----------------------------------------------------*/
		function check_fuelConsumptionRate10_15mode ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    燃料消費率　60km/ｈ定地
		----------------------------------------------------*/
		function check_fuelConsumptionRate60km_h ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    適合規制・認定レベル
		----------------------------------------------------*/
		function check_recognitionLevel ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    ハンドル位置
		----------------------------------------------------*/
		function check_handlePosition ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    サスペンション 前
		----------------------------------------------------*/
		function check_frontSuspension ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    サスペンション 後
		----------------------------------------------------*/
		function check_rearSuspension ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    主ブレーキ 前
		----------------------------------------------------*/
		function check_frontMainBrake ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    主ブレーキ 後
		----------------------------------------------------*/
		function check_rearMainBrake ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    タイヤ　前
		----------------------------------------------------*/
		function check_frontTire ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    タイヤ　後
		----------------------------------------------------*/
		function check_rearTire ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    ステアリングギヤ形式
		----------------------------------------------------*/
		function check_steeringGearModel ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    エンジン型式
		----------------------------------------------------*/
		function check_engineModel ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    種類・シリンダー数
		----------------------------------------------------*/
		function check_cylinderType ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    エンジン種類
		----------------------------------------------------*/
		function check_engineKind ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    気筒配列
		----------------------------------------------------*/
		function check_cylinderArr ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    気筒数
		----------------------------------------------------*/
		function check_cylinderAmount ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    バルブ数
		----------------------------------------------------*/
		function check_valveAmount ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    シリンダー内径
		----------------------------------------------------*/
		function check_cylinderBore ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

			return $err;
		}



		/*----------------------------------------------------
		    シリンダー行程
		----------------------------------------------------*/
		function check_cylinderStroke ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    総排気量
		----------------------------------------------------*/
		function check_totalEmission ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 文字数チェック
			elseif( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    圧縮比
		----------------------------------------------------*/
		function check_compressionRatio ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    最高出力
		----------------------------------------------------*/
		function check_maxPower ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    最大トルク
		----------------------------------------------------*/
		function check_maxTorque ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    燃料供給装置
		----------------------------------------------------*/
		function check_fuelSupplySystem ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    使用燃料
		----------------------------------------------------*/
		function check_useFuel ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    給油口位置
		----------------------------------------------------*/
		function check_fillOpeningPosition ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    タンク容量
		----------------------------------------------------*/
		function check_tankVolume ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    優遇税制区分
		----------------------------------------------------*/
		function check_preferentialTaxType ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			if( $value == "" ) {
				return NULL;
			}

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

			return $err;
		}



		/*----------------------------------------------------
		    車両本体価格
		----------------------------------------------------*/
		function check_taxIncludedPrice ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			if( $value == "" ) {
				return NULL;
			}

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}


			return $err;
		}



		/*----------------------------------------------------
		    自動車重量税
		----------------------------------------------------*/
		function check_tonnageTax ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			if( $value == "" ) {
				return NULL;
			}

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}


			return $err;
		}



		/*----------------------------------------------------
		    自動車重量税_減税後
		----------------------------------------------------*/
		function check_tonnageTax_ART ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			if( $value == "" ) {
				return NULL;
			}

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}


			return $err;
		}



		/*----------------------------------------------------
		    自動車取得税
		----------------------------------------------------*/
		function check_acquisitionTax ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			if( $value == "" ) {
				return NULL;
			}

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}


			return $err;
		}



		/*----------------------------------------------------
		    自動車取得税_減税後
		----------------------------------------------------*/
		function check_acquisitionTax_ART ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			if( $value == "" ) {
				return NULL;
			}

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}


			return $err;
		}



		/*----------------------------------------------------
		    補助金_13年未満
		----------------------------------------------------*/
		function check_subsidyLessThan13Years ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			if( $value == "" ) {
				return NULL;
			}

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}


			return $err;
		}



		/*----------------------------------------------------
		    補助金_13年超
		----------------------------------------------------*/
		function check_subsidyOver13Years ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			if( $value == "" ) {
				return NULL;
			}

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}


			return $err;
		}



		/*----------------------------------------------------
		    自動車税（翌年）
		----------------------------------------------------*/
		function check_automobileTaxNextYear ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			if( $value == "" ) {
				return NULL;
			}

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}


			return $err;
		}



		/*----------------------------------------------------
		    自動車税_減税後（翌年）
		----------------------------------------------------*/
		function check_automobileTaxNextYear_ART ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			if( $value == "" ) {
				return NULL;
			}

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}


			return $err;
		}



		/*----------------------------------------------------
		    モーター型式
		----------------------------------------------------*/
		function check_motorModel ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    モーター種類
		----------------------------------------------------*/
		function check_motorKind ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    モーター種類_最大トルク数
		----------------------------------------------------*/
		function check_motorKindMaxTorque ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    モーター種類_最高出力
		----------------------------------------------------*/
		function check_motorKindMaxPower ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    動力用主電池_種類
		----------------------------------------------------*/
		function check_mainBatteryKind ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    動力用主電池_個数
		----------------------------------------------------*/
		function check_mainBatteryAmount ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    動力用主電池_接続方式
		----------------------------------------------------*/
		function check_mainBatteryConnect ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    動力用主電池_容量Ａｈ
		----------------------------------------------------*/
		function check_mainBatteryAh ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    定格電圧
		----------------------------------------------------*/
		function check_voltageRating ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}


		/*----------------------------------------------------
		    テーマID ： 車種バリュー
		----------------------------------------------------*/
		function check_themeID ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 数値チェック
			elseif( !is_numeric( $value ) ) {
				$err["numeric"] = 1;
			}
			// 存在チェック
			elseif( !is_themeID( $value ) ) {
				$err["exist"] = 1;
				$err["key"]["id"]   = $value;
				$err["key"]["name"] = "バリューID";
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}


		/*----------------------------------------------------
		    ON/OFF ： 車種バリュー
		----------------------------------------------------*/
		function check_flgOnOff ( $value, $key , $themeID, $makerCode, $modelCode ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 数値チェック
			elseif( !is_numeric( $value ) ) {
				$err["numeric"] = 1;
			}
			// 存在チェック(おすすめ車種)
			elseif( empty($value) && is_themeRecommend( $themeID, $makerCode, $modelCode ) ) {
				$err["themeRecommend"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}


		/*----------------------------------------------------
		    テーマ名： 車種バリュー
		----------------------------------------------------*/
		function check_themeName ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 文字数チェック
			elseif( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}


		/*----------------------------------------------------
		    リース料(共通)： 金額
		      ・仕入れ値：調達価格、任意保険料、登録法定費用、資金管理料金
		      ・残価：残価
		      ・メンテナンス：メンテナンス契約
		----------------------------------------------------*/
		function check_leaseValue ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 数値チェック
			elseif( !is_numeric( $value ) ) {
				$err["numeric"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}

		/*----------------------------------------------------
		     リース料(共通)： メンテ区分
		----------------------------------------------------*/
		function check_mainteID ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 存在チェック
			elseif( !is_mainteID( $value ) ) {
				$err["exist"] = 1;
				$err["key"]["id"]   = $value;
				$err["key"]["name"] = "メンテナンス区分";
			}
			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}


		/*----------------------------------------------------
		     リース料(共通)： メンテ区分状態
		----------------------------------------------------*/
		function check_mainteFlg ( $value, $key) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 数値チェック
			elseif( !is_numeric( $value ) ) {
				$err["numeric"] = 1;
			}
			// 存在チェック
			elseif( !is_mainteFlg( $value ) ) {
				$err["exist"] = 1;
				$err["key"]["id"]   = $value;
				$err["key"]["name"] = "区分状態";
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

			return $err;
		}


		/*----------------------------------------------------
		     リース料(共通)： 代表車種グレード
		----------------------------------------------------*/
		function check_carGradeFlg ( $value, $key) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 数値チェック
			elseif( !is_numeric( $value ) ) {
				$err["numeric"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

			return $err;
		}


		/*----------------------------------------------------
		     リース料(共通)： 走行距離
		----------------------------------------------------*/
		function check_mileageFlg ( $value, $key) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 数値チェック
			elseif( !is_numeric( $value ) ) {
				$err["numeric"] = 1;
			}
			// 存在チェック
			elseif( !is_mileageID( $value ) ) {
				$err["exist"] = 1;
				$err["key"]["id"]   = $value;
				$err["key"]["name"] = "走行距離";
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

			return $err;
		}


		/*----------------------------------------------------
		     リース料(共通)： リース期間
		----------------------------------------------------*/
		function check_payNumFlg ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 数値チェック
			elseif( !is_numeric( $value ) ) {
				$err["numeric"] = 1;
			}
			// 存在チェック
			elseif( !is_payNumID( $value ) ) {
				$err["exist"] = 1;
				$err["key"]["id"]   = $value;
				$err["key"]["name"] = "リース期間";
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

			return $err;
		}

		/*----------------------------------------------------
		     リース料(共通)： リース形態
		----------------------------------------------------*/
		function check_contractFlg ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 数値チェック
			elseif( !is_numeric( $value ) ) {
				$err["numeric"] = 1;
			}
			// 存在チェック
			elseif( !is_contractID( $value ) ) {
				$err["exist"] = 1;
				$err["key"]["id"]   = $value;
				$err["key"]["name"] = "リース形態";
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

			return $err;
		}

		/*----------------------------------------------------
		    ガソリン価格： 都道府県ID
		----------------------------------------------------*/
		function check_prefectureID ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 数値チェック
			elseif( !is_numeric( $value ) ) {
				$err["numeric"] = 1;
			}
			// 存在チェック
			elseif( !is_prefectureID( $value ) ) {
				$err["exist"] = 1;
				$err["key"]["id"]   = $value;
				$err["key"]["name"] = "都道府県ID";
			}
			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}


		/*----------------------------------------------------
		    ガソリン価格： 都道府県名
		----------------------------------------------------*/
		function check_prefectureName ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 文字数チェック
			elseif( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}


		/*----------------------------------------------------
		    ガソリン価格： ガソリン(レギュラー、ハイオク、軽油)
		----------------------------------------------------*/
		function check_gasoline ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );
			$arrPoint = explode(".", $value);

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 数値チェック
			elseif( !is_numeric( $value ) ) {
				$err["numeric"] = 1;
			}
			// 文字数チェック
			elseif( !( count($arrPoint) == 1 || ( strlen( $arrPoint[0] ) > 0  && strlen( $arrPoint[1] ) == 1 )) ){
				$err["length"] = 1;
			}


			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}


		/*----------------------------------------------------
		    オプション： オプションID
		----------------------------------------------------*/
		function check_leaseOptionID ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 数値チェック
			elseif( !is_numeric( $value ) ) {
				$err["numeric"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}


		/*----------------------------------------------------
		    オプション： オプション項目ID
		----------------------------------------------------*/
		function check_optionItemID ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 数値チェック
			elseif( !is_numeric( $value ) ) {
				$err["numeric"] = 1;
			}
			// 存在チェック
			elseif( !is_optionItemID( $value ) ) {
				$err["exist"] = 1;
				$err["key"]["id"]   = $value;
				$err["key"]["name"] = "オプションID";
			}
			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

			return $err;
		}


		/*----------------------------------------------------
		    オプション： オプション名
		----------------------------------------------------*/
		function check_optionName ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 文字数チェック
			elseif( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}


		/*----------------------------------------------------
		    オプション： オプション説明
		----------------------------------------------------*/
		function check_optionDescription ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}

		/*----------------------------------------------------
		     オプション： キャンペーンフラグ
		----------------------------------------------------*/
		function check_optionCampaignFlg ( $value, $key) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 数値チェック
			elseif( !is_numeric( $value ) ) {
				$err["numeric"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

			return $err;
		}


	/* ======================================================

    共通

	====================================================== */

		/*----------------------------------------------------
		    _車種グレードＩＤ
		----------------------------------------------------*/
		function check_ommonCarGradeID ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 車種グレードＩＤの存在チェック
			elseif( !carGradeIDExist( $value ) ) {
				$err["exist"] = 1;
				$err["key"]["id"]   = $value;
				$err["key"]["name"] = "グレードID";
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    _正式名
		----------------------------------------------------*/
		function check_ommonName ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 文字数チェック
			if( mb_strlen( $value ) > 200 ) {
				$err["length"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    _有無
		----------------------------------------------------*/
		function check_oommonType ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			if( $value == "" ) {
				return NULL;
			}

			// 文字数チェック
			if( mb_strlen( $value ) > 1 ) {
				$err["length"] = 1;
			}
			// 有無存在チェック
			elseif( !commonTypeExist( $value ) && count( $err ) == 0 ) {
				$err["iniExist"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    _注目
		----------------------------------------------------*/
		function check_oommonSpot ( $value, $key ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			if( $value == "" ) {
				return NULL;
			}

			// 文字数チェック
			if( mb_strlen( $value ) > 1 ) {
				$err["length"] = 1;
			}
			// 注目存在チェック
			elseif( !commonSpotExist( $value ) && count( $err ) == 0 ) {
				$err["iniExist"] = 1;
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}



		/*----------------------------------------------------
		    メーカーＣＤ
		----------------------------------------------------*/
		function is_makerCode ( $value ) {

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// SQLインジェクション対応
			$sql_escape["value"] = sql_escapeString($value);

			$sql = "SELECT makerCode FROM {$DBName}.maker WHERE makerCode = '{$sql_escape["value"]}'";
			$ret = sql_query( $sql, "single" );

			if( $ret["makerCode"] > 0 ) {
				return true;
			}
			else{
				return false;
			}

		}



		/*----------------------------------------------------
		    車種ＣＤ
		----------------------------------------------------*/
		function is_modelCode ( $value, $makerCode ) {

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// SQLインジェクション対応
			$sql_escape["value"]     = sql_escapeString($value);
			$sql_escape["makerCode"] = sql_escapeString($makerCode);

			$sql = "SELECT modelCode FROM {$DBName}.model WHERE makerCode = '{$sql_escape["makerCode"]}' AND modelCode = '{$sql_escape["value"]}'";
			$ret = sql_query( $sql, "single" );

			if( $ret["modelCode"] > 0 ) {
				return true;
			}
			else{
				return false;
			}

		}



		/*----------------------------------------------------
		    _車種グレードＩＤ
		----------------------------------------------------*/
		function carGradeIDExist ( $value ) {

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// SQLインジェクション対応
			$sql_escape["value"] = sql_escapeString($value);

			$sql = "SELECT carGradeID FROM {$DBName}.carGrade WHERE carGradeID = '{$sql_escape["value"]}'";
			$ret = sql_query( $sql, "single" );

			if( $ret["carGradeID"] > 0 ) {
				return true;
			}
			else{
				return false;
			}

		}



		/*----------------------------------------------------
		    有無存在チェック
		----------------------------------------------------*/
		function commonTypeExist ( $value ) {

			global $ini;

			for( $i=0; $i<count( $ini["commonType"] ); $i++ ) {
				if( $ini["commonType"][$i]["name"] == $value ) {
					return true;
				}
			}

			return false;
		}



		/*----------------------------------------------------
		    注目存在チェック
		----------------------------------------------------*/
		function commonSpotExist ( $value ) {

			global $ini;

			for( $i=0; $i<count( $ini["commonSpot"] ); $i++ ) {
				if( $ini["commonSpot"][$i]["name"] == $value ) {
					return true;
				}
			}

			return false;
		}


		/*----------------------------------------------------
		    テーマID
		----------------------------------------------------*/
		function is_themeID ( $value ) {

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// SQLインジェクション対応
			$sql_escape["value"] = sql_escapeString($value);

			$sql = "SELECT themeID FROM {$DBName}.themeMst WHERE themeID = '{$sql_escape["value"]}'";
			$ret = sql_query( $sql, "single" );

			if( $ret["themeID"] > 0 ) {
				return true;
			}
			else{
				return false;
			}

		}


		/*----------------------------------------------------
		    テーマID
		----------------------------------------------------*/
		function is_themeRecommend ( $themeID, $makerCode, $modelCode ) {

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// SQLインジェクション対応
			$sql_escape["themeID"]   = sql_escapeString($themeID);
			$sql_escape["makerCode"] = sql_escapeString($makerCode);
			$sql_escape["modelCode"] = sql_escapeString($modelCode);

			$sql = "SELECT themeID FROM {$DBName}.themeRecommend WHERE themeID = '{$sql_escape["themeID"]}' AND makerCode = '{$sql_escape["makerCode"]}' AND modelCode = '{$sql_escape["modelCode"]}'";
			$ret = sql_query( $sql, "single" );

			if( $ret["themeID"] > 0 ) {
				return true;
			}
			else{
				return false;
			}

		}

		/*----------------------------------------------------
		    都道府県ID
		----------------------------------------------------*/
		function is_prefectureID ( $value ) {

			$prefectureID = get_prefectureInfo($value);

			if( !empty($prefectureID) ) {
				return true;
			}
			else{
				return false;
			}

		}

		/*----------------------------------------------------
		    走行距離ID
		----------------------------------------------------*/
		function is_mileageID ( $value ) {

			$mileageID = get_mileageInfo($value);

			if( !empty($mileageID) ) {
				return true;
			}
			else{
				return false;
			}

		}


		/*----------------------------------------------------
		    リース期間ID
		----------------------------------------------------*/
		function is_payNumID ( $value ) {

			$payNumID = get_paynumInfo($value);

			if( !empty($payNumID) ) {
				return true;
			}
			else{
				return false;
			}

		}

		/*----------------------------------------------------
		    リース形態ID
		----------------------------------------------------*/
		function is_contractID ( $value ) {

			$contractID = get_contractInfo($value);

			if( !empty($contractID) ) {
				return true;
			}
			else{
				return false;
			}

		}

		/*----------------------------------------------------
		    オプション項目ID
		----------------------------------------------------*/
		function is_optionItemID ( $value ) {

			$optionInfo = get_optionInfo($value);

			if( !empty($optionInfo) ) {
				return true;
			}
			else{
				return false;
			}

		}

		/*----------------------------------------------------
		    メンテ区分ID
		----------------------------------------------------*/
		function is_mainteID ( $value ) {

			$mainteID = get_maintenanceInfo($value);

			if( !empty($mainteID) ) {
				return true;
			}
			else{
				return false;
			}

		}


		/*----------------------------------------------------
		    メンテ区分ID
		----------------------------------------------------*/
		function is_mainteFlg ( $value ) {
			global $ini;

			for( $i = 0, $iMax = count($ini["maintenanceState"]); $i < $iMax; $i++ ){
				if( $ini["maintenanceState"][$i]["id"] == $value ){
					$maintenanceState = $ini["maintenanceState"][$i];
				}
			}

			if( !empty($maintenanceState) ) {
				return true;
			}
			else{
				return false;
			}

		}


		/*----------------------------------------------------
		    メーカーＣＤ
		----------------------------------------------------*/
		function check_makerCodeList ( $value, $key, $list ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 数値チェック
			elseif( !is_numeric( $value ) ) {
				$err["numeric"] = 1;
			}
			// 存在チェック
			elseif( !isset($list[$value]) ) {
				$err["exist"] = 1;
				$err["key"]["id"]   = $value;
				$err["key"]["name"] = "メーカーコード";
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}


		/*----------------------------------------------------
		    車種名ＣＤ
		----------------------------------------------------*/
		function check_modelCodeList ( $value, $key, $makerCode, $list ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 数値チェック
			elseif( !is_numeric( $value ) ) {
				$err["numeric"] = 1;
			}
			// 存在チェック
			elseif( !isset($list[$makerCode][$value]) ) {
				$err["exist"] = 1;
				$err["key"]["id"]   = $value;
				$err["key"]["name"] = "車種コード";
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}


		/*----------------------------------------------------
		    _車種グレードＩＤ
		----------------------------------------------------*/
		function check_ommonCarGradeIDList ( $value, $key, $makerCode, $list ) {

			global $class;

			$value = $class["csvImport_1"]->conv_textData( $value );

			// 必須チェック
			if( $value == "" ) {
				$err["empty"] = 1;
			}
			// 車種グレードＩＤの存在チェック
			elseif( !isset($list[$makerCode][$value]) ) {
				$err["exist"] = 1;
				$err["key"]["id"]   = $value;
				$err["key"]["name"] = "グレードID";
			}

			// フィールド設定
			if( count( $err ) > 0 ) {
				$err["field"] = $key + 1;
			}

	
			return $err;
		}
?>