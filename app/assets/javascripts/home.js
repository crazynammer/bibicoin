$(document).ready(function(){
	$("#NTDBuy").on('input', function(){
		var twdAmt = $("#NTDBuy").val();
		var btcToTwd = this.getAttribute("data-value");
		var btcAmt = +twdAmt / +btcToTwd;
		$("#BTCBuy").val(parseFloat(+btcAmt).toFixed(5));
	});
});


$(document).ready(function() {
	$("#NTDSell").on('input', function (){
		var btcAmt = $("#NTDSell").val();
		var btcToTwd = this.getAttribute("data-value");
		var twdAmt = +btcAmt * +btcToTwd;
		$("#BTCSell").val(parseFloat(+twdAmt).toFixed(0));
	});
});
