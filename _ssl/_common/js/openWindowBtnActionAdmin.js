
	/*-----------------------------------------------
	  車種削除(新型車、おすすめ車種)
	------------------------------------------------*/
	function delCarModel( g_id , g_name ) {

		var message = g_name + "の設定を解除しますか？";

		if( window.confirm( message ) ){
			var modelName = "carModel[" + g_id + "][modelName]";
			var makerCode = "carModel[" + g_id + "][makerCode]";
			var modelCode = "carModel[" + g_id + "][modelCode]";
			var delBtn    = "delBtn_" + g_id;

			window.document.getElementById(modelName).innerHTML = "<span>未設定</span>";
			window.document.getElementById(makerCode).value     = "";
			window.document.getElementById(modelCode).value     = "";
			window.document.getElementById(delBtn).disabled     = true;
		}
	}


	/*-----------------------------------------------
	  車種削除(キャンペーン)
	------------------------------------------------*/
	function delCampaign( g_campaignNum ) {
		var campaignNum = g_campaignNum+1;
		var message = "キャンペーン" + campaignNum + "の設定を解除しますか？";

		if( window.confirm( message ) ){
		
			var campaignName        = "campaignInfo[" + g_campaignNum + "][campaignName]";
			var campaignURL         = "campaignInfo[" + g_campaignNum + "][campaignURL]";
			var dispNum             = "campaignInfo[" + g_campaignNum + "][dispNum]";
			var campaignPhoto       = "campaignInfo[" + g_campaignNum + "][campaignPhoto]";
			var campaignImg         = "campaignInfo[" + g_campaignNum + "][campaignImg]";
			var deleteCampaignPhoto = "campaignInfo[" + g_campaignNum + "][delete_campaignPhoto]";
			var delBtn              = "delBtn_" + g_campaignNum;
			
			window.document.getElementById(campaignName).value           = "";
			window.document.getElementById(campaignURL).value            = "";
			window.document.getElementById(dispNum).value                = "";
			window.document.getElementById(delBtn).disabled              = true;

			var file    = window.document.getElementById( "campaignPhoto_" +g_campaignNum  );
			var newFile = file.innerHTML;
			file.innerHTML = newFile;

			if( window.document.getElementById(deleteCampaignPhoto) ){
				window.document.getElementById(deleteCampaignPhoto).checked   = true;
				window.document.getElementById(campaignImg).style.visibility = "hidden";
				window.document.getElementById(campaignImg).style.display    = "none";
			}
		}
	}


	/*-----------------------------------------------
	  車種グレード削除(新型車、おすすめ車種)
	------------------------------------------------*/
	function delCarGradeModel( g_id , g_name ) {

		var message = g_name + "の設定を解除しますか？";

		if( window.confirm( message ) ){
			var carGradeName = "modelInfo[" + g_id + "CarGradeName]";
			var carGradeID = "modelInfo[" + g_id + "CarGradeID]";
			var delBtn    = "delBtn_" + g_id;

			window.document.getElementById(carGradeName).innerHTML = "<span>未設定</span>";
			window.document.getElementById(carGradeID).value     = "";
			window.document.getElementById(delBtn).disabled     = true;
		}
	}


	/*-----------------------------------------------
	  確認ダイアログ
	------------------------------------------------*/
	function confirmDialog ( g_emt, g_message ) {

		var message = '変更しますか？';
		if( g_message ){
			message = g_message + 'を更新しますか？';
		}
		

		if( window.confirm( message ) ) {
			document.getElementById(g_emt).submit();
			return false;
		}

	}