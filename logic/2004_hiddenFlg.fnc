<?php

	/*----------------------------------------------------
	   一時的に非表示にしたい機能
	   
	   【任意保険】：処理でコメントアウト中
	   /logic/COMPARE/PROC_get_leaseInfo.lgc
	   /logic/LEASEINFO/PROC_get_list.lgc
	   /logic/LEASEINFO/VIEW_index.lgc
	   /logic/LEASEOPTION/VIEW_index.lgc
	   /logic/admin/123_consistency.ini
	----------------------------------------------------*/
	$output["basePriceFlg"]             = 1;  // 試算利益額(試算変更)
	$output["voluntaryInsuranceHidFlg"] = 1;  // 任意保険



?>