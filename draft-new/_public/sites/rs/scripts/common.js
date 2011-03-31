$(function() {

    // Strict fix for target = _blank
    $('a[rel$="external"]').live("click", function(){
        var newWindow = window.open(this.href, '_blank');
        newWindow.focus();
        return false;
    });
    
    // Accessibility contrast
    if ($.cookie('high_contrast')) $('body').addClass('contrast');
    $('#contrast').click(function(event){
        event.preventDefault();
        if ($.cookie('high_contrast')) {
            $('body').removeClass('contrast');
            $.cookie('high_contrast', null, {path: '/'});
        } else {
            $('body').addClass('contrast');
            $.cookie('high_contrast', 'true', {path: '/'});
        }
    });
    
    // Accessibility text size
    if ($.cookie('text_size')) $('body').addClass('text-size-' + $.cookie('text_size'));
    $('#text-size > a').click(function(event){
        event.preventDefault();
        if ($(this).hasClass('large-text') || ($(this).hasClass('change-text-size') && !$('body').hasClass('text-size-large') && !$('body').hasClass('text-size-largest'))) {
            $('body').removeClass('text-size-largest').addClass('text-size-large');
            $.cookie('text_size', 'large', {path: '/'});
        } else if ($(this).hasClass('largest-text') || ($(this).hasClass('change-text-size') && $('body').hasClass('text-size-large'))) {
            $('body').removeClass('text-size-large').addClass('text-size-largest');
            $.cookie('text_size', 'largest', {path: '/'});
        } else {
            $('body').removeClass('text-size-large').removeClass('text-size-largest');
            $.cookie('text_size', null, {path: '/'});
        }
    });
    
    // Adds required * to all required form elements
    $('.required').not('span').each(function () {
        $('label[for = '+this.id+']').not('.radio').append('<span class="required">*</span>');
    });
 

});

// Reloads captcha image
function reloadCaptcha(imageId) {
    var src = document.getElementById(imageId).src;
    document.getElementById(imageId).src = src.split('?')[0] + '?' + (new Date()).getTime();
}
