<?php

	/**
	 * boot.php
	 * Alias 対応版
	 * 最終更新: 2013-12-25
	 */

	/*----------------------------------------------------
	    基礎設定
	----------------------------------------------------*/
	$ini["jp_encoding"]  = "UTF-8";
	$ini["httpPortNum"]  = 80;
	$ini["sslPortNum"]   = 443;
	$ini["puk"]          = "stb034";
	$ini["dbTickName"]   = "dbTicket";



	/*----------------------------------------------------
	    ディレクトリ名設定
	----------------------------------------------------*/
	// ファイル名設定
	$path["mainPHP"]["fileName"]           = "MAIN.php";
	$path["publicFNC"]["fileName"]         = "PUBLIC.fnc";
	$path["frameworkClass"]["fileName"]    = "FRAMEWORK.cls";
	$path["actionList"]["fileName"]        = "ACTION.lst";
	$path["fieldList"]["fileName"]         = "FIELD.lst";
	$path["inputList"]["fileName"]         = "INPUT.lst";
	$path["actionInputList"]["fileName"]   = "ACTION-INPUT.lst";
	$path["breadcrumbsList"]["fileName"]   = "BREADCRUMBS.lst";
	$path["seoList"]["fileName"]           = "SEO.lst";
	$path["defineFnc"]["fileName"]         = "DEFINE.fnc";
	$path["defineIni"]["fileName"]         = "DEFINE.ini";
	$path["notFoundTMP"]["fileName"]       = "notFound.tmp";
	$path["loginFault"]["fileName"]        = "faultRedirect.tmp";
	$path["systemError"]["fileName"]       = "systemError.tmp";
	$path["notFound"]["fileName"]          = "notFound.tmp";
	$path["inputError"]["fileName"]        = "inputError.tmp";

	// ディレクトリ名設定
	$path["httpDocRoot"]["dirName"]        = "_web";
	$path["sslDocRoot"]["dirName"]         = "_ssl";
	$path["batDocRoot"]["dirName"]         = "_bat";
	$path["systemRoot"]["dirName"]         = "";
	$path["logRoot"]["dirName"]            = "log";
	$path["frameworkRoot"]["dirName"]      = "framework_2.0";
	$path["logicRoot"]["dirName"]          = "logic";
	$path["classRoot"]["dirName"]          = "class";
	$path["templateRoot"]["dirName"]       = "template";
	$path["loginRoot"]["https"]            = "https";
	$path["loginRoot"]["dirName"]          = "/LOGIN";
	$path["temporaryUpload"]["dirName"]    = "upload";
	$path["documentRoot"]["dirName"]       = "document";
	$path["templateError"]["dirName"]      = "ERROR";

	/**
	 * 2013-12-10 井上義勝 <y-inoue@hoyusys.co.jp>
	 * Apache などの Alias 設定に対応
	 */
	if (@strstr($_SERVER['SCRIPT_FILENAME'], $_SERVER['DOCUMENT_ROOT'])) {
		/**
		 * スクリプトがドキュメントルート内にあり、
		 * Apache などの Alias 設定がされていない
		 * (通常のケース)
		 */
		if (!array_key_exists('PATH_INFO', $_SERVER)) {
			/**
			 * PATH_INFO が取得できないサーバ対策
			 * (一部レンタルサーバ、Windows 版 LightHTTPD など)
			 */
			$path_info = str_replace($_SERVER['SCRIPT_NAME'], '', $_SERVER['REQUEST_URI']);
			/**
			 * GETパラメータを除去
			 */
			if (strstr($path_info, '?')) {
				$path_info = preg_replace('/\?.*/', '', $path_info);
			}
			$_SERVER['PATH_INFO'] = $path_info;
		}
	} else {
		/**
		 * スクリプトがドキュメントルート外にあり、
		 * Apache などの Alias 設定がされている
		 * (レアケース)
		 */
		$path['alias']                = dirname($_SERVER['SCRIPT_NAME']);
		$path['loginRoot']['dirName'] = preg_replace("#{$path['alias']}#", '', "{$path['loginRoot']['dirName']}");
	}


	/*----------------------------------------------------
	    各種パス設定の生成
	----------------------------------------------------*/
	baseSystem_initialize_basePath();


	/*----------------------------------------------------
	    メインプログラムに移行
	----------------------------------------------------*/
	include_once ( $path["publicFNC"]["fileAP"] );
	include_once ( $path["mainPHP"]["fileAP"] );





	/*----------------------------------------------------
	    初期値設定
	----------------------------------------------------*/
	function baseSystem_initialize_basePath() {

		global $path, $ini;

		// サイトルート設定
		$arThisPath = explode ( "/", $path["script"]["fileAP"] );
		for ( $i = 1; $i < count ( $arThisPath ); $i++ ) {
			if ( $arThisPath[$i] == $path["httpDocRoot"]["dirName"] || $arThisPath[$i] == $path["sslDocRoot"]["dirName"] || $arThisPath[$i] == $path["batDocRoot"]["dirName"] ) {
				break;
			}
			$path["siteRoot"]["dirAP"] .= "/{$arThisPath[$i]}";
		}

		// システムルート設定
		$path["systemRoot"]["dirAP"]  = pathGlue ( "{$path["boot"]["dirAP"]}/{$path["systemRoot"]["dirName"]}" );

		// ドキュメントルート全般
		$path["httpDocRoot"]["dirAP"] = pathGlue ( "{$path["siteRoot"]["dirAP"]}/{$path["httpDocRoot"]["dirName"]}" );
		$path["sslDocRoot"]["dirAP"]  = pathGlue ( "{$path["siteRoot"]["dirAP"]}/{$path["sslDocRoot"]["dirName"]}" );
		$path["batDocRoot"]["dirAP"]  = pathGlue ( "{$path["siteRoot"]["dirAP"]}/{$path["batDocRoot"]["dirName"]}" );

		// 各種パス設定
		if (!array_key_exists('DOCUMENT_ROOT', $_SERVER) || $_SERVER['DOCUMENT_ROOT'] == '') {
			/**
			 * バッチファイル
			 */
			$ini["script"]["type"]    = "bat";
			$path["docRoot"]["dirAP"] = $path["batDocRoot"]["dirAP"];
		} else {
			/**
			 * ウェブ経由
			 */
			$ini["script"]["type"]   = "web";
			$path["http"]["domain"]  = "http://{$_SERVER["HTTP_HOST"]}";
			$path["https"]["domain"] = "https://{$_SERVER["HTTP_HOST"]}";
			$path["http"]["head"]    = "http://";
			$path["https"]["head"]   = "https://";

			if ( $_SERVER["SERVER_PORT"] == $ini["httpPortNum"] ) {
				$path["script"]["urlHead"] = $path["httpHead"]["url"];
				$path["script"]["domain"]  = $path["httpDomain"]["url"];
//				$path["script"]["url"]     = preg_replace ( "#/$#", "", $path["httpDomain"]["url"] . $_SERVER['REQUEST_URI'] );
//				$path["script"]["url"]     = preg_replace ( "#/$#", "", $path["httpDomain"]["url"] . preg_replace ( '#^https?://[^/]*/#', '', $_pathinfo ) );
				$path["url"]["head"]       = $path["http"]["head"];
				$path["url"]["domain"]     = $path["http"]["domain"];
				$path["docRoot"]["dirAP"]  = $path["httpDocRoot"]["dirAP"];
				$ini["protocol"]           = "http";
			}
			elseif ( $_SERVER["SERVER_PORT"] == $ini["sslPortNum"] ) {
				$path["script"]["urlHead"] = $path["sslHead"]["url"];
				$path["script"]["domain"]  = $path["sslDomain"]["url"];
//				$path["script"]["url"]     = preg_replace ( "#/$#", "", $path["sslDomain"]["url"] . $_SERVER['REQUEST_URI'] );
//				$path["script"]["url"]     = preg_replace ( "#/$#", "", $path["sslDomain"]["url"] . preg_replace ( '#^https?://[^/]*/#', '', $_pathinfo ) );
				$path["url"]["head"]       = $path["https"]["head"];
				$path["url"]["domain"]     = $path["https"]["domain"];
				$path["docRoot"]["dirAP"]  = $path["sslDocRoot"]["dirAP"];
				$ini["protocol"]           = "ssl";
			}
			$path['script']['url'] = $_SERVER['REQUEST_URI'];
			$path["host"]["name"]  = $_SERVER["HTTP_HOST"];
		}
		$path["url"] = $path["url"]["head"] . pathGlue ( "{$path["host"]["name"]}/{$path["script"]["url"]}" );

		// 相対パス
		$path["script"]["fileRP"] = preg_replace ( "#{$path["docRoot"]["dirAP"]}#", "" , $path["script"]["fileAP"] );

		// フレームワークパス設定
		$path["frameworkRoot"]["dirAP"]      = "{$path["systemRoot"]["dirAP"]}/{$path["frameworkRoot"]["dirName"]}";
		$path["frameworkClass"]["fileAP"]    = "{$path["frameworkRoot"]["dirAP"]}/{$path["frameworkClass"]["fileName"]}";
		$path["templateRoot"]["dirAP"]       = "{$path["systemRoot"]["dirAP"]}/{$path["templateRoot"]["dirName"]}";
		$path["logicRoot"]["dirAP"]          = "{$path["systemRoot"]["dirAP"]}/{$path["logicRoot"]["dirName"]}";
		$path["classRoot"]["dirAP"]          = "{$path["systemRoot"]["dirAP"]}/{$path["classRoot"]["dirName"]}";
		$path["documentRoot"]["dirAP"]       = "{$path["systemRoot"]["dirAP"]}/{$path["documentRoot"]["dirName"]}";
		$path["logRoot"]["dirAP"]            = "{$path["systemRoot"]["dirAP"]}/{$path["logRoot"]["dirName"]}";
		$path["temporaryUpload"]["dirAP"]    = "{$path["systemRoot"]["dirAP"]}/{$path["temporaryUpload"]["dirName"]}";

		// system error template
		$path["template"]["systemError"]["fileAP"] = pathGlue ( "{$path["templateRoot"]["dirAP"]}/{$path["templateError"]["dirName"]}/{$path["systemError"]["fileName"]}" );

		// 404 not founed template
		$path["template"]["notFound"]["fileAP"] = pathGlue ( "{$path["templateRoot"]["dirAP"]}/{$path["templateError"]["dirName"]}/{$path["notFound"]["fileName"]}" );

		// input error template
		$path["template"]["inputError"]["fileAP"] = pathGlue ( "{$path["templateRoot"]["dirAP"]}/{$path["templateError"]["dirName"]}/{$path["inputError"]["fileName"]}" );

		// メインＰＨＰ
		$path["mainPHP"]["fileAP"]           = pathGlue ( "{$path["frameworkRoot"]["dirAP"]}/{$path["mainPHP"]["fileName"]}" );

		// 基本共有ファンクション
		$path["publicFNC"]["fileAP"]         = pathGlue ( "{$path["frameworkRoot"]["dirAP"]}/{$path["publicFNC"]["fileName"]}" );

		// ログファイル
		$date = date( "Ymd" );
		$path["logSystem"]["fileAP"] = pathGlue ( "{$path["logSystem"]["dirAP"]}/$date.log" );


		// ログイン関係
		$httpsHead = ( $path["loginRoot"]["https"] == "https" ) ? $path["https"]["domain"] : $path["http"]["domain"];
		$path["loginRoot"]["url"] = pathGlue ( "${httpsHead}/{$path["loginRoot"]["dirName"]}" );
		$path["loginRoot"]["dirRP"] = $path["loginRoot"]["dirName"];
		$path["loginRoot"]["logic"]["dirRP"]     = $path["loginRoot"]["dirName"];
		$path["loginRoot"]["logic"]["dirAP"]     = pathGlue ( "{$path["logicRoot"]["dirAP"]}/{$path["loginRoot"]["dirName"]}" );
		$path["loginRoot"]["template"]["dirRP"]  = $path["loginRoot"]["dirName"];
		$path["loginRoot"]["template"]["dirAP"]  = pathGlue ( "{$path["templateRoot"]["dirAP"]}/{$path["loginRoot"]["dirName"]}" );
		$path["loginRoot"]["template"]["fileRP"] = pathGlue ( "{$path["loginRoot"]["template"]["dirRP"]}/{$path["loginFault"]["fileName"]}" );
		$path["loginRoot"]["template"]["fileAP"] = pathGlue ( "{$path["templateRoot"]["dirAP"]}/{$path["loginRoot"]["template"]["fileRP"]}" );

		// DB
		$ini["dbTicket"]["key"] = $ini["puk"] . "-" . $ini["dbTickName"];
		if ( strlen( $_POST["dbTicket"] ) == 38 && preg_match ( "#^{$ini["dbTicket"]["key"]}#", $_POST["dbTicket"] ) ) {
			$ini["dbTicket"]["full"] =  $_POST["dbTicket"];
		}

	}

?>
