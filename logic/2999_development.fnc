<?php
	/*
		テスト環境判別用に使用。
		本番にはアップしない事！！
	*/
	$synchronization = "2015/03/19";
	$output["SEO"]["TITLE"] = "mal環境({$synchronization})：" . $output["SEO"]["TITLE"];

	// テスト用のスタイルシート
	if( $_SERVER["HTTPS"] && preg_match( "#/admin#", $path["url"] ) ){
		$output["cssList"][9]["cssName"]   = "/development/development_admin.css";
	} else {
		$output["cssList"][9]["cssName"]   = "/development/development.css";
		$output["cssList_s"][9]["cssName"] = "/development/development.css";
	}
?>