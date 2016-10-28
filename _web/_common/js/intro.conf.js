function startIntro( page ){
	var intro=introJs();
	var introSteps=0;
	
	intro.setOptions({
		nextLabel:'次へ',
		prevLabel:'前へ',
		skipLabel:'終了',
		doneLabel:'次のページへ',
		keyboardNavigation:false
	});
	
	
	switch( page ){
		// トップページ
		case "top":
			var steps = [
				{
					element:document.querySelector('#header'),
					stepNum:1,
					intro:'三菱オートリースの車種比較サイト<br><span style="font-weight:bold">Car sagacité [カー サガシティ]</span> へようこそ!<br><br>皆さまのビジネスに沿ったクルマをランキングから選び、<br>クルマ同士を詳しく比較できるサイトとしてご活用ください。<br><br>それではサイトの使い方をご紹介いたします。'
				},
				{
					element:document.querySelector('#campaign'),
					stepNum:2,
					position:'top',
					intro:'開催中のキャンペーンをこちらで紹介しています。<br>詳しくご覧になるには、それぞれのキャンペーンを<br>クリックしてください。'
				},
				{
					element:document.querySelector('#campaign ul+a'),
					stepNum:4,
					position:'left',
					intro:'他のキャンペーン情報をご覧になるには、<br>こちらをクリックしてください。<br><span class="fsmall">※三菱オートリースの MAL Marché (マルシェ) へ移動します。</span>'
				},
				{
					element:document.querySelector('#newCar'),
					stepNum:5,
					position:'top',
					intro:'話題の新型車をこちらで紹介しています。<br>詳しくご覧になるには、それそれのクルマの<br>「スペックを見る」ボタンをクリックしてください。'
				},
				{
					element:document.querySelector('#rankingSearch'),
					stepNum:7,
					position:'top',
					intro:'探したいクルマの条件です。<br>条件を選ぶことで、クルマを絞り込めます。'
				},
				{
					element:document.querySelector('.searchPriceList'),
					stepNum:8,
					position: 'top',
					intro:'クルマの価格を指定には、ご希望の価格を<br>クリックします。'
				},
				{
					element:document.querySelector('.searchThemeList'),
					stepNum:8,
					position: 'top',
					intro:'「バリュー」は価値のこと。皆さまのビジネスに<br>価値あるクルマを見つけてください。<br>「バリュー」を指定するには、それぞれのバリューを<br>クリックします。'
				},
				{
					element:document.querySelector('.basisOfSelectionLink'),
					stepNum:9,
					position: 'top',
					intro:'「バリュー」の選定基準はこちらからご覧ください。'
				},
				{
					element:document.querySelector('.searchMakerList'),
					stepNum:10,
					position:'top',
					intro:'メーカーを指定するには、それぞれのメーカーを<br>クリックします。'
				},
				{
					element:document.querySelector('.searchTypeList'),
					stepNum:11,
					position:'top',
					intro:'クルマの車型 (タイプ) を指定するには、それぞれの<br>タイプをクリックします。'
				},
				{
					element:document.querySelector('#topPage .floating'),
					stepNum:12,
					actionStep:101,
					position:'top',
					intro:'選んだ条件がここに表示されます。'
				},
				{
					element:document.querySelector('.selectBox .themeBox'),
					stepNum:13,
					actionStep:102,
					position:'top',
					intro:'チェックしたバリューが表示されます。'
				},
				{
					element:document.querySelector('.selectBox .themeBox .clearChecked'),
					stepNum:14,
					actionStep:103,
					position:'top',
					intro:'「クリア」をクリックすると、選んだバリューの<br>チェックが全て外れます。'
				},
				{
					element:document.querySelector('.selectBox .makerBox'),
					stepNum:15,
					actionStep:104,
					position:'top',
					intro:'チェックしたメーカーが表示されます。<br>「クリア」をクリックすると、選んだメーカーの<br>チェックが全て外れます。'
				},
				{
					element:document.querySelector('.selectBox .typeBox'),
					stepNum:16,
					actionStep:105,
					position:'top',
					intro:'チェックしたタイプが表示されます。<br>「クリア」をクリックすると、選んだタイプの<br>チェックが全て外れます。'
				},
				{
					element:document.querySelector('.actionBox .priceBox'),
					stepNum:16,
					actionStep:110,
					position:'top',
					intro:'指定している価格が表示されます。<br />「クリア」をクリックすると、「指定なし」になります。'
				},
				{
					element:document.querySelector('#searchModelName .left'),
					stepNum:17,
					intro:'こちらのボックスにクルマの名称を<br>直接指定することもできます。'
				},
				{
					element:document.querySelector('#modelNameResult'),
					stepNum:18,
					actionStep:106,
					intro:'例えば「レクサス」と入力すると、このような一覧が<br>表示されます。クルマを詳しくご覧になるには<br>それぞれのクルマをクリックしてください。'
				},
				{
					element:document.querySelector('.searchThemeList li:first-child'),
					stepNum:19,
					actionStep:107,
					position:'top',
					intro:'クルマのバリューをクリックします。'
				},
				{
					element:document.querySelector('.searchMakerList li:first-child'),
					stepNum:20,
					actionStep:108,
					position:'top',
					intro:'同じようにメーカーをクリックします。'
				},
				{
					element:document.querySelector('.actionBox .faSearch'),
					stepNum:21,
					actionStep:109,
					position: 'top',
					tooltipClass:'positionSet',
					intro:'それでは検索してみましょう。<br>「次のページヘ」をクリックしてください。'
				}
			];
		break;

		// ランキング(データあり)
		case "ranking":
			var steps = [
				{
					element:document.querySelector('#rankingList'),
					stepNum:24,
					position:'top',
					intro:'このページでは、お選びいただいた条件に沿ったクルマを<br><span style="font-weight:bold">注目度ランキング</span> 順にご覧いただけます。'
				},
				{
					element:document.querySelector('#rankingList li:first-child label'),
					stepNum:26,
					position:'top',
					intro:'気になるクルマを選び、詳しく比較できます。<br>クルマを選ぶには、左側にチェックを入れてください。<br>3車種までお選びいただけます。'
				},
				{
					element:document.querySelector('#rankingList li:first-child .themeBox'),
					stepNum:27,
					position:'top',
					intro:'このクルマの価値「バリュー」です。<br>'
				},
				{
					element:document.querySelector('#rankingList li:first-child .themeBox li:first-child'),
					stepNum:28,
					position:'top',
					intro:'クリックしたバリューを条件に、再検索することもできます。<br><span class="fsmall">※他の条件は全て外れます。</span>'
				},
				{
					element:document.querySelector('.nextListButton'),
					stepNum:29,
					position:'top',
					check:1,
					intro:'ランキングの続きを見る場合はクリックしてください。'
				},
				{
					element:document.querySelector('.selectSelectListTop .themeBox .showSearchForm'),
					stepNum:30,
					actionStep:201,
					intro:'検索条件を変更したい場合はクリックしてください。'
				},
				{
					element:document.querySelector('.selectSelectList .floating '),
					stepNum:31,
					actionStep:202,
					position:'top',
					intro:'「バリュー」の検索条件を変更できます。'
				},
				{
					element:document.querySelector('.searchThemeList .clearChecked'),
					stepNum:32,
					actionStep:202,
					position:'left',
					intro:'クリックすると選んだバリューのチェックが全て外れます。'
				},
				{
					element:document.querySelector('.floating a[name^="no"]'),
					stepNum:33,
					actionStep:202,
					position:'right',
					intro:'検索条件を変更しない場合はクリックしてください。'
				},
				{
					element:document.querySelector('.floating a[name^="ok"]'),
					stepNum:34,
					actionStep:202,
					position:'left',
					intro:'新しい条件でクルマを検索します。'
				},
				{
					element:document.querySelector('.selectSelectListTop .makerBox .showSearchForm '),
					stepNum:35,
					actionStep:203,
					intro:'「メーカー」の検索条件を変更したい場合は<br>こちらをクリックします。「クリア」をクリックすると、<br>選んだメーカーのチェックが全て外れます。'
				},
				{
					element:document.querySelector('.selectSelectListTop .typeBox .showSearchForm '),
					stepNum:36,
					actionStep:204,
					intro:'「クルマの形 (タイプ) 」の検索条件を変更するには<br>こちらをクリックします。「クリア」をクリックすると、<br>選んだタイプのチェックが全て外れます。'
				},
				{
					element:document.querySelector('.selectSelectListTop .priceBox .showSearchForm '),
					stepNum:36,
					actionStep:209,
					intro:'「価格」の検索条件を変更するには<br>こちらをクリックします。「クリア」をクリックすると、「指定なし」になります。'
				},
				{
					element:document.querySelector('#rankingForm li:first-child label'),
					stepNum:37,
					actionStep:205,
					position:'top',
					intro:'気になるクルマをチェックします。'
				},
				{
					element:document.querySelector('#rankingForm li:first-child+li label'),
					stepNum:38,
					actionStep:206,
					position:'top',
					intro:'同じように気になるクルマをチェックします。'
				},
				{
					element:document.querySelector('.selectSelectListTop .actionBtn a'),
					stepNum:39,
					actionStep:207,
					position:'top',
					intro:'それではチェックしたクルマを比較してみましょう。<br>「次のページへ」をクリックしてください。'
				}
			];
		break;

		// ランキング(データなし)
		case "ranking_notCarData":
			var steps = [
				{
					element:document.querySelector('#rankingList'),
					stepNum:24,
					position:'top',
					intro:'このページでは、先ほどお選びいただいた条件に沿ったクルマを<span style="font-weight:bold">注目度ランキング</span> 順にご覧いただけます。<br>今回検索した条件では該当するクルマはありませんでした。'
				},
				{
					element:document.querySelector('.selectSelectListTop .themeBox .showSearchForm'),
					stepNum:30,
					actionStep:201,
					intro:'検索条件を変更したい場合はクリックしてください。'
				},
				{
					element:document.querySelector('.selectSelectList .floating '),
					stepNum:31,
					actionStep:202,
					position:'top',
					intro:'「バリュー」の検索条件を変更できます。'
				},
				{
					element:document.querySelector('.searchThemeList .clearChecked'),
					stepNum:32,
					actionStep:202,
					position:'left',
					intro:'クリックすると選んだバリューのチェックが全て外れます。'
				},
				{
					element:document.querySelector('.floating a[name^="no"]'),
					stepNum:33,
					actionStep:202,
					position:'right',
					intro:'検索条件を変更しない場合はクリックしてください。'
				},
				{
					element:document.querySelector('.floating a[name^="ok"]'),
					stepNum:34,
					actionStep:202,
					position:'left',
					intro:'新しい条件でクルマを検索します。'
				},
				{
					element:document.querySelector('.selectSelectListTop .makerBox .showSearchForm '),
					stepNum:35,
					actionStep:203,
					intro:'「メーカー」の検索条件を変更したい場合は<br>こちらをクリックします。「クリア」をクリックすると、<br>選んだメーカーのチェックが全て外れます。'
				},
				{
					element:document.querySelector('.selectSelectListTop .typeBox .showSearchForm '),
					stepNum:36,
					actionStep:204,
					intro:'「クルマの形 (タイプ) 」の検索条件を変更するには<br>こちらをクリックします。「クリア」をクリックすると、<br>選んだタイプのチェックが全て外れます。'
				},
				{
					element:document.querySelector('.selectSelectListTop .priceBox .showSearchForm '),
					stepNum:36,
					actionStep:209,
					intro:'「価格」の検索条件を変更するには<br>こちらをクリックします。「クリア」をクリックすると、「指定なし」になります。'
				},
				{
					element:document.querySelector('.selectSelectListTop'),
					stepNum:24,
					actionStep:208,
					position:'top',
					intro:'条件を変更してクルマを検索してみましょう。'
				}
			];
		break;

		// 比較
		case "compare":
			var steps = [
				{
					element:document.querySelector('#header'),
					stepNum:40,
					intro:'お選びいただいたクルマを詳しく検討できる<br><span style="font-weight:bold">車種比較</span> ページです。'
				},
				{
					element:document.querySelector('.compareSearchData'),
					stepNum:41,
					position:'right',
					intro:'注目度ランキングで選択した検索条件です。'
				},
				{
					element:document.querySelector('.compareSearchData .back '),
					stepNum:42,
					position:'right',
					intro:'注目度ランキングからクルマを選び直すには、<br>こちらをクリックします。'
				},
				{
					element:document.querySelector('.compareSearchData+.compareCarData'),
					stepNum:43,
					position:'right',
					intro:'選択したクルマの情報です。'
				},
				{
					element:document.querySelector('.compareSearchData+.compareCarData .carChange a'),
					stepNum:44,
					position:'top',
					intro:'車種を変更するには、こちらをクリックします。<br><span class="fsmall">※現在選択されている検索条件はすべて外れます。</span>'
				},
				{
					element:document.querySelector('.compareSearchData+.compareCarData .campaignScore+tr td'),
					stepNum:45,
					position:'top',
					intro:'車種のグレードを変更するには、こちらから<br>お選びください。<br><span class="fsmall">※現在選択されている検索条件はすべて外れます。</span>'
				},
				{
					element:document.querySelector('.compareSearchData+.compareCarData .themeBox td'),
					stepNum:46,
					position:'top',
					intro:'このクルマの価値「バリュー」です。'
				},
				{
					element:document.querySelector('.compareSearchData+.compareCarData .themeBox li:first-child'),
					stepNum:47,
					position:'top',
					intro:'クリックしたバリューを条件に、<br>再検索することもできます。<br><span class="fsmall">※注目度ランキングが表示されます。</span>'
				},
				{
					element:document.querySelector('#compareDetail'),
					stepNum:48,
					position:'top',
					intro:'クルマの基本スペック、内外装など、詳しい情報を<br>ご覧いただけます。'
				},
				{
					element:document.querySelector('#detail01 h2 span+span'),
					stepNum:49,
					position:'left',
					intro:'こちらをクリックすると、該当項目の表示・非表示を<br>切り替えられます。'
				},
				{
					element:document.querySelector('#footer li a.estimate img'),
					stepNum:50,
					position:'top',
					intro:'リースのお見積りをご希望の方は、<br>こちらをクリックしてください。<br><br>お見積のご依頼方法をご覧になりたい方は、<br>右サイドメニューにある「<span class="faFileTexto" style="font-weight:bold; font-size:16px;"></span>」ボタンをクリックしてください。'
				},
				{
					element:document.querySelector('#header'),
					stepNum:51,
					actionStep:301,
					intro:'あなたのビジネスに合ったクルマを<br>是非 <span style="font-weight:bold">Car sagacité [カー サガシティ]</span> で<br>探して、比べて、見つけてください。'
				}
			];
		break;
	}

	// ステップ前
	intro.onbeforechange(function(){
		var thisactionStep = intro._options.steps[intro._currentStep].actionStep;

		
		switch(thisactionStep){
			case 101:
				$('.searchThemeList li:first-child input:checkbox').click();
				$('.searchThemeList li:first-child+li input:checkbox').click();
			break;
			case 104:
				$('.selectBox .themeBox .clearChecked').click();
			break;
			case 301:
				// 終了ボタンの名称変更
				intro._options.doneLabel = "クルマを探す";
			break;
			case 106:
				$('#modelNameInput').val("レクサス");
				$('#modelNameInput').keyup();
			break;
			case 208:
				// 終了ボタンの名称変更
				intro._options.doneLabel = "終了";
			break;
		}

		// トップページ用
		if( $("#topPage").length > 0) {
			$('.introjs-helperLayer').removeClass("addIntrojs-boder");
			$('.introjs-helperLayer').removeClass("addIntrojs-fixed");
			$('.introjs-overlay').removeClass("addIntrojs-overlay");
			$('.introjs-overlay').removeClass("addIntrojs-overlayIE8");
			$('.selectBox').css({"z-index": ""});
			$('#topPage .floating').css({"z-index": ""});
		}

		// ランキングページ用
		if( $("#rankingPage").length > 0) {
			$('.introjs-helperLayer').removeClass("addIntrojs-boderIE8");
			$('.introjs-helperLayer').removeClass("addIntrojs-boder");
			if($(".selectSelectListTop .floating").css("visibility") != "hidden" ){
				$(".selectSelectListTop .floating").css({visibility:"hidden",display:"none"});
				$(".selectSelectListTop .floating .searchForm>div").css({visibility:"hidden",display:"none"});
			}
		}
	});


	// ステップ移動時
	intro.onchange(function(){
		var thisactionStep = intro._options.steps[intro._currentStep].actionStep;

		switch( thisactionStep ){
			case 101:
				$('.introjs-helperLayer').addClass("addIntrojs-fixed");
				$('.selectBox').css({"z-index": "9999999"});
				$('.introjs-overlay').addClass("addIntrojs-overlay");
			break;
			case 102:
				$('.introjs-helperLayer').addClass("addIntrojs-fixed");
				$('.introjs-helperLayer').addClass("addIntrojs-boder");
				$('.introjs-overlay').css({"z-index": ""});
				$('.introjs-overlay').addClass("addIntrojs-overlay");
			break;
			case 103:
				$('.introjs-helperLayer').addClass("addIntrojs-fixed");
				$('.introjs-helperLayer').addClass("addIntrojs-boder");
				$('.introjs-overlay').addClass("addIntrojs-overlay");
			break;
			case 104:
				$('.introjs-helperLayer').addClass("addIntrojs-fixed");
				$('.introjs-helperLayer').addClass("addIntrojs-boder");
				$('.introjs-overlay').addClass("addIntrojs-overlay");
			break;
			case 105:
				$('.introjs-helperLayer').addClass("addIntrojs-fixed");
				$('.introjs-helperLayer').addClass("addIntrojs-boder");
				$('.introjs-overlay').addClass("addIntrojs-overlay");
			break;
			case 107:
				$('#modelNameInput').val("");
				$('#modelNameInput').keyup();
				$('.searchThemeList li:first-child input:checkbox').click();
			break;
			case 108:
				$('.searchMakerList li:first-child input:checkbox').click();
			break;
			case 109:
				$('.introjs-helperLayer').addClass("addIntrojs-fixed");
				$('.introjs-helperLayer').addClass("addIntrojs-boder");
				$('.introjs-overlay').addClass("addIntrojs-overlayIE8");
			break;
			case 110:
				$('.introjs-helperLayer').addClass("addIntrojs-fixed");
				$('.introjs-helperLayer').addClass("addIntrojs-boder");
				$('.introjs-overlay').addClass("addIntrojs-overlay");
			break;
			case 201:
				$('.introjs-helperLayer').addClass("addIntrojs-boderIE8");
			break;
			case 202:
				$('.themeBox .showSearchForm').click();
				$('.introjs-helperLayer').addClass("addIntrojs-boderIE8");
			break;
			case 203:
				$('.makerBox .showSearchForm').click();
				$('.introjs-helperLayer').addClass("addIntrojs-boderIE8");
			break;
			case 204:
				$('.typeBox .showSearchForm').click();
				$('.introjs-helperLayer').addClass("addIntrojs-boderIE8");
			break;
			case 209:
				$('.priceBox .showSearchForm').click();
				$('.introjs-helperLayer').addClass("addIntrojs-boder");
			break;
			case 205:
				$('#rankingForm li:first-child input:checkbox').click();
			break;
			case 206:
				$('#rankingForm li:first-child+li input:checkbox').click();
			break;
			case 207:
				$('.introjs-helperLayer').addClass("addIntrojs-boderIE8");
			break;
		}
	});


	// 最終ステップ終了時
	intro.oncomplete(function(){
		var thisactionStep = intro._options.steps[intro._currentStep].actionStep;

		switch(thisactionStep){
			case 109:
				$('#topPage a[data-linkname^="ok"]').click();
			break;
			case 207:
				var checkCnt = $("#rankingForm").find(':checkbox[name^="selCar"]:checked').length;

				if( checkCnt == 0 ){
					// チェックが0件の場合は、強制的に2件チェックを入れる
					$('#rankingForm li:first-child input:checkbox').click();
					if($('#rankingForm li:first-child+li input:checkbox').length > 0 ){
						$('#rankingForm li:first-child+li input:checkbox').click();
					}
				} else if( checkCnt > 3) {
					// チェックが3件以上の場合は、チェックを外し、強制的に2件チェックを入れる
					$("#rankingForm").find(':checkbox[name^="selCar"]:checked').click();
					$('#rankingForm li:first-child input:checkbox').click();
					if($('#rankingForm li:first-child+li input:checkbox').length > 0 ){
						$('#rankingForm li:first-child+li input:checkbox').click();
					}
				}
				eventClick_compareBtn();
			break;
			case 301:
				var url = $(":hidden[name^='url']").val();
				location.href = url;
			break;
		}
	});


	// ガイド終了
	intro.onexit(function(){
		$("#guide").remove();

		// URLの「guide=guide」を消す
		if(RegExp("guide", "gi").test(window.location.search)){
			window.location.search = window.location.search.replace(/(\?|\&){1}guide=guide/g,'');
		}

	});


	// ステップ項目の確認(対象エレメントが存在しない時、スキップさせる)
	var newSteps = [];
	for (var i = 0, elmsLength = steps.length; i < elmsLength; i++) {
		var elms = steps[i];

		if( !elms.element ){
			switch( page ){
				case "top":
					continue;
				break;

				case "ranking":
					if( elms.check ){
						elms.element = document.querySelector('#gotoTop');
						elms.intro   = 'クルマが１０車種以上の場合、ここに「ランキングの続きをもっとみる」ボタンが表示されます。';
					} else {
						continue;
					}
				break;

				case "compare":
					continue;
				break;
			}
		}
		newSteps.push(elms);
	}
	intro._options.steps = newSteps;
	
	
	intro.start();
}



$().ready(function(){
	
	// トップ
	$('.faQuestionCircle').on('click',function(){
		if( $("#guide").length == 0 ){
			$("body").append('<input type="hidden" id="guide" name="guide" value="true">');

			// ページによって変化
			if( $("#topPage").length > 0 ){
				startIntro("top");
			} else if( $("#rankingPage").length > 0 ){
				
				if( $(".notCarData").length == 0){
					startIntro("ranking");
				} else {
					startIntro("ranking_notCarData");
				}
				
			} else if( $("#compare").length > 0 ){
				startIntro("compare");
			}
		}
	});

	// ランキング(ガイド)
	if( $("#rankingPage").length > 0 && RegExp("guide", "gi").test(window.location.search) ){
		$("body").append('<input type="hidden" id="guide" name="guide" value="true">');
		startIntro("ranking");
	}

	// 比較
	if( $("#compare").length > 0 && RegExp("guide", "gi").test(window.location.search) ){
		$("body").append('<input type="hidden" id="guide" name="guide" value="true">');
		startIntro("compare");
	}

});
