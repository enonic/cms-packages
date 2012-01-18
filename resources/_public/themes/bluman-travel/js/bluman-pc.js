$(function() {
    /* Remember blueman-form state */
    if ($.cookie('bluman-form') != 'hidden') {
        $('#bluman-form').show();
        $('.collapse-search').addClass('collapse');
    }
    /* Remember slideshow-description state */
    if ($.cookie('ss-desc') == 'hidden') {
        $('.slideshow-description').css('right', '-353px');
        $('.collapse-ss-description').addClass('show');
    }
    
    $('#hide-form').click(function() {
        if ($('#bluman-form').is(':visible')) {
            $.cookie('bluman-form', 'hidden');
        } else {
            $.cookie('bluman-form', '');
        };
        $('#bluman-form').slideToggle();
        $(this).parent().toggleClass('collapse');
    });
    
    $('.collapse-ss-description').click(function() {
        var offset;
        if ($(this).parent().css('right') == '0px') {
            offset = "-" + $(this).next('ul').outerWidth(true) + "px";
            $.cookie('ss-desc', 'hidden');
        } else {
            offset = 0;
            $.cookie('ss-desc', '');
        }
        $(this).toggleClass('show');
        $(this).parent().animate({right: offset});
    });
});