jQuery.ajaxSetup({ cache: true });

$(function() {
	flashNotice();
	
	$('#purchase_new').submit(function(){
		value = $('#purchase_amount').val();
		if (value == "")
		{
			alert("Amount cannot be empty");
			return false;
		}
		else if (!confirm("Are you sure you would like to purchase " + value + " credits ?"))
		{
			return false;
		}
	});
	
	$(".trigger").live('click', function(){
		$(".sliding-panel").slideToggle();
		$(this).toggleClass("active");
		return false;
	});
	
	if ($("#wallet-display-name").length>0)
	{
		if ($("#wallet-display-name").text() == "Please Change me!")
		{
			$("#wallet-display-name").toggleClass("highlight");
			 $("#wallet-display-name").effect("pulsate", { times:10 }, 1000, function(){
				$("#wallet-display-name").toggleClass("highlight");
			});	
		}
	};
	
	bindCalendar();
	
	$("#winners-losers-link").live("click", function(){
		$("#winners-panel").toggle( "slide", {}, 500 );
		if ($(this).text() == "Show Winners and Losers >>")
		{
			$(this).text("<< Hide Winners and Losers");
		}
		else
		{
			$(this).text("Show Winners and Losers >>");
		}
		return false;
	});
	
	$("#bet-wagers-link").live("click", function(){
		showWagers();
		return false;
	});
	
	$("a.show-replies").live("click", function(){ 
        $(this).parent().parent().next().next().find('.replies:first').toggle('slide'); 
        $(this).text(($(this).text() == "Hide Replies") ? this.getAttribute("data-text") : "Hide Replies");
		return false;
	});
	
		$('a#terms-link').live('click', function() {
			$.fancybox({
						'padding'		: 0,
						'autoScale'		: false,
						'autoDimensions'	: false,
						'scrolling'		: 'auto',
						'href'			: this.href + ".js",
						'type'			: 'ajax'
					});
			return false;
		});
		
		$("#traditional-link").live("click", function(){
			$("#traditional").slideToggle(500);
			return false;
		});

		$("a.popup").click(function(e) {
		  popupCenter($(this).attr("href"), $(this).attr("data-width"), $(this).attr("data-height"), "authPopup");
		  e.stopPropagation(); return false;
		});
		
		$("#facebook-bet-post").live("click", function(){
			return false;
		});
		
		$("#invite-facebook").live("click", function(){
			FB.ui({method: "apprequests", message: "This fantastic app allows you to bet people that you are right about something", title: "Bet you're right"});
		});

		$(".infobox-admin").click(function(){
			$(this).toggleClass("opaque");
		});
		
		$("#country-close").live('click', function(){
			$("#country-warning").hide();
			return false;
		});
		
		$("#notifications").slideDown();
		
		$("#notifications-button").click(function(){
			$("#notifications-wrapper").toggle( 300 );
		});
		
		$(".notification").live('click', function(){
			$(".notification .notification-message").toggle( 300 );
		});
		
		$("a.sort_link").live('click', function(){
			$.getScript(this.href);
			return false;
		});

});

function flashNotice() {
  	var flash = $('.flash');
	  if (flash.length > 0) {
		if (($("#traditional").length>0) && (flash.text() != "You need to sign in or sign up before continuing."))
		{
			$("#traditional").show();
		}
		// if (flash.text() == "Successfully created bet.")
		// {
		// 	createNewBetPopUp();
		// }
	    flash.show().animate({height: flash.outerHeight()}, 300);

	    window.setTimeout(function() {
	      flash.slideUp();
	    }, 3000);
	  }
};

function createNewBetPopUp(){
	
};

function showWagers(){
	$("#bet-wagers-list").toggle( "slide", {}, 500 );
	if ($("#bet-wagers-link").text() == "Show Wagers Placed >>")
	{
		$("#bet-wagers-link").text("<< Hide Wagers Placed");
	}
	else
	{
		$("#bet-wagers-link").text("Show Wagers Placed >>");
	}
};

function popupCenter(url, width, height, name) {
  var left = (screen.width/2)-(width/2);
  var top = (screen.height/2)-(height/2);
  return window.open(url, name, "menubar=no,toolbar=no,status=no,width="+width+",height="+height+",toolbar=no,left="+left+",top="+top);
};

function showFBPopUp(messsageBody, descriptionBody, captionText, linkText, nameText){
	FB.ui(
	   {
	     method: 'feed',
		 display: 'iframe',
	     name: nameText,
	     link: linkText,
	     caption: captionText,
	     description: descriptionBody,
	     message: messsageBody
	   },
	   function(response) {
	     if (response && response.post_id) {
	       alert('Post was published.');
	     } else {
	       alert('Post was not published.');
	     }
	   }
	 );
};

function clearSession(){
	$.getScript("/javascripts/clear_session.js");
};

function addStylesheet(sheet){
	var ss = document.createElement("link");
	ss.type = "text/css";
	ss.rel = "stylesheet";
	ss.href = sheet;

	if(document.all)
		document.createStyleSheet(ss.href);
	else
		document.getElementsByTagName("head")[0].appendChild(ss);
};

function spotlightBet(){
	$("#container-left").spotlight({
		opacity: .5,
		color: 'black',
		onShow: function(){
			$("#infobox").addClass("opaque");
			$("#newbet-infobox").show();
			$("div.facebook-buttons").effect("pulsate", { times:5 }, 1000);
			setTimeout("$('#spotlight').click()",4000);
		},	
		onHide: function(){
			$("#newbet-infobox").hide();
			$("#infobox").removeClass("opaque");
		}
	});
};

function getUserCounty(){
	updateLocation(function(coords){
		if (coords) {
			$.getScript('/javascripts/get_country_code.js?lat=' + coords.latitude + '&lng=' + coords.longitude);  	
	     } else {
	         alert('Device not capable of geo-location.');
	     }
	});
};

function bindCalendar(){
	$("#bet_end_date").before("<span id='datepicker'></span>")
	$("#bet_end_date").hide();
	$("#datepicker").datepicker({
		dateFormat: 'yy-mm-dd',
		defaultDate: $("#bet_end_date").val(),
		onSelect: function(dateText, inst) { 
		     $('#bet_end_date').val(dateText); //the first parameter of this function
			 $("#bet_end_date").trigger('change');
			 $(".ui-state-default").live("mouseleave", function() {
			        $("#bet_end_date").trigger('focusout');
			 });
		 }
	});
};