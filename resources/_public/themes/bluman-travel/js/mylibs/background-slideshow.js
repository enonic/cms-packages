$(document).ready(function() {
    var imageCounter = 0;
    var intID = setInterval(changeImg, 5000);
    var noOfBgImages = $('.bg').length;

    $(window).resize(function() {
        calculateImageSize();
    });

    function changeImg(){
        if (noOfBgImages>1){
            imageCounter++;
            if ($('#bg'+imageCounter).length == 0) {imageCounter = 1;}
            $('.bg').css({visibility:"hidden"});
            $('#bg'+imageCounter).css({opacity: 0.0, visibility: "visible"}).animate({opacity: 1.0}, 2000);
            calculateImageSize();
        }
    }

    function calculateImageSize(){
        var ww = $(window).width();
        var wh = $(window).height();
        var ih =$('#bg'+imageCounter).height();
        var iw =$('#bg'+imageCounter).width();
        if (ww > 1200){
                if ($('.bg').hasClass('bg-tall')){
                    $('.bg').addClass('bg-wide');
                    $('.bg').removeClass('bg-tall');
                }
        }if (ww > iw){
                if ($('.bg').hasClass('bg-tall')){
                    $('.bg').addClass('bg-wide');
                    $('.bg').removeClass('bg-tall');
                }
        }
        if (wh > ih){
            $('.bg').addClass('bg-tall');
            $('.bg').removeClass('bg-wide');
        }
    }
});