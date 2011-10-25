var currentPage = '';

$(function() {
	
	$("a.fancybox").live("click",function(ev){
		ev.preventDefault();
		$.fancybox({
			'href'	: this.href,
			'type'	: 'ajax',
			'padding'	: '0',
			'autoDimensions' : false,
			'width'           : '650',
			'height'          : '700'
		})
	});

	$(".pagination a").live("click", function() {	
	    	$.getScript(this.href);
			
			if ((this.href.indexOf("my_transactions_page") == -1) && (this.href.indexOf("my_wagers_page") == -1) && ($("h2").text() != "Users"))
			{
				currentPage = this.href;
				history.pushState(null, this.href, this.href);
			}
	    	return false;
	  });
	
	$(window).bind("popstate", function() {
			if (currentPage != location.pathname && currentPage != '')
			{
				currentPage = location.pathname;
			 	$.getScript(location.pathname);
			}
		});
		
	$("#bet_search").live("submit", function(){
		var url = $("#bet_search").serialize();
		var fullUrl = $("#bet_search").attr("action") + "?" + url
		currentPage = url;
		history.pushState(null, fullUrl, fullUrl);
		// $.get($("#bet_search").attr("action"), url, null, "script");
	    return false;
	});	
	
});