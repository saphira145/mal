jQuery(function($){
	/**
	 * jQuery UI datepicker 日本語メッセージ
	 */
	$.datepicker.regional['ja']={
		closeText:'閉じる',
		prevText:'&#x3c;前月',
		nextText:'次月&#x3e;',
		currentText:'今日',
		monthNames:['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月'],
		monthNamesShort:['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月'],
		dayNames:['日曜日','月曜日','火曜日','水曜日','木曜日','金曜日','土曜日'],
		dayNamesShort:['日','月','火','水','木','金','土'],
		dayNamesMin:['日','月','火','水','木','金','土'],
		weekHeader:'週',
		dateFormat:'yy/mm/dd',
		firstDay:0,
		isRTL:false,
		showMonthAfterYear:true,
		yearSuffix:'年'
	};
	$.datepicker.setDefaults($.datepicker.regional['ja']);
});
$(document).ready(function(){
	/**
	 * jQuery UI datepicker 設定
	 */
	$('form[name=form_addConfirm] input[name=\'modelInfo[announcementDay][date]\']').datepicker({
		changeYear:true,
		changeMonth:true
	});
	$('form[name=form_main] input[name=\'modelInfo[announcementDay][date]\']').datepicker({
		changeYear:true,
		changeMonth:true
	});
	$('form[name=form_search] input[name=\'downloadInfo[from][date]\']').datepicker({
		changeYear:true,
		changeMonth:true,
		maxDate:0,
		onClose:function(selectedDate){
			$('form[name=form_search] input[name=\'downloadInfo[to][date]\']').datepicker('option','minDate',selectedDate);
		}
	});
	$('form[name=form_search] input[name=\'downloadInfo[to][date]\']').datepicker({
		changeYear:true,
		changeMonth:true,
		maxDate:0,
		onClose:function(selectedDate){
			$('form[name=form_search] input[name=\'downloadInfo[from][date]\']').datepicker('option','maxDate',selectedDate);
		}
	});
});
