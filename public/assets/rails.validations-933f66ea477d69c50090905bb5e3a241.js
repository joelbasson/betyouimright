/*!
 * Rails 3 Client Side Validations - v3.0.1
 * https://github.com/bcardarlela/client_side_validations
 *
 * Copyright (c) 2011 Brian Cardarella
 * Licensed under the MIT license
 * http://www.opensource.org/licenses/mit-license.php
 */
(function(a){a.fn.validate=function(){return this.filter("form[data-validate]").each(function(){var b=a(this),c=window[b.attr("id")];b.submit(function(){return b.isValid(c.validators)}).bind("ajax:beforeSend",function(){return b.isValid(c.validators)}).bind("form:validate:after",function(a){clientSideValidations.callbacks.form.after(b,a)}).bind("form:validate:before",function(a){clientSideValidations.callbacks.form.before(b,a)}).bind("form:validate:fail",function(a){clientSideValidations.callbacks.form.fail(b,a)}).bind("form:validate:pass",function(a){clientSideValidations.callbacks.form.pass(b,a)}).find("[data-validate]:input").live("focusout",function(){a(this).isValid(c.validators)}).live("change",function(){a(this).data("changed",!0)}).live("element:validate:after",function(b){clientSideValidations.callbacks.element.after(a(this),b)}).live("element:validate:before",function(b){clientSideValidations.callbacks.element.before(a(this),b)}).live("element:validate:fail",function(b,c){var e=a(this);clientSideValidations.callbacks.element.fail(e,c,function(){d(e,c)},b)}).live("element:validate:pass",function(b){var c=a(this);clientSideValidations.callbacks.element.pass(c,function(){e(c)},b)}).end().find("[data-validate]:checkbox").live("click",function(){a(this).isValid(c.validators)}).end().find("[id*=_confirmation]").each(function(){var d=a(this),e=b.find("#"+this.id.match(/(.+)_confirmation/)[1]+"[data-validate]:input");a("#"+d.attr("id")).live("focusout",function(){e.data("changed",!0).isValid(c.validators)}).live("keyup",function(){e.data("changed",!0).isValid(c.validators)})});var d=function(a,b){clientSideValidations.formBuilders[c.type].add(a,c,b)},e=function(a){clientSideValidations.formBuilders[c.type].remove(a,c)}})},a.fn.isValid=function(d){return a(this[0]).is("form")?b(a(this[0]),d):c(a(this[0]),d[this[0].name])};var b=function(b,c){var d=!0;return b.trigger("form:validate:before").find("[data-validate]:input").each(function(){a(this).isValid(c)||(d=!1)}),d?b.trigger("form:validate:pass"):b.trigger("form:validate:fail"),b.trigger("form:validate:after"),d},c=function(a,b){a.trigger("element:validate:before");if(a.data("changed")!==!1){var c=!0;a.data("changed",!1);for(kind in clientSideValidations.validators.all())if(b[kind]&&(message=clientSideValidations.validators.all()[kind](a,b[kind]))){a.trigger("element:validate:fail",message).data("valid",!1),c=!1;break}c&&(a.data("valid",null),a.trigger("element:validate:pass"))}return a.trigger("element:validate:after"),a.data("valid")===!1?!1:!0};a(function(){a("form[data-validate]").validate()})})(jQuery);var clientSideValidations={validators:{all:function(){return jQuery.extend({},clientSideValidations.validators.local,clientSideValidations.validators.remote)},local:{presence:function(a,b){if(/^\s*$/.test(a.val()))return b.message},acceptance:function(a,b){switch(a.attr("type")){case"checkbox":if(!a.attr("checked"))return b.message;break;case"text":if(a.val()!=(b.accept||"1"))return b.message}},format:function(a,b){if((message=this.presence(a,b))&&b.allow_blank==1)return;if(message)return message;if(b["with"]&&!b["with"].test(a.val()))return b.message;if(b.without&&b.without.test(a.val()))return b.message},numericality:function(a,b){if(!/^-?(?:\d+|\d{1,3}(?:,\d{3})+)(?:\.\d*)?$/.test(a.val()))return b.messages.numericality;if(b.only_integer&&!/^\d+$/.test(a.val()))return b.messages.only_integer;var c={greater_than:">",greater_than_or_equal_to:">=",equal_to:"==",less_than:"<",less_than_or_equal_to:"<="};for(var d in c)if(b[d]&&!(new Function("return "+a.val()+c[d]+b[d]))())return b.messages[d];if(b.odd&&!(parseInt(a.val())%2))return b.messages.odd;if(b.even&&parseInt(a.val())%2)return b.messages.even},length:function(a,b){var c={};b.is?c.message=b.messages.is:b.minimum&&(c.message=b.messages.minimum);if((message=this.presence(a,c))&&b.allow_blank==1&&!b.maximum)return;if(message)return message;var d={is:"==",minimum:">=",maximum:"<="},e=b.js_tokenizer||"split('')",f=(new Function("element","return (element.val()."+e+" || '').length;"))(a);for(var g in d)if(b[g]&&!(new Function("return "+f+d[g]+b[g]))())return b.messages[g]},exclusion:function(a,b){if((message=this.presence(a,b))&&b.allow_blank==1)return;if(message)return message;if(b["in"]){for(var c=0;c<b["in"].length;c++)if(b["in"][c]==a.val())return b.message}else if(b.range){var d=b.range[0],e=b.range[1];if(a.val()>=d&&a.val()<=e)return b.message}},inclusion:function(a,b){if((message=this.presence(a,b))&&b.allow_blank==1)return;if(message)return message;if(b["in"]){for(var c=0;c<b["in"].length;c++)if(b["in"][c]==a.val())return;return b.message}if(b.range){var d=b.range[0],e=b.range[1];if(a.val()>=d&&a.val()<=e)return;return b.message}},confirmation:function(a,b){if(a.val()!=jQuery("#"+a.attr("id")+"_confirmation").val())return b.message}},remote:{uniqueness:function(a,b){var c={};c.case_sensitive=!!b.case_sensitive,b.id&&(c.id=b.id);if(b.scope){c.scope={};for(key in b.scope){var d=jQuery('[name="'+a.attr("name").replace(/\[\w+]$/,"["+key+"]"+'"]'));d[0]&&d.val()!=b.scope[key]?(c.scope[key]=d.val(),d.unbind("change."+a.id).bind("change."+a.id,function(){a.trigger("change"),a.trigger("focusout")})):c.scope[key]=b.scope[key]}}if(/_attributes]/.test(a.attr("name"))){var e=a.attr("name").match(/\[\w+_attributes]/g).pop().match(/\[(\w+)_attributes]/).pop();e+=/(\[\w+])$/.exec(a.attr("name"))[1]}else var e=a.attr("name");c[e]=a.val();if(jQuery.ajax({url:"/validators/uniqueness.json",data:c,async:false}).status==200)return b.message}}},formBuilders:{"ActionView::Helpers::FormBuilder":{add:function(a,b,c){if(a.data("valid")!==!1){var d=jQuery(b.input_tag),e=jQuery(b.label_tag),f=jQuery('label[for="'+a.attr("id")+'"]:not(.message)');a.attr("autofocus")&&a.attr("autofocus",!1),a.before(d),d.find("span#input_tag").replaceWith(a),d.find("label.message").attr("for",a.attr("id")),e.find("label.message").attr("for",a.attr("id")),f.replaceWith(e),e.find("label#label_tag").replaceWith(f)}jQuery('label.message[for="'+a.attr("id")+'"]').text(c)},remove:function(a,b){var c=jQuery(b.input_tag).attr("class"),d=a.closest("."+c),e=jQuery('label[for="'+a.attr("id")+'"]:not(.message)'),f=e.closest("."+c);d[0]&&(d.find("#"+a.attr("id")).detach(),d.replaceWith(a),e.detach(),f.replaceWith(e))}},"SimpleForm::FormBuilder":{add:function(a,b,c){if(a.data("valid")!==!1){var d=a.closest(b.wrapper_tag);d.addClass(b.wrapper_error_class);var e=$("<"+b.error_tag+' class="'+b.error_class+'">'+c+"</"+b.error_tag+">");d.append(e)}else a.parent().find(b.error_tag+"."+b.error_class).text(c)},remove:function(a,b){var c=a.closest(b.wrapper_tag+"."+b.wrapper_error_class);c.removeClass(b.wrapper_error_class);var d=c.find(b.error_tag+"."+b.error_class);d.remove()}},"Formtastic::FormBuilder":{add:function(a,b,c){if(a.data("valid")!==!1){var d=a.closest("li");d.addClass("error");var e=$('<p class="'+b.inline_error_class+'">'+c+"</p>");d.append(e)}else a.parent().find("p."+b.inline_error_class).text(c)},remove:function(a,b){var c=a.closest("li.error");c.removeClass("error");var d=c.find("p."+b.inline_error_class);d.remove()}}},callbacks:{element:{after:function(a,b){},before:function(a,b){},fail:function(a,b,c,d){c()},pass:function(a,b,c){b()}},form:{after:function(a,b){},before:function(a,b){},fail:function(a,b){},pass:function(a,b){}}}}