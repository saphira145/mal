<?php




	/*----------------------------------------------------
	    権限ＳＥＬＥＣＴ
	----------------------------------------------------*/
	function get_levelSelectMulti ( $selectedID ) {

		global $ini;

		$ret = set_checked( $ini["level"], $selectedID, "id", "selected" );

		return $ret;
	}


	/*----------------------------------------------------
		月のＳＥＬＥＣＴ
	----------------------------------------------------*/
	function get_monthSelect( $selectedID="" ){

		for( $i = 0; $i < 12; $i++ ){
			$j = $i + 1;
			$list[$i]["id"]   = $j;
			$list[$i]["name"] = $j;
		}

		$ret = set_checked( $list, $selectedID, "id", "selected" );

		return $ret;

	}


	/*----------------------------------------------------
		日のＳＥＬＥＣＴ
	----------------------------------------------------*/
	function get_daySelect( $selectedID="" ){

		for( $i = 0; $i < 31; $i++ ){
			$j = $i + 1;
			$list[$i]["id"]   = $j;
			$list[$i]["name"] = $j;
		}

		$ret = set_checked( $list, $selectedID, "id", "selected" );

		return $ret;

	}


	/*----------------------------------------------------
		時のＳＥＬＥＣＴ
	----------------------------------------------------*/
	function get_hourSelect( $selectedID="" ){

		for( $i = 0; $i < 24; $i++ ){
			$j = $i;
			$list[$i]["id"]   = $j;
			$list[$i]["name"] = $j;
		}

		$ret = set_checked( $list, $selectedID, "id", "selected" );

		return $ret;

	}


	/*----------------------------------------------------
		分のＳＥＬＥＣＴ
	----------------------------------------------------*/
	function get_minSelect( $selectedID=99, $unit=5 ){

		$j = 0;
		for( $i = 0; $i < 60; $i += $unit ){
			$list[$j]["id"]   = $i;
			$list[$j]["name"] = sprintf( "%02d", $i );
			$j++;
		}

		$ret = set_checked( $list, $selectedID, "id", "selected" );

		return $ret;

	}


	/*----------------------------------------------------
	    権限ＳＥＬＥＣＴ
	----------------------------------------------------*/
	function get_levelSelect ( $selectedID="" ) {

		global $ini;

		$ret = set_checked( $ini["level"], $selectedID, "id", "selected" );

		return $ret;
	}


	/*----------------------------------------------------
	    メーカーＳＥＬＥＣＴ
	----------------------------------------------------*/
	function get_makerSelect ( $selectedID="", $DB="work" ) {

		// ＤＢ名取得
		$DBName = get_DBName( $DB );

		$sql = "SELECT makerCode, makerName FROM {$DBName}.maker ORDER BY dispNum";
		$list = sql_query( $sql );

		$ret = set_checked( $list, $selectedID, "makerCode", "selected" );

		return $ret;
	}


	/*----------------------------------------------------
	    出力タイプ
	----------------------------------------------------*/
	function get_outputTypeSelect ( $selectedID ) {

		global $ini;

		$ret = set_checked( $ini["outputType"], $selectedID, "value", "selected" );

		return $ret;
	}

	/*----------------------------------------------------
	    出力タイプ(CSVファイル用)
	----------------------------------------------------*/
	function get_outputTypeCsvSelect ( $selectedID ) {

		global $ini;

		$ret = set_checked( $ini["outputTypeCsv"], $selectedID, "value", "selected" );

		return $ret;
	}


	/*----------------------------------------------------
	  オプション項目名取得
	----------------------------------------------------*/
	function get_optionInfo ( $ID ) {

		global $ini;

		// マッピング配列生成
		for( $i=0; $i<count( $ini["lease"]["optionItem"] ); $i++ ) {
			if ( $ini["lease"]["optionItem"][$i]["id"] == $ID ){
				$ret = $ini["lease"]["optionItem"][$i];
			}
		}

		return $ret;
	}




	/*----------------------------------------------------
	  権限
	----------------------------------------------------*/
	function get_levelName ( $ID ) {

		global $ini;

		// マッピング配列生成
		for( $i=0; $i<count( $ini["level"] ); $i++ ) {
			if ( $ini["level"][$i]["id"] == $ID ){
				$ret = $ini["level"][$i]["name"];
			}
		}

		return $ret;
	}




	/*----------------------------------------------------
	  メーカ名取得
	----------------------------------------------------*/
	function get_makerName ( $makerCode, $DB="work" ) {

		// ＤＢ名取得
		$DBName = get_DBName( $DB );

		// SQLインジェクション対応
		$sql_escape["makerCode"] = sql_escapeString($makerCode);

		$sql = "SELECT makerName FROM {$DBName}.maker WHERE makerCode = '{$sql_escape["makerCode"]}'";
		$ret = sql_query( $sql, "single" );

		return $ret["makerName"];
	}



	/*----------------------------------------------------
	  車種名取得
	----------------------------------------------------*/
	function get_modelName ( $makerCode, $modelCode, $DB="work" ) {

		// ＤＢ名取得
		$DBName = get_DBName( $DB );

		// SQLインジェクション対応
		$sql_escape["makerCode"] = sql_escapeString($makerCode);
		$sql_escape["modelCode"] = sql_escapeString($modelCode);

		$sql = "SELECT modelName FROM {$DBName}.model WHERE makerCode = '{$sql_escape["makerCode"]}' AND modelCode = '{$sql_escape["modelCode"]}'";
		$ret = sql_query( $sql, "single" );

		return $ret["modelName"];
	}


	/*----------------------------------------------------
	  車体画像ファイル名取得
	----------------------------------------------------*/
	function get_carBodyPhotoName ( $makerCode="", $modelCode="", $activeFlg=0 ) {

		global $ini, $path;

		if( $makerCode == ""
		 || $modelCode == "" ) {
			return "noImage";
		}

		// 画像ファイル名取得
		$newFileName = get_photoFileName( $makerCode, $modelCode );

		if( $activeFlg == 1 ) {
			// 表示モード取得
			$testFlg = get_dispModeFlg();
			if( $testFlg == 1 && !preg_match( "#/admin/#", $path["url"] ) ) {
				// ＷＯＲＫ
				$DBNum = "WORK";
			}
			else{
				// アクティブＤＢ番号取得
				$DBNum = "DB" . get_activeDBNum();
			}
		}
		else{
			// ＷＯＲＫ
			$DBNum = "WORK";
		}

		$newFilePath = $path["docRoot"]["dirAP"] . "/_common/PHOTO/". $DBNum . "/CARBODY/" . $newFileName . ".jpg";

		if( !file_exists( $newFilePath ) ) {
			return "noImage";
		}

		return $newFileName;
	}



	/*----------------------------------------------------
	  車体グレード画像ファイル名取得
	----------------------------------------------------*/
	function get_carGradeBodyPhotoName ( $makerCode="", $modelCode="", $carGradeID="", $activeFlg=0 ) {

		global $ini, $path;

		if( $makerCode  == ""
		 || $modelCode  == ""
		 || $carGradeID == "" ) {
			return "noImage";
		}

		// 画像ファイル名取得
		$newFileName = get_photoGradeFileName( $makerCode, $modelCode, $carGradeID );

		if( $activeFlg == 1 ) {
			// 表示モード取得
			$testFlg = get_dispModeFlg();
			if( $testFlg == 1 && !preg_match( "#/admin/#", $path["url"] ) ) {
				// ＷＯＲＫ
				$DBNum = "WORK";
			}
			else{
				// アクティブＤＢ番号取得
				$DBNum = "DB" . get_activeDBNum();
			}
		}
		else{
			// ＷＯＲＫ
			$DBNum = "WORK";
		}

		$newFilePath = $path["docRoot"]["dirAP"] . "/_common/PHOTO/". $DBNum . "/CARBODY/" . $newFileName . ".jpg";

		if( !file_exists( $newFilePath ) ) {
			return "noImage";
		}

		return $newFileName;
	}



	/*----------------------------------------------------
	  画像ファイル名取得
	----------------------------------------------------*/
	function get_photoFileName ( $makerCode, $modelCode ) {

		$maker = sprintf( "%03d", $makerCode );
		$model = sprintf( "%03d", $modelCode );

		$ret = "$maker-$model";


		return $ret;
	}



	/*----------------------------------------------------
	  グレード画像ファイル名取得
	----------------------------------------------------*/
	function get_photoGradeFileName ( $makerCode, $modelCode, $carGradeID ) {

		$maker    = sprintf( "%03d", $makerCode );
		$model    = sprintf( "%03d", $modelCode );
		$carGrade = sprintf( "%07d", $carGradeID );

		$ret = "$maker-$model-$carGrade";


		return $ret;
	}



	/*----------------------------------------------------
	  車体画像登録されている画像はあるか？
	----------------------------------------------------*/
	function is_carBodyPhoto ( $makerCode, $modelCode="" ) {

		global $path;

		if( $makerCode == "" || $modelCode == "" ) {
			return false;
		}

		$fileName = get_photoFileName( $makerCode, $modelCode );

		// ファイルパスの設定
		$file = $path["modelPhoto"]["WORK"]["carBody"] . "/$fileName.jpg";
		if( file_exists( $file ) ) {
			return true;
		}
		else{
			return false;
		}

	}



	/*----------------------------------------------------
	  価格帯名取得
	----------------------------------------------------*/
	function get_priceRangeName ( $value ) {

		global $ini;

		// マッピング配列生成
		for( $i=0; $i<count( $ini["carPrice"] ); $i++ ) {
			if ( $ini["carPrice"][$i]["ID"] == $value ){
				$ret = $ini["carPrice"][$i]["name"];
			}
		}

		return $ret;
	}



	/*----------------------------------------------------
	  車体名取得
	----------------------------------------------------*/
	function get_bodyTypeName ( $value ) {

		global $ini;

		// マッピング配列生成
		for( $i=0; $i<count( $ini["bodyType"] ); $i++ ) {
			if ( $ini["bodyType"][$i]["ID"] == $value ){
				$ret = mb_convert_kana ( $ini["bodyType"][$i]["disp"], "R" );
			}
		}

		return $ret;
	}



	/*----------------------------------------------------
	  価格帯情報取得
	----------------------------------------------------*/
	function get_priceInfo ( $value ) {

		global $ini;

		// マッピング配列生成
		for( $i=1; $i<=count( $ini["carPrice"] ); $i++ ) {
			if ( $ini["carPrice"][$i]["ID"] == $value ){
				$ret = $ini["carPrice"][$i];
			}
		}

		return $ret;
	}



	/*----------------------------------------------------
	  ボディタイプ情報取得
	----------------------------------------------------*/
	function get_bodyTypeInfo ( $value ) {

		global $ini;

		// マッピング配列生成
		for( $i=0; $i<count( $ini["bodyType"] ); $i++ ) {
			if ( $ini["bodyType"][$i]["ID"] == $value ){
				$ret = $ini["bodyType"][$i];
			}
		}

		return $ret;
	}



	/*----------------------------------------------------
	    キャンペーンスコアＳＥＬＥＣＴ
	----------------------------------------------------*/
	function get_campaignScoreSelect ( $selectedID="" ) {

		global $ini;

		$ret = set_checked( $ini["campaignScore"], $selectedID, "id", "selected" );

		return $ret;
	}


	/*----------------------------------------------------
	    テーマステータスＳＥＬＥＣＴ
	----------------------------------------------------*/
	function get_themeStatusSelect ( $selectedID="" ) {

		global $ini;

		$ret = set_checked( $ini["themeStatus"], $selectedID, "id", "selected" );

		return $ret;
	}

	/*----------------------------------------------------
	    テーマスアイコンＳＥＬＥＣＴ
	----------------------------------------------------*/
	function get_themeIconSelect ( $selectedID="" ) {

		global $ini;

		$ret = set_checked( $ini["themeIcon"], $selectedID, "id", "selected" );

		return $ret;
	}

	/*----------------------------------------------------
	    代表車種グレードＳＥＬＥＣＴ
	----------------------------------------------------*/
	function get_carGradeSelect ( $selectedID="" ) {

		global $ini;

		$ret = set_checked( $ini["carGrade"], $selectedID, "ID", "selected" );

		return $ret;
	}


	/*----------------------------------------------------
	    権限レベル(営業ツール用)ＳＥＬＥＣＴ
	----------------------------------------------------*/
	function get_authorityLevelSelectMulti ( $selectedID ) {

		global $ini;

		if( $ini["systemLevel"]["authorityLevel"] == $selectedID ){
			$selectedID = $ini["systemLevel"]["setAuthorityLevel"];
		}

		$ret = set_checked( $ini["authorityLevel"], $selectedID, "id", "selected" );

		return $ret;
	}


	/*----------------------------------------------------
	    所属グループ(営業ツール用)ＳＥＬＥＣＴ
	----------------------------------------------------*/
	function get_salesGroupSelectMulti ( $selectedID ) {

		global $ini;

		$ret = set_checked( $ini["salesGroup"], $selectedID, "id", "selected" );

		return $ret;
	}


	/*----------------------------------------------------
	    パスワード有効日数(営業ツール用)ＳＥＬＥＣＴ
	----------------------------------------------------*/
	function get_expirationDaySelectMulti ( $selectedID ) {

		global $ini;

		$ret = set_checked( $ini["expirationDay"], $selectedID, "id", "selected" );

		return $ret;
	}


	/*----------------------------------------------------
	  権限レベル(営業ツール用)ＳＥＬＥＣＴ
	----------------------------------------------------*/
	function get_authorityLevelName ( $ID) {

		global $ini;

		if( $ini["systemLevel"]["authorityLevel"] == $ID ){
			$ID = $ini["systemLevel"]["setAuthorityLevel"];
		}
		// マッピング配列生成
		for( $i=0; $i<count( $ini["authorityLevel"] ); $i++ ) {
			if ( $ini["authorityLevel"][$i]["id"] == $ID ){
				$ret = $ini["authorityLevel"][$i]["name"];
			}
		}
		return $ret;
	}
	
	/*----------------------------------------------------
	  所属グループ(営業ツール用)
	----------------------------------------------------*/
	function get_salesGroupName ( $ID ) {

		global $ini;

		// マッピング配列生成
		for( $i=0; $i<count( $ini["salesGroup"] ); $i++ ) {
			if ( $ini["salesGroup"][$i]["id"] == $ID ){
				$ret = $ini["salesGroup"][$i]["name"];
			}
		}

		return $ret;
	}

	/*----------------------------------------------------
	  パスワード有効日数(営業ツール用)
	----------------------------------------------------*/
	function get_expirationDayInfo ( $ID ) {

		global $ini;

		// マッピング配列生成
		for( $i=0; $i<count( $ini["expirationDay"] ); $i++ ) {
			if ( $ini["expirationDay"][$i]["id"] == $ID ){
				$ret = $ini["expirationDay"][$i];
			}
		}

		return $ret;
	}


	/*----------------------------------------------------
	  テーマステータス名取得
	----------------------------------------------------*/
	function get_themeStatusName ( $ID ) {

		global $ini;

		if( empty($ID) ){
			$ID = 9;
		}

		// マッピング配列生成
		for( $i=0; $i<count( $ini["themeStatus"] ); $i++ ) {
			if ( $ini["themeStatus"][$i]["id"] == $ID ){
				$ret = $ini["themeStatus"][$i]["name"];
			}
		}

		return $ret;
	}


	/*----------------------------------------------------
	  テーマアイコン名取得
	----------------------------------------------------*/
	function get_themeIconName ( $ID ) {

		global $ini;

		// マッピング配列生成
		for( $i=0; $i<count( $ini["themeIcon"] ); $i++ ) {
			if ( $ini["themeIcon"][$i]["id"] == $ID ){
				$ret["name"] = $ini["themeIcon"][$i]["name"];
				$ret["path"] = $ini["themeIcon"][$i]["path"];
			}
		}

		return $ret;
	}


	/*----------------------------------------------------
	  テーマシステム設定判別
	----------------------------------------------------*/
	function get_autoThemeFlg ( $ID ) {

		global $ini;

		// マッピング配列生成
		for( $i=0; $i<count( $ini["autoTheme"] ); $i++ ) {
			if ( $ini["autoTheme"][$i]["id"] == $ID ){
				return true;
			}
		}

		return false;
	}


	/*----------------------------------------------------
	  メーカーのクラス判別
	----------------------------------------------------*/
	function get_makerClassFlg ( $ID ) {

		global $ini;

		// マッピング配列生成
		for( $i=0; $i<count( $ini["makerClass"] ); $i++ ) {
			if ( $ini["makerClass"][$i]["ID"] == $ID ){
				return true;
			}
		}

		return false;
	}


	/*----------------------------------------------------
	  キャンペーンスコアの取得
	----------------------------------------------------*/
	function get_campaignScoreName ( $ID ) {

		global $ini;

		if( empty($ID) ){
			$ID = 9;
		}

		// マッピング配列生成
		for( $i=0; $i<count( $ini["campaignScore"] ); $i++ ) {
			if ( $ini["campaignScore"][$i]["id"] == $ID ){
				$ret["id"]    = $ini["campaignScore"][$i]["id"];
				$ret["value"] = $ini["campaignScore"][$i]["value"];
				$ret["cnt"]  = $ini["campaignScore"][$i]["cnt"];
				
				for( $j=0; $j<$ini["campaign"]["count"]; $j++ ) {
					$flg = "off";
					if( $ini["campaignScore"][$i]["cnt"] > $j){
						$flg = "on";
					}
					$ret["icon"][$j]["name"] = $flg;
				}
			}
		}

		return $ret;
	}


	/*----------------------------------------------------
	  キャンペーン画像ファイル名取得
	----------------------------------------------------*/
	function get_campaignPhotoFileName ( $campaignNum ) {
		$newCampaignNum = $campaignNum;
		
		
		$ret = "campaign".$newCampaignNum;

		return $ret;
	}


	/*----------------------------------------------------
	  キャンペーン画像登録されている画像はあるか？
	----------------------------------------------------*/
	function is_campaignPhoto ( $campaignNum, $extension ) {

		global $path;

		if( $campaignNum == "" && $extension == "" ) {
			return false;
		}

		// ファイル名取得
		$fileName = get_campaignPhotoFileName( $campaignNum ) . $extension;

		// ファイルパスの設定
		$file = $path["campaignPhoto"]["campaign"] . "/$fileName";

		if( file_exists( $file ) ) {
			return true;
		}

		return false;

	}

	/*----------------------------------------------------
	  テーマリスト取得
	----------------------------------------------------*/
	function get_themeChecked ( $themeList, $makerCode=null, $modelCode=null, $DB="work" ) {

		for($i = 0 , $iMax = count($themeList); $i < $iMax; $i++){
			$arrCarTheme[] = $themeList[$i]["themeID"];
		}

		// ＤＢ名取得
		$DBName = get_DBName( $DB );

		$sql  = "SELECT * FROM {$DBName}.themeMst WHERE statusType = '100' ORDER BY dispNum";
		$retList = sql_query( $sql );

		for( $i = 0 , $iMax = count($retList); $i < $iMax; $i++ ){
			if( count($arrCarTheme) > 0 && in_array( $retList[$i]["themeID"], $arrCarTheme ) ){
				$retList[$i]["checked"] = 1;
			}

			if( !empty($makerCode) && !empty($modelCode) ){

				// SQLインジェクション対応
				unset($sql_escape);
				$sql_escape["themeID"]   = sql_escapeString($retList[$i]["themeID"]);
				$sql_escape["makerCode"] = sql_escapeString($makerCode);
				$sql_escape["modelCode"] = sql_escapeString($modelCode);

				// おすすめ車種
				$sql  = "SELECT count(*) as cnt FROM {$DBName}.themeRecommend WHERE themeID = '{$sql_escape["themeID"]}' AND makerCode = '{$sql_escape["makerCode"]}' AND modelCode = '{$sql_escape["modelCode"]}'";
				$recommend = sql_query( $sql, "single" );

				if( $recommend["cnt"] > 0 ){
					$retList[$i]["recommend"] = 1;
					$retList[$i]["disabled"] = 1;
				}
			}

			//システム自動設定
			if( get_autoThemeFlg($retList[$i]["themeID"]) ){
				$retList[$i]["autoTheme"] = 1;
				$retList[$i]["disabled"] = 1;
			}
		}

		return $retList;
	}


	/*----------------------------------------------------
	  テーマ名取得
	----------------------------------------------------*/
	function get_themeName ( $themeID, $DB="work" ) {

		if( empty($themeID) ){
			return NULL;
		}

		// ＤＢ名取得
		$DBName = get_DBName( $DB );

		// SQLインジェクション対応
		$sql_escape["themeID"] = sql_escapeString($themeID);

		$sql  = "SELECT themeName, nameAbbreviation FROM {$DBName}.themeMst WHERE themeID = '{$sql_escape["themeID"]}'";
		$ret = sql_query( $sql, "single" );

		return $ret;

	}


	/*---------------------------------------------------------------------
	    「現在 XX メーカー／XXX 車種」件数取得
	      戻り値：{totalMaker:メーカ件数, totalModel:モデル件数}
	---------------------------------------------------------------------*/
	function get_totalNum($DB="active") {

		// ＤＢ名取得
		$DBName = get_DBName( $DB );

		$sql  = "SELECT COUNT(DISTINCT m.makerCode) as totalMaker, COUNT(DISTINCT m.makerCode, m.modelCode) as totalModel ";
		$sql .= "FROM {$DBName}.model m ";
		$sql .= "INNER JOIN {$DBName}.maker as mk ON mk.makerCode = m.makerCode ";
		$sql .= "WHERE m.lowPriceCarGradeID IN (SELECT DISTINCT carGradeID FROM {$DBName}.carGrade) ";
		$sql .= "OR m.s2wdCarGradeID IN (SELECT DISTINCT carGradeID FROM {$DBName}.carGrade) ";
		$sql .= "OR m.s4wdCarGradeID IN (SELECT DISTINCT carGradeID FROM {$DBName}.carGrade) ";

		$ret = sql_query( $sql, "single" );

		return $ret;

	}



	/*----------------------------------------------------
	  車種名取得
	----------------------------------------------------*/
	function get_carListData ( $DB = "active" ) {

		// ＤＢ名取得
		$DBName = get_DBName( $DB );

		$sql  = "SELECT mk.makerName, m.modelName, m.modelNameEng ";
		$sql .= "FROM {$DBName}.model as m ";
		$sql .= "INNER JOIN {$DBName}.carGrade as cg ";
		$sql .= "ON m.lowPriceCarGradeID = cg.carGradeID OR m.s2wdCarGradeID  = cg.carGradeID OR m.s4wdCarGradeID  = cg.carGradeID ";
		$sql .= "INNER JOIN {$DBName}.maker as mk ";
		$sql .= "ON m.makerCode = mk.makerCode ";
		$sql .= "GROUP BY m.makerCode, m.modelCode ";
		$sql .= "ORDER BY m.modelName ";
		$list = (array)sql_query( $sql );

		// JSで使用する形にする
		for( $i = 0; $i < count( $list ); $i++ ) {
			$outList[$i]["c"]  = $list[$i]["makerName"];
			$outList[$i]["m"]  = $list[$i]["modelName"];
			$outList[$i]["me"] = $list[$i]["modelNameEng"];
		}

		return $outList;
	}



	/*----------------------------------------------------
	  管理ツールの表示モード取得
	  システム管理者 or グループ管理者の確認
	----------------------------------------------------*/
	function get_dispModeAdminFlg () {

		global $class, $path;

		if( $class["session"]->sales["system"] && $_SERVER["HTTPS"] && preg_match( "#/admin#", $path["url"] ) ) {
			return 1;
		}
		else{
			return NULL;
		}
	}


	/*----------------------------------------------------
	  営業ツールの表示モード取得
	  営業ログイン中の確認
	----------------------------------------------------*/
	function get_dispModeSalesPromotionFlg () {

		if( $_COOKIE["salesPromotion"] == "ON" && $_SERVER["HTTPS"] && !( preg_match( "#/admin#", $path["url"] ) || preg_match( "#/salesPromotion#", $path["url"] ) ) ) {
			return 1;
		}
		else{
			return NULL;
		}
	}



	/*----------------------------------------------------
	  リース(車両代)情報取得
	----------------------------------------------------*/
	function get_msrpPriceInfo ( $value ) {

		global $ini;

		// マッピング配列生成
		for( $i = 0; $i < count( $ini["lease"]["msrpPrice"] ); $i++ ) {
			if ( $ini["lease"]["msrpPrice"][$i]["id"] == $value ){
				$ret = $ini["lease"]["msrpPrice"][$i];
			}
		}

		return $ret;
	}

	/*----------------------------------------------------
	  リース(契約形態)情報取得
	----------------------------------------------------*/
	function get_contractInfo ( $value ) {

		global $ini;

		// マッピング配列生成
		for( $i = 0; $i < count( $ini["lease"]["contract"] ); $i++ ) {
			if ( $ini["lease"]["contract"][$i]["id"] == $value ){
				$ret = $ini["lease"]["contract"][$i];
			}
		}

		return $ret;
	}


	/*----------------------------------------------------
	  リース(走行距離)情報取得
	----------------------------------------------------*/
	function get_mileageInfo ( $value ) {

		global $ini;

		// マッピング配列生成
		for( $i = 0; $i < count( $ini["lease"]["mileage"] ); $i++ ) {
			if ( $ini["lease"]["mileage"][$i]["id"] == $value ){
				$ret = $ini["lease"]["mileage"][$i];
			}
		}

		return $ret;
	}

	/*----------------------------------------------------
	  リース(期間)情報取得
	----------------------------------------------------*/
	function get_paynumInfo ( $value ) {

		global $ini;

		// マッピング配列生成
		for( $i = 0; $i < count( $ini["lease"]["paynum"] ); $i++ ) {
			if ( $ini["lease"]["paynum"][$i]["id"] == $value ){
				$ret = $ini["lease"]["paynum"][$i];
			}
		}

		return $ret;
	}


	/*----------------------------------------------------
	  営業ツールの表示モード取得
	  事前設定チェック
	----------------------------------------------------*/
	function get_dispModeLeasePresetFlg () {

		if( $_COOKIE["leasePreset"] && $_SERVER["HTTPS"] ) {
			return 1;
		}
		else{
			return NULL;
		}
	}


	/*----------------------------------------------------
	  リース(任意保険)情報取得
	----------------------------------------------------*/
	function get_voluntaryInsuranceInfo ( $value ) {

		global $ini;

		// マッピング配列生成
		for( $i = 0; $i < count( $ini["lease"]["voluntaryInsurance"] ); $i++ ) {
			if ( $ini["lease"]["voluntaryInsurance"][$i]["id"] == $value ){
				$ret = $ini["lease"]["voluntaryInsurance"][$i];
			}
		}

		return $ret;
	}

	/*----------------------------------------------------
	  都道府県名の取得
	----------------------------------------------------*/
	function get_prefectureInfo ( $ID ) {

		global $ini;

		// マッピング配列生成
		for( $i=0; $i<count( $ini["prefecture"] ); $i++ ) {
			if ( $ini["prefecture"][$i]["id"] == $ID ){
				$ret = $ini["prefecture"][$i];
			}
		}

		return $ret;
	}


	/*----------------------------------------------------
	  金利ランク名の取得
	----------------------------------------------------*/
	function get_interestRatesName ( $ID ) {

		global $ini;

		// マッピング配列生成
		for( $i=0; $i<count( $ini["lease"]["interestRates"] ); $i++ ) {
			if ( $ini["lease"]["interestRates"][$i]["id"] == $ID ){
				$ret = $ini["lease"]["interestRates"][$i]["name"];
			}
		}

		return $ret;
	}


	/*----------------------------------------------------
	  リース(おすすめオプション)情報取得
	----------------------------------------------------*/
	function get_leasePresetInfo ( $value ) {

		global $ini;

		// マッピング配列生成
		for( $i = 0; $i < count( $ini["leasePreset"]["option"] ); $i++ ) {
			if ( $ini["leasePreset"]["option"][$i]["id"] == $value ){
				$ret = $ini["leasePreset"]["option"][$i];
			}
		}

		return $ret;
	}


	/*----------------------------------------------------
	  メンテナンス区分名称の取得
	----------------------------------------------------*/
	function get_maintenanceInfo ( $ID ) {

		global $ini;

		// マッピング配列生成
		for( $i=0; $i<count( $ini["maintenanceFee"] ); $i++ ) {
			if ( $ini["maintenanceFee"][$i]["id"] == $ID ){
				$ret = $ini["maintenanceFee"][$i];
			}
		}

		return $ret;
	}

	/*----------------------------------------------------
	  メンテナンスステータス判別
	----------------------------------------------------*/
	function get_maintenanceStateInfo ( $ID ) {

		global $ini;

		// マッピング配列生成
		for( $i=0; $i<count( $ini["maintenanceState"] ); $i++ ) {
			if ( $ini["maintenanceState"][$i]["id"] == $ID ){
				$ret = $ini["maintenanceState"][$i];
			}
		}

		return $ret;
	}



	/*----------------------------------------------------
	  未読チェック
	----------------------------------------------------*/
	function check_noticeUnread ( $key, $checkList ) {
		
		if( empty($checkList) ){
			return 0;
		}

		// チェック
		$arrCheckList = explode( "#", $checkList );
		$check        = get_cryptText($key);

		if( in_array( $check, $arrCheckList ) ){
			return 1;
		}

		return 0;
	}


	/*----------------------------------------------------
	  暗号化
	----------------------------------------------------*/
	function get_cryptText( $text ){

		$cryptText = crypt("M" . $text, "carSagacite" );

		return $cryptText;
	}

?>