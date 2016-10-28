$(function(){

	/* --------------------------------------------------------------------------------
		角丸対応
	----------------------------------------------------------------------------------*/
	var hoverList = [{selecter:"#searchModelName" ,target:".left"}

					];
	/* -----------------------------------------------------
		処理：マウスオーバー処理
	----------------------------------------------------- */
	if (window.PIE) {
		for(var i = 0, i_len = hoverList.length; i < i_len; i++){
			$(hoverList[i].selecter).find(hoverList[i].target).each(function(){
				$(this).css({"position":"relative"});
				PIE.attach(this);
			});
		}
	}

	$("body").css({"display":"none"}).css({"display":""});

});

