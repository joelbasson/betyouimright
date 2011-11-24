$(function() {
	
	$(".pagination a").live("click", function() {	
	    	$.getScript(this.href);
	    	return false;
	  });
	
	$("a.fb-fancybox").live("click",function(ev){
		ev.preventDefault();
		$.fancybox({
			'href'	: this.href,
			'type'	: 'inline',
			'padding'	: '0',
			'autoDimensions' : false,
			'width'           : '650',
			'height'          : '850',
			'onComplete'		: function() {
				    $('form[data-validate]').validate();
					if (this.href.indexOf('/bets/') > 0) {
						activateClipboard(this.href.substring(this.href.indexOf('/bets/')+6));
					}
				}
		})
	});
	
	$("#terms-fb-link").live('click', function(){
		$("#terms-fb-copy").toggle( 300 );
		return false;
	});
	
	$(".remote-link").live('click', function(){
		$.getScript(this.href);
		return false;
	});
	
});

function fbFlashNotice() {
  	var flash = $('#fancybox-content .flash:first');
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

function showBetPopup(page){
	$.fancybox({
		'href'	: '/bets/' + page,
		'type'	: 'inline',
		'padding'	: '0',
		'autoDimensions' : false,
		'width'           : '650',
		'height'          : '700',
		'onComplete'		: function() {
				activateClipboard(page);
			}
	})
};

function activateClipboard(page){
	ZeroClipboard.setMoviePath('/swf/ZeroClipboard.swf');
	var clip = new ZeroClipboard.Client();

	clip.setHandCursor( true );
	clip.setText( 'http://apps.facebook.com/betyouimright/bets/' + page );
	clip.glue( 'd_clip_button', 'd_clip_container' );
};