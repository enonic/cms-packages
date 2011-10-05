
var images = new Array();
var currentBackgroundImage = 0;
var toggle = true;
var first = true;
var imageUrl = "";
var imageId = "";
var backgroundSlideshow = 0;
var cssTransitionsAvailable = false;

function runSlideshow(imageArray){
    images = imageArray;
    cssTransitionsAvailable = $('html').hasClass('csstransitions');
    if (cssTransitionsAvailable){
        /*sweet CSS3 animation*/
        slideshowTransitions();
    }else{
        /*CPU intensive animation*/
        slideshowAnimation();
    }

}

function slideshowTransitions(){
    if (images.length == 0){
        /*alert("No images defined for slideshow, you must pass inn a javascript array of valid image-urls");*/
    }else{
        if (toggle){
            imageUrl = images[currentBackgroundImage];
            imageId = imageUrl.substring(imageUrl.lastIndexOf('=')+1);

            if (currentBackgroundImage==images.length-1){
                currentBackgroundImage = 0;
            }else{
                currentBackgroundImage++;
            }
            if(first){
                $('#background1').css("background-image",'url('+imageUrl+')');
                $('#background1').toggleClass("transparent");
                $("#"+imageId).removeClass("transparent");
                toggle=false;
                first=false;
            }else{
                $('#background2').css("background-image",'url('+imageUrl+')');
                $('#background2').toggleClass("transparent");
                $("#"+imageId).removeClass("transparent");
                toggle = false;
                first=true;
            }
            backgroundSlideshow = setTimeout(slideshowTransitions, 8000);
        }else{
            if (images.length>1){
                if (first){
                 $('#background2').toggleClass("transparent");
                 $("#"+imageId).addClass("transparent");
                }else{
                 $('#background1').toggleClass("transparent");
                 $("#"+imageId).addClass("transparent");
                }
                toggle = true;
                backgroundSlideshow = setTimeout(slideshowTransitions, 0);
            }
        }
    }
}
function slideshowAnimation(){
    if (images.length == 0){
        /*alert("No images defined for slideshow, you must pass inn a javascript array of valid image-urls");*/
    }else{
        if (toggle){
            imageUrl = images[currentBackgroundImage];
            imageId = imageUrl.substring(imageUrl.lastIndexOf('=')+1);
            if (currentBackgroundImage==images.length-1){
                currentBackgroundImage = 0;
            }else{
                currentBackgroundImage++;
            }
            if(first){
                $('#background1').css("background-image",'url('+imageUrl+')');
                $('#background1').css({opacity:0}).animate({opacity:1},5000);
                $("#"+imageId).removeClass("transparent");
                toggle=false;
                first=false;
            }else{
                $('#background2').css("background-image",'url('+imageUrl+')');
                $('#background2').css({opacity:0}).animate({opacity:1},5000);
                $("#"+imageId).removeClass("transparent");
                toggle = false;
                first=true;
            }
            backgroundSlideshow = setTimeout(slideshowAnimation, 10000);
        }else{
            if (images.length>1){
                if (first){
                    $('#background2').css({opacity:1}).animate({opacity:0},5000);
                    $("#"+imageId).addClass("transparent");
                }else{
                    $('#background1').css({opacity:1}).animate({opacity:0},10000);
                    $("#"+imageId).addClass("transparent");
                }
                toggle = true;
                backgroundSlideshow = setTimeout(slideshowAnimation, 0);
            }
        }
    }
}


