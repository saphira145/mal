$(window).resize(function(event){
	if( $('#TB_ajaxContent #checkAlert').size() == 0 ){
		var w={};
		w.w=($(window).width()>980)?980:$(window).width();
		w.h=($(window).height()>600)?600:$(window).height();
		$('#TB_ajaxContent').width(w.w).height(w.h);
		TB_WIDTH=(w.w);
		TB_HEIGHT=(w.h);
		tb_position();
	}
});


function defaultPrice(){
	var maxCnt = $(".searchForm .priceBox input:checkbox").size();
	$(".searchForm .priceBox input:checkbox").eq(maxCnt -1 ).attr("checked", true);
	
	setPriceCheck($(".searchForm .priceBox input:checkbox").eq(maxCnt -1 ).attr("value"));
}


function setPriceCheck(targetValue){

	$("#selectMakerTab .carPriceList input:checkbox").each(function(idx){

		// チェック状態を外す
		$(this).attr("checked", false);

		// ボタンのスタイル変更
		$(this).parents("li").removeClass('selected');

	});

	// 選択した項目のみチェック状態にする
	$('#selectMakerTab').find(':checkbox[value="' + targetValue + '"]').attr("checked", true);

	getCarGradeNum(targetValue);
}


function getCarGradeNum(targetValue){

	var url = $(":hidden[name^='url']").val();
	// 配列の初期化
	var arrMaker    = [];
	var arrBodyType = [];
	var arrPrice    = new Array(0);

	// チェック状態のスタイルを適用
	if( $('#selectMakerTab').find(':checkbox[value="' + targetValue + '"]').parents("li").hasClass('selected') ){
		$('#selectMakerTab').find(':checkbox[value="' + targetValue + '"]').parents("li").removeClass('selected');
	}else{
		$('#selectMakerTab').find(':checkbox[value="' + targetValue + '"]').parents("li").addClass('selected');
	}

	// メーカー
	$('#selectMakerTab').find(':checkbox[name^="makerList"]:checked').each(function(){
		arrMaker.push($(this).val());
	});
	// ボディタイプ
	$('#selectMakerTab').find(':checkbox[name^="bodyTypeList"]:checked').each(function(){
		arrBodyType.push($(this).val());
	});
	// 価格
	$('#selectMakerTab').find(':checkbox[name^="priceList"]:checked').each(function(){
		arrPrice.push($(this).val());
	});

	// 対象の件数取得
	$.ajax({
		type        : "post",
		dataType    : "json",
		data        : {
			"maker"     : arrMaker.join("-"),
			"bodyModel" : arrBodyType.join("-"),
			"price"     : arrPrice[0]
		},
		url           : url + "/bg/getCarGradeNum/",
		beforeSend    :function(){
    
		},
		success : function(re){
			// 検索結果を出力
			$(".carGradeNum span").text( re.num );
			$(".carGradeNum :button").prop("disabled", "");
			return;
		}
	});
}

function changeTargetCarSelectMaker(changeNum){
	var url = $(":hidden[name^='url']").val();

	$("#changeNum").val(changeNum);

	var w={};
	w.w=($(window).width()>980)?980:$(window).width();
	w.h=($(window).height()>600)?600:$(window).height();

	// コンテンツ取得
	$.ajax({
		type		: "post",
		dataType	: "json",
		data		: {
			
		},
		dataType	: "html",
		url			: url + "/bg/changeTargetCar/?st=in",
		success		: function(ret){
			$("#selectMakerTab")
				.empty()
				.append(ret);
			
			$("#selectMakerTab").css({display: "block"});
			$("#selectModelTab").css({display: "none"});
			
			// ダイアログ表示
			$("#thickboxjs")
				.attr("href", "#TB_inline?height=" + w.h + "&width=" + w.w + "&inlineId=thickboxjsContent&modal=true" )
				.triggerHandler("click");
			
			$("#TB_overlay").off("click");
			$("#TB_overlay").on("click", function(){
				tb_remove();
				$(document).scrollTop(0);
			});
			
		},
		error		: function(XMLHttpRequest, textStatus, errorThrown){
			console.log("error");
			console.log(XMLHttpRequest);
			console.log(textStatus);
			console.log(errorThrown);
		}
	});
}

