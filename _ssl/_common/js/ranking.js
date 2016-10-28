var arrChkCar = [];

$(function(){
	/*---------------
	  初期設定
	--------------- */
	/* チェックボックス */
	setCheckBoxCss();
	
	$("#rankingForm .animation").each(function() {
		$(this).removeClass("animation");
	});


	/*---------------
	  イベント：「ランキングの続きをもっと見る」ボタン
	--------------- */
	var pageNum  = $("#rankingForm").find(':hidden[name^="pageNum"]').val();
	$("#rankingList .nextListButton").on("click", function(){
		var url         = $(":hidden[name^='url']").val();
		var maker       = $("#rankingForm").find(':hidden[name^="searchMaker"]').val();
		var bodyType    = $("#rankingForm").find(':hidden[name^="searchType"]').val();
		var theme       = $("#rankingForm").find(':hidden[name^="searchTheme"]').val();
		var price       = $("#rankingForm").find(':hidden[name^="searchPrice"]').val();
		var carGradeNum = $(":hidden[name='carGradeNum']").val();
		
		$("#rankingList .nextListButton").addClass('clickColor');
		$("#rankingList .nextListButton a").text("データの取得中・・・");

		if( maker == null ){ maker = "MMM"; }
		if( bodyType == null ){ bodyType = "BBB"; }
		if( theme == null ){ theme = "TTT"; }
		if( price == null ){ theme = "PPP"; }
		if( pageNum == null ){ pageNum = 1; }

		// 対象の件数取得
		$.ajax({
			type        : "post",
			dataType    : "json",
			data        : {
				"maker"       : maker,
				"bodyModel"   : bodyType,
				"theme"       : theme,
				"price"       : price,
				"pageNum"     : pageNum,
				"carGradeNum" : carGradeNum
			},
			url           : url + "/bg/getRankingData/",
			beforeSend : function(){
				//-- IE8対応
				/* チェックボックス対応(表示している全てのチェックボックスにイベント追加？) */
				setCheckBoxEvent();
			},
			success : function(re){
			
				// 2ページ目を開いたとき「選択した検索条件」を下部にも表示する
				if( pageNum == 2 ){
					$(".selectSelectListBottom").show();
				}

				// 検索結果を出力
				$('#rankingForm>ul').append(re.html);
				
				if( re.del == 1 ){
					// 残車種が無いのでボタンを消す
					$('#rankingForm .nextListButton').remove();
				} else {
					pageNum = re.pageNum;
					$("#rankingList .nextListButton a").text("ランキングの続きをもっと見る");

				}

				//-- IE8対応
				/* チェックボックス対応 */
				setCheckBoxEvent();

				/* チェックボックス：再イベント設定 */
				setCheckBoxCss();

				/* マウスオーバー設定 */
				setMouseOverEvent();

				// アニメーション
				$("#rankingForm .animation").slideDown();
				$("#rankingForm .animation").each(function() {
					$(this).removeClass("animation");
				});
				
				$("#rankingList .nextListButton").removeClass('clickColor');

				return;
			}
		});
	});

});


/*---------------
  チェックボックス：イベント設定
--------------- */
function setCheckBoxCss(){
	$("#rankingForm").find(":checkbox").each(function(){
		$(this).on("click", function(){
			
			if( $(this).attr('checked') ){
				$(this).parents("li").find("label").addClass('checked');
				$(this).parents("li").find("div").addClass('checked');
				carCheckAlert();
			} else {
				$(this).parents("li").find("label").removeClass('checked');
				$(this).parents("li").find("div").removeClass('checked');
			}
		});
	})

	// ブラウザバック対応
	$("#rankingForm").find(":checked").each(function(){
		$(this).parents("li").find("label").addClass('checked');
		$(this).parents("li").find("div").addClass('checked');
	});

}


/*---------------
  イベント：「チェックした車種を比較」ボタン
--------------- */
function eventClick_compareBtn(){
	var searchMaker    = $("#rankingForm").find(':hidden[name^="maker"]').val();
	var searchBodyType = $("#rankingForm").find(':hidden[name^="type"]').val();
	var searchTheme    = $("#rankingForm").find(':hidden[name^="theme"]').val();
	var searchPrice    = $("#rankingForm").find(':hidden[name^="price"]').val();

	// チェックした車の件数
	if( carCheckAlert() == false ){
		return;
	}

	// URL作成
	var url         = $("#rankingForm").attr('action');
	var setModel    = "";
	var setSearch   = "?from=ranking";

	// 使い方ガイド中の場合、フラグを設定
	var gaide = "";
	if( $("#guide").length > 0 ){
		gaide = "&guide=guide";
	}

	// 検索条件
	if( searchMaker != null ){
		setSearch = setSearch + "&maker=" + searchMaker;
	}
	if( searchBodyType != null ){
		setSearch = setSearch + "&type=" + searchBodyType;
	}
	if( searchTheme != null ){
		setSearch = setSearch + "&theme=" + searchTheme;
	}
	if( searchPrice != null ){
		setSearch = setSearch + "&price=" + searchPrice;
	}
	
	// 車種
	for( var i = 0; i < arrChkCar.length; i++ ){
		setModel = setModel + arrChkCar[i] ;
	}

	location.href = url + setModel + setSearch + gaide;
}


//------------------------------------------------
// 車種チェックアラート表示
//------------------------------------------------
function carCheckAlert(){
	// チェックした車の件数
	arrChkCar = [];

	$("#rankingForm").find(':checkbox[name^="selCar"]:checked').each(function(){
		arrChkCar.push($(this).val());
	});

	// ダイアログ表示
	var w={};
	var alertFlg;

	$("#checkAlert .checkCarNone").css({display: "none"});
	$("#checkAlert .checkCarOrver").css({display: "none"});

	if( arrChkCar.length == 0){
		w.w=380;
		w.h=160;
		$("#checkAlert .checkCarNone").css({display: ""});
		alertFlg = 1;
	} else if( arrChkCar.length > 3){
		w.w=420;
		w.h=160;
		$("#checkAlert .checkCarOrver").css({display: ""});
		alertFlg = 1;
	}

	if( alertFlg ){
		$("#thickboxjs")
			.attr("href", "#TB_inline?height=" + w.h + "&width=" + w.w + "&inlineId=thickboxjsContent&modal=true" )
			.triggerHandler("click");

		$("#TB_ajaxContent").css({opacity: 0}).animate({opacity : 1}, 200);
		$("#TB_overlay").off("click");
		$("#TB_overlay, #checkAlert .closeBtn").on("click", function(){
			tb_remove();
		});
		return false;
	}

	return true;
}