$(function(){

	var url = $(":hidden[name^='url']").val();

	// チェック済リスト
	var arrMaker    = [];	// チェック済のメーカーリスト
	var arrBodyType = [];	// チェック済のボディタイプ
	var arrTheme    = [];	// チェック済のテーマ
	var arrPrice    = new Array(0);	// チェック済のテーマ

	// チェック済リスト生成
	var setCheckedList = function(){
		arrMaker    = [];
		arrBodyType = [];
		arrTheme    = [];
		arrPrice    = new Array(0);

		// メーカー
		$('.searchForm').find(':checkbox[name^="maker"]:checked').each(function(){
			if( $.inArray($(this).val(), arrMaker) == -1 ){
				arrMaker.push($(this).val());
			}
		});

		// ボディタイプ
		$('.searchForm').find(':checkbox[name^="bodyType"]:checked').each(function(){
			if( $.inArray($(this).val(), arrBodyType) == -1 ){
				arrBodyType.push($(this).val());
			}
		});

		// バリュー
		$('.searchForm').find(':checkbox[name^="theme"]:checked').each(function(){
			if( $.inArray($(this).val(), arrTheme) == -1 ){
				arrTheme.push($(this).val());
			}
		});

		// 価格
		$('.searchForm').find(':checkbox[name^="price"]:checked').each(function(){
			if( $.inArray($(this).val(), arrPrice) == -1 ){
				arrPrice.push($(this).val());
			}
		});
	}

	// チェック済リストのスタイル設定
	var setCheckedStyle = function(){
		$.each( arrMaker.concat(arrBodyType).concat(arrTheme).concat(arrPrice), function(key, value){
			$(".searchForm input:checkbox[value='" + value + "']").parents("li").addClass('selected');
		});
	}

	// 対象車種数の取得、設定
	var setCarGradeNum = function(){

		$.ajax({
			type        : "post",
			dataType    : "json",
			data        : {
				"maker"     : arrMaker.join("-"),
				"bodyModel" : arrBodyType.join("-"),
				"theme"     : arrTheme.join("-"),
				"price"     : arrPrice[0]
			},
			url           : url + "/bg/getCarGradeNum/",
			success : function(re){
				$(".carGradeNum span").text( re.num );
				return;
			}
		});
	}
	

	// 価格選択(1件のみ)
	var setPriceCheck = function( checkEmt ){

		$(".searchForm .searchPriceList input:checkbox").each(function(idx){
			// チェック状態を外す
			$(this).attr("checked", false);

			// ボタンのスタイル変更
			$(this).parents("li").removeClass('selected');

		});

		// 選択した項目のみチェック状態にする
		$(checkEmt).attr("checked", true);
		
	}

	// 価格デフォルト設定
	function defaultPrice(){
		if( !arrPrice[0] ){
			var maxCnt = $(".searchForm .searchPriceList input:checkbox").size();
			$(".searchForm .searchPriceList input:checkbox").eq(maxCnt -1 ).attr("checked", true).triggerHandler("click");

			setCheckedList();
		}
	}


	//--------------------------------------------
	// トップ画面
	//--------------------------------------------
	if( $("#topPage").length > 0 ){

		//------------------------------------------------
		// 検索条件選択・解除時
		//------------------------------------------------
		$(".searchForm input:checkbox").click(function(){

			// 価格の選択は1つのみ
			if( $(this).attr("name") == "priceList"){
				setPriceCheck( $(this) );
			}

			// 選択したチェックボックスのスタイル設定
			if( $(this).attr('checked') ){
				$(this).parents("li").addClass('selected');
			} else {
				$(this).parents("li").removeClass('selected');
			}

			// 選択・解除した検索条件をメニューに反映させる
			var checkListName = $(this).attr("name");
			switch( checkListName ){
				case "makerList"    : 
					var setBoxName = "makerBox";
					var setImgPath = "";
					var setImgStyle = "";
					var setCss      = "";
					break;
				case "bodyTypeList" :
					var setBoxName = "typeBox";
					var setImgPath = url + '/_common/img/bodyType/' + "s_" + $("." + $(this).val() + "Icon").val() + ".png";
					var setImgStyle = "background: url(" + setImgPath + ") no-repeat;";
					var setCss      = $("." + $(this).val() + "Css").val();
					break;
				case "themeList"    :
					var setBoxName = "themeBox";
					var setImgPath = url + '/_common/img/theme/' + "s_" + $("." + $(this).val() + "Icon").val() + ".png";
					var setImgStyle = "background: url(" + setImgPath + ") no-repeat 5px;";
					var setCss      = "";
					break;
				case "priceList"    : 
					var setBoxName = "priceBox";
					var setImgPath = "";
					var setImgStyle = "";
					var setCss      = "";
					
						$("." + setBoxName + " ul").find("li").each(function(idx){
							$(this).remove();
						});
					break;
				default:
					return;
			}
			if( $(this).attr('checked') ){
				var selName = $("." + $(this).val() + "Name").val();
				$("." + setBoxName + " ul").prepend("<li class='setCol " + setCss + " " + $(this).val() + "'><div style='" + setImgStyle + "'>"+ selName +"</div></li>");
			} else {
				$("." + $(this).val() ).remove();
			}
		});

		//---------------------------------------
		// 「クリア」ボタン押下時
		//---------------------------------------
		$(".selectBox .clearChecked, .actionBox .clearChecked").on("click", function(){
			var boxName = $(this).parents("div").attr("class");
			$("#rankingSearch .searchForm ." + boxName).find(":checked").each(function(idx){
				// チェック状態を外す
				$(this).attr("checked", false);
				// ボタンのスタイル変更
				$(this).parents("li").removeClass('selected');
				// メニューから除外
				$("." + $(this).val() ).remove();
			});
			setCheckedList();	// チェック済リスト再設定
			defaultPrice();		// 価格デフォルト設定
			setCarGradeNum();	// 件数再設定
		});

		//---------------------------------------
		// historyback対応
		//---------------------------------------
		setCheckedList();	// チェック済リスト再設定
		defaultPrice();		// 価格デフォルト設定
		
		// 検索条件選択・解除時のイベントを実行し、スタイルを設定
		var initSearchItems = arrMaker.concat(arrBodyType).concat(arrTheme).concat(arrPrice);
		for(var i=0; i<initSearchItems.length; i++){
			$(".searchForm input:checkbox[value='" + initSearchItems[i] + "']").triggerHandler("click");
		}
		setCarGradeNum();	// 件数再設定

	}

	//--------------------------------------------
	// ランキング画面
	//--------------------------------------------
	if( $("#rankingPage").length > 0 ){
		//---------------------------------------
		// 「選択した検索条件」下部は非表示
		//---------------------------------------
		$(".selectSelectListBottom").hide();

		//----------------------------------------------------
		// 検索条件選択・解除時
		//----------------------------------------------------
		$(".searchForm input:checkbox").click(function(){

			// 価格の選択は1つのみ
			if( $(this).attr("name") == "priceList"){
				setPriceCheck( $(this) );
			}

			// 選択したチェックボックスのスタイル設定
			if( $(this).attr('checked') ){
				$(this).parents("li").addClass('selected');
			} else {
				$(this).parents("li").removeClass('selected');
			}

			// 項目別にセレクタを指定
			if( $(this).closest(".selectSelectListTop").length > 0 ){
				var mainSelector = ".selectSelectListTop ";
				var cloneSelector = ".selectSelectListBottom ";
			}else if( $(this).closest(".selectSelectListBottom").length > 0 ){
				var mainSelector = ".selectSelectListBottom ";
				var cloneSelector = ".selectSelectListTop ";
			}

			// 選択・解除した検索条件を上下メニューに反映させる
			var checkListName = $(this).attr("name");
			switch( checkListName ){
				case "makerList"    : 
					var setBoxName  = "makerBox";
					var setImgPath  = "";
					var setImgStyle = "";
					var setCss      = "";
					break;
				case "bodyTypeList" :
					var setBoxName  = "typeBox";
					var setImgPath  = url + '/_common/img/bodyType/' + "s_" + $("." + $(this).val() + "Icon").val() + ".png";
					var setImgStyle = "background: url(" + setImgPath + ") no-repeat;";
					var setCss      = $("." + $(this).val() + "Css").val();
					break;
				case "themeList"    :
					var setBoxName  = "themeBox";
					var setImgPath  = url + '/_common/img/theme/' + "s_" + $("." + $(this).val() + "Icon").val() + ".png";
					var setImgStyle = "background: url(" + setImgPath + ") no-repeat 5px;";
					var setCss      = "";
					break;
				case "priceList"    : 
					var setBoxName = "priceBox";
					var setImgPath = "";
					var setImgStyle = "";
					var setCss      = "";
					
						$("." + setBoxName + " ul").find("li").each(function(idx){
							$(this).remove();
						});
					break;
				default:
					return;
			}
			if( $(this).attr('checked') ){
				var selName = $(mainSelector + "." + $(this).val() + "Name").val();

				var tags = "";
				tags += "<li class='setCol " + setCss + " " + $(this).val() + "'>";
				tags += "<div style='" + setImgStyle + "'>" + selName + "</div>";
				tags += "</li>";
				
				$(mainSelector + " ." + setBoxName + " ul").prepend(tags);
				$(cloneSelector + " ." + setBoxName + " ul").prepend(tags);
				
				
				// 検索条件ボタンのスタイル変更
				$(cloneSelector + ".searchForm input:checkbox[value='" + $(this).val() + "']").attr("checked", true);
				$(cloneSelector + ".searchForm input:checkbox[value='" + $(this).val() + "']").parents("li").addClass('selected');
			} else {
				$(mainSelector + " ." + $(this).val() ).remove();
				$(cloneSelector + " ." + $(this).val() ).remove();
				// 検索条件ボタンのスタイル変更
				$(cloneSelector + ".searchForm input:checkbox[value='" + $(this).val() + "']").attr("checked", false);
				$(cloneSelector + ".searchForm input:checkbox[value='" + $(this).val() + "']").parents("li").removeClass('selected');
			}
		});

		//---------------------------------------
		// 「条件を変更する」ボタン押下時
		//---------------------------------------
		$(".selectBox .showSearchForm, .actionBox .showSearchForm").on("click", function(){
			
			// 上部・下部のどちらか判定
			var selectSelectList = "";
			var positionLeft     = "";
			if( $(this).closest(".selectSelectListTop").length > 0 ){
				selectSelectList = ".selectSelectListTop ";
			}else if( $(this).closest(".selectSelectListBottom").length > 0 ){
				selectSelectList = ".selectSelectListBottom ";
			}
			
			var boxName = $(this).parents("div").attr("class");
			switch( boxName ){
				case "makerBox"    : setListName = "searchMakerList"; positionLeft = "470px"; break;
				case "typeBox"     : setListName = "searchTypeList";  positionLeft = "795px"; break;
				case "themeBox"    : setListName = "searchThemeList"; positionLeft = "140px"; break;
				case "priceBox"    : setListName = "searchPriceList"; positionLeft = "275px"; break;
				default: return;
			}
			// 一度閉じる
			$(selectSelectList + ".floating").css({visibility:"hidden",display:"none"});
			$(selectSelectList + ".floating .searchForm>div").css({visibility:"hidden",display:"none"});
			// 該当項目を表示
			$(selectSelectList + ".floating").css({visibility:"visible",display:"block"});
			$(selectSelectList + "." + setListName).css({visibility:"visible",display:"block"});
			$(selectSelectList + ".floating" + " .faCaretUp").css({left: positionLeft});
		});


		//---------------------------------------
		// 「キャンセル」ボタン押下時
		//---------------------------------------
		// 初期選択状態を保持
		setCheckedList();	// チェック済リスト再設定
		var initSearchItems = (arrMaker.reverse()).concat((arrBodyType.reverse())).concat((arrTheme.reverse())).concat((arrPrice.reverse()));

		$('.floating a[data-linkName^="no"]').click(function(){
			
			// 項目別にセレクタを指定
			if( $(this).closest(".selectSelectListTop").length > 0 ){
				var mainSelector = ".selectSelectListTop ";
				var cloneSelector = ".selectSelectListBottom ";
			}else if( $(this).closest(".selectSelectListBottom").length > 0 ){
				var mainSelector = ".selectSelectListBottom ";
				var cloneSelector = ".selectSelectListTop ";
			}

			// 選択項目を初期選択状態に戻す
			// メーカー、ボディタイプ、テーマ全ての選択状態を解除
			$(mainSelector + ".searchForm").find(":checked").each(function(idx){
				// チェック状態を外す
				$(this).attr("checked", false);
				// ボタンのスタイル変更
				$(this).parents("li").removeClass('selected');
				// メニューから除外
				$(mainSelector + "." + $(this).val() ).remove();
			});
			$(cloneSelector + ".searchForm").find(":checked").each(function(idx){
				// チェック状態を外す
				$(this).attr("checked", false);
				// ボタンのスタイル変更
				$(this).parents("li").removeClass('selected');
				// メニューから除外
				$(cloneSelector + "." + $(this).val() ).remove();
			});
			
			// 初期選択状態を再現
			$.each(initSearchItems, function(key, value){
				var targetObj = $(mainSelector + ".searchForm").find(":checkbox[value='" + value + "']");

				// チェック状態を入れる
				$(targetObj).attr("checked", true);
				// ボタンのスタイル変更
				$(targetObj).parents("li").addClass('selected');
				// メニューに追加
				switch( $(targetObj).attr("name") ){
					case "makerList"    : 
						var setBoxName = "makerBox";
						var setImgPath = "";
						var setImgStyle = "";
						var setCss      = "";
						break;
					case "bodyTypeList" :
						var setBoxName = "typeBox";
						var setImgPath = url + '/_common/img/bodyType/' + "s_" + $("." + $(targetObj).val() + "Icon").val() + ".png";
						var setImgStyle = "background: url(" + setImgPath + ") no-repeat;";
						var setCss      = $("." + $(targetObj).val() + "Css").val();
						break;
					case "themeList"    :
						var setBoxName = "themeBox";
						var setImgPath = url + '/_common/img/theme/' + "s_" + $("." + $(targetObj).val() + "Icon").val() + ".png";
						var setImgStyle = "background: url(" + setImgPath + ") no-repeat 5px;";
						var setCss      = "";
						break;
					case "priceList"    : 
						var setBoxName = "priceBox";
						var setImgPath = "";
						var setImgStyle = "";
						var setCss      = "";
						
							$("." + setBoxName + " ul").find("li").each(function(idx){
								$(this).remove();
							});
						break;
					default:
						return;
				}
				var tags = "";
				tags += "<li class='setCol " + setCss + " " + $(targetObj).val() + "'>";
				tags += "<div style='" + setImgStyle + "'>" + $("." + $(targetObj).val() + "Name").val() + "</div>";
				tags += "</li>";
				$(mainSelector + "." + setBoxName + " ul").prepend(tags);
				
				// チェック状態を入れる
				$(cloneSelector + "[value='" + $(targetObj).val() + "']").attr("checked", true);
				// ボタンのスタイル変更
				$(cloneSelector + "[value='" + $(targetObj).val() + "']").parents("li").addClass('selected');
				// メニューに追加
				$(cloneSelector + "." + setBoxName + " ul").prepend(tags);
			});

			// ウィンドウを閉じる
			$(mainSelector + ".floating").css({visibility:"hidden",display:"none"});
			$(mainSelector + ".floating .searchForm>div").css({visibility:"hidden",display:"none"});

			// ウィンドウを閉じる
			$(cloneSelector + ".floating").css({visibility:"hidden",display:"none"});
			$(cloneSelector + ".floating .searchForm>div").css({visibility:"hidden",display:"none"});

			setCheckedList();	// チェック済リスト再設定
			setCarGradeNum();	// 件数再設定
		});


		//---------------------------------------
		// 「クリア」ボタン押下時
		//---------------------------------------
		$('.floating .clearBtn').click(function(){
			// 項目別にセレクタを指定
			if( $(this).closest(".selectSelectListTop").length > 0 ){
				var mainSelector = ".selectSelectListTop ";
				var cloneSelector = ".selectSelectListBottom ";
			}else if( $(this).closest(".selectSelectListBottom").length > 0 ){
				var mainSelector = ".selectSelectListBottom ";
				var cloneSelector = ".selectSelectListTop ";
			}

			// メーカー、ボディタイプ、テーマ全ての選択状態を解除
			$(this).nextAll(".themeBox,.makerBox,.typeBox,.priceBox").find(":checked").each(function(idx){
				// チェック状態を外す
				$(this).attr("checked", false);
				// ボタンのスタイル変更
				$(this).parents("li").removeClass('selected');
				// メニューから除外
				$(mainSelector + "." + $(this).val() ).remove();
				
				// cloneSelector側も同様に変更
				$(cloneSelector + ".searchForm :checked[value='" + $(this).val() + "']")
					.attr("checked", false)						// チェック状態を外す
					.parents("li").removeClass('selected');		// ボタンのスタイル変更
				
				// メニューから除外
				$(cloneSelector + "." + $(this).val() ).remove();
			});

			setCheckedList();	// チェック済リスト再設定
			defaultPrice();		// 価格デフォルト設定
			setCarGradeNum();	// 件数再設定
		});
	}


	//--------------------------------------------
	// トップ画面・ランキング画面共通
	//--------------------------------------------

	//---------------
	// 条件選択時
	//---------------
	$(".searchForm input:checkbox").click(function(){
		setCheckedList();	// チェック済リスト再設定
		setCarGradeNum();	// 件数再設定
	});

	//---------------------------------------
	// 「この条件で検索」ボタン押下時
	//---------------------------------------
	$('#topPage a[data-linkName^="ok"], .floating a[data-linkName^="ok"]').click(function(){

		// 使い方ガイド中の場合、フラグを設定
		var gaide = "";
		if( $("#guide").length > 0 ){
			gaide = "?guide=guide";
		}


		setCheckedList();	// チェック済リスト再設定

		var url = $(".searchForm").attr('action');
		var optionM = "MMM";
		var optionB = "BBB";
		var optionT = "TTT";
		var optionP = "PPP";
		
		if( arrMaker.length > 0 ){
			optionM = arrMaker.join("-");
		}

		if( arrBodyType.length > 0 ){
			optionB = arrBodyType.join("-");
		}

		if( arrTheme.length > 0 ){
			optionT = arrTheme.join("-");
		}

		if( arrPrice[0] != null ){
			optionP = arrPrice[0];
		}

		location.href = url + optionM + "/" + optionB + "/" + optionT + "/" + optionP + "/" + gaide;
	});

});
