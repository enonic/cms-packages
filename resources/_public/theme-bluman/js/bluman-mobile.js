/* Menu toggling */
$(function() {
    $('header .toggle.menu').click(function() {
        $('.mobile-navigation').slideToggle();
    });
    $('header .toggle.search').click(function() {
        $('#west').slideToggle();
    });
    $('#toggle-search').click(function() {
        $('#bluman-form').slideToggle();
    });
    $('.expand').click(function() {
        $(this).next('ul').slideToggle();
        $(this).toggleClass('reverse');
    });
}); 

/* Swipe functionality for images*/
$(function() {
    var bullets = $('#slider .position em');
    var swipe = new Swipe(document.getElementById('slider'), {
        callback: function(e, pos) {
            bullets.removeClass('on');
            bullets[pos].className = 'on';
        }
    });
});