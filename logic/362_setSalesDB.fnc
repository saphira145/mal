<?php

	/*----------------------------------------------------
	    ユーザー画面遷移時に営業ログイン状態の場合、DBを変更する
	    ※ ユーザー側のデフォルトがworkで、ログイン情報を取得する事が出来ない為
	----------------------------------------------------*/
	if( get_dispModeSalesPromotionFlg() ) {
		$ini["db"]["db"] = get_DBName( "base" );
	}

?>