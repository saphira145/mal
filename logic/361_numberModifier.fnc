<?php


	/*----------------------------------------------------
	  小数点のみ追加
	----------------------------------------------------*/
	function MODIFIER_add_dot ( $value, $param=NULL ) {

		if( $param[0] > 0 ) {
			$formatParam = "0.{$param[0]}";
		}
		else{
			$formatParam = "0.1";
		}

		$value   = sprintf( "%{$formatParam}f", $value );

		return $value;
	}



?>