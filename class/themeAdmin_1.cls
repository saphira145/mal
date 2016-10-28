<?php


	class themeAdmin_1 {


	/*----------------------------------------------------
	    コンストラクタ
	----------------------------------------------------*/
		function themeAdmin_1 () {

		}


		/*----------------------------------------------------
		    テーマ情報追加
		----------------------------------------------------*/
		function insert_DB ( $input ) {

			global $class;

			$insert["themeName"]          = $input["themeInfo"]["themeName"];
			$insert["nameAbbreviation"]   = $input["themeInfo"]["nameAbbreviation"];
			$insert["iconNo"]             = $input["themeInfo"]["iconNo"];
			$insert["statusType"]         = $input["themeInfo"]["statusType"];
			$insert["basisOfSelection"]   = $input["themeInfo"]["basisOfSelection"];
			$insert["addDatetime"]["com"] = "now()";
			$insert["addMemberID"]        = $class["session"]->memberID;

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			$sql = "INSERT INTO {$DBName}.themeMst {insert_value};";
			list( $affected_row, $themeID ) = sql_query( $sql, $insert, "1" );

			// 優先度の設定
			$dispNum = $this->set_dispNum($input["themeInfo"]);
			$this->update_dispNumDB( $themeID, "priorityNum" , $dispNum["priorityNum"] );

			// 表示順の設定
			$dispNum = $this->set_dispNum($input["themeInfo"]);
			$this->update_dispNumDB( $themeID, "dispNum" , $dispNum["dispNum"] );

			// 車種テーマの登録
			foreach($input["themeInfo"]["bodyType"] as $bodyType){
				if( $bodyType["makerCode"] && $bodyType["modelCode"] ){

					$this->insert_carTheme( $themeID, $bodyType["makerCode"], $bodyType["modelCode"] );
				}
			}

			// おすすめ車種の登録
			$input["themeID"] = $themeID;
			$this->update_themeRecommend( $input );

			return $themeID;
		}


		/*----------------------------------------------------
		    テーマ情報(更新)
		----------------------------------------------------*/
		function update_DB ( $input ) {

			global $class;

			if ( empty($input["themeID"]) ){
				return;
			}

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			$update["themeName"]             = $input["themeInfo"]["themeName"];
			$update["nameAbbreviation"]      = $input["themeInfo"]["nameAbbreviation"];
			$update["iconNo"]                = $input["themeInfo"]["iconNo"];
			$update["statusType"]            = $input["themeInfo"]["statusType"];
			$update["basisOfSelection"]      = $input["themeInfo"]["basisOfSelection"];

			$dispNum                         = $this->set_dispNum($input["themeInfo"]);
			$update["dispNum"]               = $dispNum["dispNum"];
			$update["priorityNum"]           = $dispNum["priorityNum"];
			$update["updateDatetime"]["com"] = "now()";
			$update["updateMemberID"]        = $class["session"]->memberID;

			// SQLインジェクション対応
			$sql_escape["themeID"]  = sql_escapeString($input["themeID"]);

			$sql = "UPDATE {$DBName}.themeMst SET {update_set} WHERE themeID = '{$sql_escape["themeID"]}'";
			sql_query( $sql, $update, "1" );

			// 優先度の更新
			$this->update_dispNumDB_all();

			// 車種テーマの登録
			foreach($input["themeInfo"]["bodyType"] as $bodyType){
				if( $bodyType["makerCode"] && $bodyType["modelCode"] ){

					$this->insert_carTheme( $input["themeID"], $bodyType["makerCode"], $bodyType["modelCode"] );
				}
			}

			// おすすめ車種の登録
			$this->update_themeRecommend( $input );
			
		}


		/*----------------------------------------------------
		    テーマ情報(削除)
		----------------------------------------------------*/
		function delete_DB ( $input ) {
			global $class;

			if ( empty($input["themeID"]) ){
				return;
			}

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// SQLインジェクション対応
			$sql_escape["themeID"]  = sql_escapeString($input["themeID"]);

			// テーマの削除
			$sql = "DELETE FROM {$DBName}.themeMst WHERE themeID = '{$sql_escape["themeID"]}'";
			sql_query( $sql, "", "1" );

			// 車種テーマの削除
			$this->delete_carTheme( $input );

			// 優先度の更新
			$this->update_dispNumDB_all();

			// おすすめ車種の削除
			$sql = "DELETE FROM {$DBName}.themeRecommend WHERE themeID = '{$sql_escape["themeID"]}'";
			sql_query( $sql, "", "1" );

		}


		/*----------------------------------------------------
		    優先度の更新(全体)
		----------------------------------------------------*/
		function update_dispNumDB_all ( ) {

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// 優先度の更新
			$sql = "SELECT themeID FROM {$DBName}.themeMst WHERE statusType = '100' ORDER BY priorityNum";
			$list = (array)sql_query( $sql );

			for( $i=0; $i<count( $list ); $i++ ) {
				$priorityNum = $i + 1;
				$this->update_dispNumDB( $list[$i]["themeID"], "priorityNum", $priorityNum );
			}


			// 表示順の更新
			$sql = "SELECT themeID FROM {$DBName}.themeMst WHERE statusType = '100' ORDER BY dispNum";
			$list = (array)sql_query( $sql );

			for( $i=0; $i<count( $list ); $i++ ) {
				$dispNum = $i + 1;
				$this->update_dispNumDB( $list[$i]["themeID"], "dispNum", $dispNum );
			}
		}


		/*----------------------------------------------------
		    優先度の更新(単独)
		----------------------------------------------------*/
		function update_dispNumDB ( $themeID, $keyName , $num ) {

			if ( empty( $themeID ) ){
				return;
			}

			global $class;

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// 優先度の更新
			$update[$keyName]                = $num;
			$update["updateDatetime"]["com"] = "now()";
			$update["updateMemberID"]        = $class["session"]->memberID;

			// SQLインジェクション対応
			$sql_escape["themeID"]  = sql_escapeString($themeID);

			$sql = "UPDATE {$DBName}.themeMst SET {update_set} WHERE themeID = '{$sql_escape["themeID"]}'";
			sql_query( $sql, $update, "1" );

		}


		/*----------------------------------------------------
		    車種テーマ情報の追加
		----------------------------------------------------*/
		function insert_carTheme ( $themeID, $makerCode, $modelCode ) {

			global $class;

			if( empty($themeID) && empty($makerCode) && empty($modelCode)){
				return;
			}

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// SQLインジェクション対応
			$sql_escape["themeID"]   = sql_escapeString($themeID);
			$sql_escape["makerCode"] = sql_escapeString($makerCode);
			$sql_escape["modelCode"] = sql_escapeString($modelCode);

			// 既に登録されているか？
			$sql = "SELECT count(*) as dateCnt FROM {$DBName}.carTheme WHERE themeID = '{$sql_escape["themeID"]}' AND makerCode = '{$sql_escape["makerCode"]}' AND modelCode = '{$sql_escape["modelCode"]}'";
			$tbl = sql_query( $sql, "single" );

			// 登録
			if( $tbl["dateCnt"] == "0" ) {
				$insert["themeID"]            = $themeID;
				$insert["makerCode"]          = $makerCode;
				$insert["modelCode"]          = $modelCode;
				$insert["addDatetime"]["com"] = "now()";
				$insert["addMemberID"]        = $class["session"]->memberID;

				$sql = "INSERT INTO {$DBName}.carTheme {insert_value};";
				sql_query( $sql, $insert, "1" );
			}
		}


		/*----------------------------------------------------
		    車種テーマ情報の削除
		----------------------------------------------------*/
		function delete_carTheme ( $input ) {

			global $class;

			if( empty($input["themeID"]) &&  empty($input["makerCode"]) && empty($input["modelCode"]) ){
				return;
			}

			// テーマID
			if ( $input["themeID"] != "" ) {
				$sql_escape["themeID"] = sql_escapeString($input["themeID"]);
				$where[] = "themeID = '{$sql_escape["themeID"]}'";
			}

			// メーカーコード
			if ( $input["makerCode"] != "" ) {
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
			$DBName = get_DBName( "work" );

			$sql = "DELETE FROM {$DBName}.carTheme {$sql_where}";
			sql_query( $sql, "", "1" );
		}

		/*----------------------------------------------------
		    おすすめ車種の登録(DeleteInsert)
		----------------------------------------------------*/
		function update_themeRecommend ( $input ) {

			global $class;

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// SQLインジェクション対応
			$sql_escape["themeID"] = sql_escapeString($input["themeID"]);

			$sql = "DELETE FROM {$DBName}.themeRecommend WHERE themeID = '{$sql_escape["themeID"]}'";
			sql_query( $sql, "", "1" );
			
			foreach($input["themeInfo"]["bodyType"] as $bodyType){
				if( $bodyType["makerCode"] && $bodyType["modelCode"] ){
					$insert["themeID"]   = $input["themeID"];
					$insert["bodyModel"] = $bodyType["bodyTypeID"];
					$insert["makerCode"] = $bodyType["makerCode"];
					$insert["modelCode"] = $bodyType["modelCode"];
					
					$sql = "INSERT INTO {$DBName}.themeRecommend {insert_value};";
					sql_query( $sql, $insert, "1" );
				}
			}

		}

		/*----------------------------------------------------
		  情報取得
		----------------------------------------------------*/
		function get_info ( $theme ) {

			global $ini;

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// SQLインジェクション対応
			$sql_escape["theme"] = sql_escapeString($theme);

			$sql = "SELECT * FROM {$DBName}.themeMst WHERE themeID = '{$sql_escape["theme"]}'";
			$ret = sql_query( $sql, "single" );

			return $ret;
		}


		/*----------------------------------------------------
		   テーマリスト取得
		----------------------------------------------------*/
		function get_list ( $input ) {

			global $ini;

			// テーマID
			if ( $input["searchThemeID"] != "" ) {
				$sql_escape["searchThemeID"] = sql_escapeString($input["searchThemeID"]);
				$where[] = "themeID = '{$sql_escape["searchThemeID"]}'";
			}

			// テーマ名
			if ( $input["searchThemeName"] != "" ) {
				$sql_escape["searchThemeName"] = sql_escapeString($input["searchThemeName"]);
				$where[] = "( themeName LIKE '%{$sql_escape["searchThemeName"]}%' )";
			}

			// ステータス
			if ( $input["searchLevel"] != "" ) {
				$sql_escape["searchLevel"] = sql_escapeString($input["searchLevel"]);
				$where[] = "statusType = '{$sql_escape["searchLevel"]}'";
			}

			if ( count( $where ) > 0 ) {
				$sql_where = "WHERE " . @implode( " AND ", $where );
			}

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// 件数の取得
			$sql = "SELECT count(*) AS cnt FROM {$DBName}.themeMst {$sql_where}";
			$tbl = sql_query( $sql, "single" );

			// ページ情報の取得
			$pageInfo = adjust_pageState( $tbl["cnt"], $ini["pageLimit"]["themeAdmin"], $input["pageNum"] );

			// SQLインジェクション対応
			$sql_escape["limitStart"] = sql_escapeString($pageInfo["limitStart"]);
			$sql_escape["pageLimit"]  = sql_escapeString($ini["pageLimit"]["themeAdmin"]);

			// 全件取得
			$sql  = "SELECT * FROM {$DBName}.themeMst AS tbl";
			$sql .= " {$sql_where} ";
			$sql .= "ORDER BY statusType ,dispNum ,themeID ";
			$sql .= "LIMIT {$sql_escape["limitStart"]}, {$sql_escape["pageLimit"]}";

			$list = (array)sql_query( $sql );

			return array( $list, $pageInfo );
		}


		/*----------------------------------------------------
		   車種テーマ取得
		----------------------------------------------------*/
		function get_carThemeList ( $makerCode=null, $modelCode=null ) {

			if( empty( $makerCode ) && empty($modelCode) ){
				return NULL;
			}

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// SQLインジェクション対応
			$sql_escape["makerCode"] = sql_escapeString($makerCode);
			$sql_escape["modelCode"] = sql_escapeString($modelCode);

			// ワークから取得
			$sql  = "SELECT ct.themeID ";
			$sql .= "FROM {$DBName}.themeMst as tm LEFT JOIN {$DBName}.carTheme as ct ON (tm.themeID = ct.themeID)";
			$sql .= "WHERE ct.makerCode= '{$sql_escape["makerCode"]}' AND ct.modelCode = '{$sql_escape["modelCode"]}' AND tm.statusType = '100'";
			$sql .= "ORDER BY tm.dispNum";
			$ret  = sql_query( $sql );

			return $ret;
		}


		/*----------------------------------------------------
		    最後の表示番号を取得(表示順)
		----------------------------------------------------*/
		function get_dispNum ( ) {

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// 登録されたテーマ以外で有効になっているデータの最大を取得
			$sql = "SELECT max(dispNum) + 1 as maxDispNum FROM {$DBName}.themeMst WHERE statusType = '100'";
			$tbl = sql_query( $sql, "single" );

			return $tbl["maxDispNum"];
		}


		/*----------------------------------------------------
		    最後の表示番号を取得(優先度)
		----------------------------------------------------*/
		function get_priorityNum ( ) {

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// 登録されたテーマ以外で有効になっているデータの最大を取得
			$sql = "SELECT max(priorityNum) + 1 as maxDispNum FROM {$DBName}.themeMst WHERE statusType = '100'";
			$tbl = sql_query( $sql, "single" );

			return $tbl["maxDispNum"];
		}


		/*----------------------------------------------------
		   優先度リスト取得
		----------------------------------------------------*/
		function get_driorityNumList (  ) {

			global $ini;

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// 優先度
			$sql = "SELECT * FROM {$DBName}.themeMst WHERE statusType = '100' ORDER BY priorityNum";
			$priorityNumList = (array)sql_query( $sql );

			// 表示順
			$sql = "SELECT * FROM {$DBName}.themeMst WHERE statusType = '100' ORDER BY dispNum";
			$dispNumList = (array)sql_query( $sql );

			return array( $priorityNumList, $dispNumList );
		}


		/*----------------------------------------------------
		  優先度の設定
		----------------------------------------------------*/
		function set_dispNum ( $info ) {
			// 優先度の設定
			if( $info["statusType"] == 900 ){
				// ステータス無効
				$ret["priorityNum"] = 0;
				$ret["dispNum"]     = 0;
			} else if( $info["statusType"] == 200 ){
				// 有効 (バリューが無い車種用)
				$ret["priorityNum"] = 0;
				$ret["dispNum"]     = 0;
			} else if( empty($info["priorityNum"]) ) {
				// ステータス有効(無効から有効へ変更)
				$ret["priorityNum"] = $this->get_priorityNum();
				$ret["dispNum"]     = $this->get_dispNum();
			} else {
				$ret["priorityNum"] = $info["priorityNum"];
				$ret["dispNum"]     = $info["dispNum"];
			}

			return $ret;
		}

		/*----------------------------------------------------
		  テーマ情報を表示用に変更
		----------------------------------------------------*/
		function convert_Info ( $info ) {

			global $class, $ini;

			// おすすめ車種
			if( isset($info["bodyType"]) ){
				// リクエストパラメータから取得する
				for($i=0; $i<count($info["bodyType"]); $i++){
					$info["bodyType"][$i]["disp"] = $ini["bodyType"][$i]["disp"];
					if( $info["bodyType"][$i]["makerCode"] && $info["bodyType"][$i]["modelCode"] ){
						$info["bodyType"][$i]["makerName"] = get_makerName( $info["bodyType"][$i]["makerCode"] );
						$info["bodyType"][$i]["modelName"] = get_modelName( $info["bodyType"][$i]["makerCode"], $info["bodyType"][$i]["modelCode"] );
						$info["bodyType"][$i]["isBodyModel"] = 1;
					}
					$info["bodyType"][$i]["ID"] = $ini["bodyType"][$i]["ID"];
					$info["bodyType"][$i]["lgcNum"] = $i;
				}
			}else if( isset($info["themeID"]) ){
				// データベースから取得する
				$info["bodyType"] = $this->get_themeRecommend( $info["themeID"] );
				for($i=0; $i<count($info["bodyType"]); $i++){
					$info["bodyType"][$i]["lgcNum"] = $i;
				}

			}else{
				// 設定ファイルから取得する
				for($i=0; $i<count($ini["bodyType"]); $i++){
					$info["bodyType"][$i]["disp"] = $ini["bodyType"][$i]["disp"];
					$info["bodyType"][$i]["ID"] = $ini["bodyType"][$i]["ID"];
					$info["bodyType"][$i]["lgcNum"] = $i;
				}
			}

			// ステータス取得
			$info["statusTypeName"] = get_themeStatusName( $info["statusType"] );

			// アイコン名取得
			$tmp_theme = get_themeIconName( $info["iconNo"]  );
			$info["themeIconName"] = $tmp_theme["name"];
			$info["themeIconPath"] = $tmp_theme["path"];

			// 自動設定フラグ取得
			if( get_autoThemeFlg( $info["themeID"] ) ){
				$info["autoTheme"] = 1;
			}

			return $info;
		}


		/*----------------------------------------------------
		  テーマリストの表示設定
		----------------------------------------------------*/
		function convert_List ( $list ) {

			for( $i = 0, $iMax = count( $list ); $i < $iMax; $i++){

				$newList[] = $list[$i];

				// おすすめ車種
				$newList[$i]["recommend"] = $this->get_themeRecommend( $list[$i]["themeID"] );

				// アイコン名取得
				$tmp_theme = get_themeIconName( $newList[$i]["iconNo"] );
				$newList[$i]["themeIconName"] = $tmp_theme["name"];
				$newList[$i]["themeIconPath"] = $tmp_theme["path"];

				// ステータス名
				$newList[$i]["statusTypeName"] = get_themeStatusName( $newList[$i]["statusType"] );

				// ステータスフラグ(無効)
				if( $newList[$i]["statusType"] == 900 ){
					$newList[$i]["statusTypeFlg"] = 1;
				}
			}

			return $newList;
		}


		/*----------------------------------------------------
		  テーマリストの表示設定
		----------------------------------------------------*/
		function get_themeRecommend ( $themeID ) {

			global $ini;
			
			// $ini["bodyType"]から仮想表を作成する
			$bodyTypeTable = array();
			for($i=0; $i<count($ini["bodyType"]); $i++){
				$sql_escape["ID"]   = sql_escapeString($ini['bodyType'][$i]['ID']);
				$sql_escape["disp"] = sql_escapeString($ini['bodyType'][$i]['disp']);
				$sql_escape["i"]    = sql_escapeString($i);

				$bodyTypeIDList[] = "SELECT {$sql_escape["ID"]} as ID, '{$sql_escape["disp"]}' as disp, {$sql_escape["i"]} as orderNum";
			}

			// ＤＢ名取得
			$DBName = get_DBName( "work" );

			// SQLインジェクション対応
			$sql_escape["themeID"]  = sql_escapeString($themeID);

			$sql  = "SELECT ";
			$sql .= "  concat('recommend_', bodyType.ID) as recommend, ";
			$sql .= "  CASE WHEN tr.bodyModel IS NULL THEN 0 ELSE 1 END as isBodyModel, ";
			$sql .= "  bodyType.ID, ";
			$sql .= "  bodyType.disp, ";
			$sql .= "  tr.makerCode, ";
			$sql .= "  tr.modelCode, ";
			$sql .= "  mk.makerName, ";
			$sql .= "  md.modelName ";
			$sql .= "FROM ( ";
			$sql .= implode( " UNION ALL ", $bodyTypeIDList );
			$sql .= ") as bodyType ";
			$sql .= "LEFT JOIN {$DBName}.themeRecommend tr ";
			$sql .= "ON tr.bodyModel = bodyType.ID ";
			$sql .= "AND tr.themeID = '{$sql_escape["themeID"]}' ";
			$sql .= "LEFT JOIN {$DBName}.maker mk ";
			$sql .= "ON mk.makerCode = tr.makerCode ";
			$sql .= "LEFT JOIN {$DBName}.model md ";
			$sql .= "ON md.makerCode = tr.makerCode ";
			$sql .= "AND md.modelCode = tr.modelCode ";
			$sql .= "ORDER BY bodyType.orderNum ";

			$ret = sql_query( $sql );

			return $ret;
		}

	}
?>