function changeTargetCarSelectModel(){
	var url = $(":hidden[name^='url']").val();
	// 配列の初期化
	var arrMaker    = [];
	var arrBodyType = [];
	var arrPrice    = new Array(0);

	// メーカー
	$('#selectMakerTab').find(':checkbox[name^="makerList"]:checked').each(function(){
		arrMaker.push($(this).val());
	});
	// ボディタイプ
	$('#selectMakerTab').find(':checkbox[name^="bodyTypeList"]:checked').each(function(){
		arrBodyType.push($(this).val());
	});

	// 価格
	$('#selectMakerTab').find(':checkbox[name^="priceList"]:checked').each(function(){
		arrPrice.push($(this).val());
	});

	// コンテンツ取得
	$.ajax({
		type		: "post",
		dataType	: "json",
		data		: {
			"maker"     : arrMaker.join("-"),
			"bodyModel" : arrBodyType.join("-"),
			"price"     : arrPrice[0]
		},
		dataType	: "html",
		url			: url + "/bg/changeTargetCar/?st=sm",
		success		: function(ret){
			$("#selectModelTab")
				.empty()
				.append(ret);
			
			$("#selectMakerTab").css({display: "none"});
			$("#selectModelTab").css({display: "block"});
			
			$("#TB_ajaxContent").scrollTop(0);
			
		},
		error		: function(XMLHttpRequest, textStatus, errorThrown){
			console.log("error");
			console.log(XMLHttpRequest);
			console.log(textStatus);
			console.log(errorThrown);
		}
	});
}

function setNextUrl(changeNum, modelName, gradeID){
	var url = $(":hidden[name^='url']").val();
	var nextUrl = "/COMPARE";

	switch(changeNum){
		case "1" :
			nextUrl += "/" + modelName;
			nextUrl += "/" + gradeID;
			nextUrl += "/" + $("#modelNameEng2").val();
			nextUrl += "/" + $("#modelCode2").val();
			nextUrl += "/" + $("#modelNameEng3").val();
			nextUrl += "/" + $("#modelCode3").val();
			nextUrl += "/" + $("#modelNameEng4").val();
			nextUrl += "/" + $("#modelCode4").val();
			break;
		case "2" :
			nextUrl += "/" + $("#modelNameEng1").val();
			nextUrl += "/" + $("#modelCode1").val();
			nextUrl += "/" + modelName;
			nextUrl += "/" + gradeID;
			nextUrl += "/" + $("#modelNameEng3").val();
			nextUrl += "/" + $("#modelCode3").val();
			nextUrl += "/" + $("#modelNameEng4").val();
			nextUrl += "/" + $("#modelCode4").val();
			break;
		case "3" :
			nextUrl += "/" + $("#modelNameEng1").val();
			nextUrl += "/" + $("#modelCode1").val();
			nextUrl += "/" + $("#modelNameEng2").val();
			nextUrl += "/" + $("#modelCode2").val();
			nextUrl += "/" + modelName;
			nextUrl += "/" + gradeID;
			nextUrl += "/" + $("#modelNameEng4").val();
			nextUrl += "/" + $("#modelCode4").val();
			break;
		case "4" :
			nextUrl += "/" + $("#modelNameEng1").val();
			nextUrl += "/" + $("#modelCode1").val();
			nextUrl += "/" + $("#modelNameEng2").val();
			nextUrl += "/" + $("#modelCode2").val();
			nextUrl += "/" + $("#modelNameEng3").val();
			nextUrl += "/" + $("#modelCode3").val();
			nextUrl += "/" + modelName;
			nextUrl += "/" + gradeID;
			break;
	}

	return url + nextUrl;
}

function changeSelectGrade(changeNum, modelName){
	var gradeID  = $('#carGradeID_'+ changeNum).val();
	
	location.href = setNextUrl(changeNum, modelName, gradeID);
}


function changeTargetCarSelectGrade(modelName, gradeID){
	var changeNum = $("#changeNum").val();

	location.href = setNextUrl(changeNum, modelName, gradeID);
}


$(function(){
	$(document).on("click", ".clearChecked", function(){
		// スタイルを外す
		$(this).parent().find(".selected").removeClass("selected");
		// チェックを外す
		$(this).parent().find(":checked").each(function(){
			$(this).attr("checked", false);
		});
		
		if( $(this).parents(".carPriceList").size() > 0 ){
			defaultPrice();
		}
		getCarGradeNum();
	});
});

