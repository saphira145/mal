var data = [];

$(function(){
	var url  = $(":hidden[name^='url']").val();

	$.ajax({
		type     : "post",
		dataType : "json",
		async    : false,
		url      : url + "/bg/getCarList/",
		success : function(re){
			for(var i=0; i<re.carList.length; i++){
				var listData = re.carList[i];
				data.push({c: listData["c"], m: listData["m"], me: listData["me"]});
			}
		}
	});
});
