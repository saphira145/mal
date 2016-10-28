<?php
	class newCarUser_1 {
	/*----------------------------------------------------
	    コンストラクタ
	----------------------------------------------------*/
		function newCarUser_1 () {
		}

		/*----------------------------------------------------
		   新車リスト取得
		----------------------------------------------------*/
		function get_list ( $lixtCnt=3 ) {
			// DB名取得
			$DBName_B = get_DBName( "base" );
			$DBName_A = get_DBName( "active" );

			$sql  = "SELECT m.* ";
			$sql .= "FROM {$DBName_B}.newCar as n ";
			$sql .= "INNER JOIN {$DBName_A}.model as m ON n.makerCode = m.makerCode AND n.modelCode = m.modelCode ";
			$sql .= "ORDER BY n.newCarNum LIMIT {$lixtCnt}";
			$list = (array)sql_query( $sql );

			return $list;
		}
	}
?>