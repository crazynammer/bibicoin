$(document).ready(function() {
	//alert($("#before-content-area").text());
	if ($("#before-content-area").text().trim() == "Buy Bitcoins")
	{
		$("#transaction_TWDAmt").on('input', function(){
			var twdAmt = $("#transaction_TWDAmt").val();
			var btcToTwd= this.getAttribute("data-btcToTwd");
			var btcAmt = +twdAmt / +btcToTwd;
			if (btcAmt == 'NaN')
			{
				btcAmt = +0;
			}
			$("#transaction_BTCAmt").val(parseFloat(+btcAmt).toFixed(5));
		});
	}
});
