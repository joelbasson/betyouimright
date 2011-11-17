/**
 * jQuery Spotlight
 *
 * Project Page: http://dev7studios.com/portfolio/jquery-spotlight/
 * Copyright (c) 2009 Gilbert Pellegrom, http://www.gilbertpellegrom.co.uk
 * Licensed under the GPL license (http://www.gnu.org/licenses/gpl-3.0.html)
 * Version 1.0 (12/06/2009)
 */
(function(a){a.fn.spotlight=function(b){settings=a.extend({},{opacity:.5,speed:400,color:"#333",animate:!0,easing:"",exitEvent:"click",onShow:function(){},onHide:function(){}},b);if(!jQuery.support.opacity)return!1;if(a("#spotlight").size()==0){a("body").append('<div id="spotlight"></div>');var c=a(this),d=a("#spotlight");d.css({position:"fixed",background:settings.color,opacity:"0",top:"0px",left:"0px",height:"100%",width:"100%","z-index":"9998"});var e=c.css("position");e=="static"?c.css({position:"relative","z-index":"9999"}):c.css("z-index","9999"),settings.animate?d.animate({opacity:settings.opacity},settings.speed,settings.easing,function(){settings.onShow.call(this)}):(d.css("opacity",settings.opacity),settings.onShow.call(this)),d.live(settings.exitEvent,function(){settings.animate?d.animate({opacity:0},settings.speed,settings.easing,function(){e=="static"&&c.css("position","static"),c.css("z-index","1"),a(this).remove(),settings.onHide.call(this)}):(d.css("opacity","0"),e=="static"&&c.css("position","static"),c.css("z-index","1"),a(this).remove(),settings.onHide.call(this))})}return this}})(jQuery)