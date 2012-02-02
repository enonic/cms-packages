/* Display/hide stuff */
$(function () {
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
    
    /* Hide/show search form */
    $('#hide-form').live('click', function () {
        if ($('#bluman-form').is(':visible')) {
            $.cookie('bluman-form', 'hidden');
        } else {
            $.cookie('bluman-form', '');
        };
        $('#bluman-form').slideToggle();
        $(this).parent().toggleClass('collapse');
    });
    
    /* Hide/show background-description */
    $('.collapse-ss-description').click(function () {
        var offset;
        if ($(this).parent().css('right') == '0px') {
            offset = "-" + $(this).next('ul').outerWidth(true) + "px";
            $.cookie('ss-desc', 'hidden');
        } else {
            offset = 0;
            $.cookie('ss-desc', '');
        }
        $(this).toggleClass('show');
        $(this).parent().animate({
            right: offset, avoidTransforms: true
        });
    });
});

/* Background slideshow */
$(function () {
    $('.slideshow img').each(function () {
        $(this).fullBg();
    });
    
    $('.slideshow').cycle({
        fx: 'fade',
        speed: 800,
        pager: '.slideshow-pager',
        timeout: 8000,
        pagerAnchorBuilder: function (idx, slide) {
            return '.slideshow-pager li:eq(' + idx + ') a';
        },
        after: function (curr, next, opt) {
            showDescription(next.getAttribute('data-imagekey'));
        }
    });
    
    function showDescription(imgKey) {
        $('.slideshow-description li').hide();
        $('.slideshow-description li[data-imagekey=' + imgKey + ']:first').show();
    }
});

/* Sharebar */
$(function () {
    $('.share-bar.vertical li').hoverIntent(function () {
        $(this).animate({
            width: "110px", marginLeft: "-110px", avoidTransforms: true
        },
        500, function () {
            $(this).css('overflow', 'visible');
        });
    },
    function () {
        $(this).css('overflow', 'hidden');
        $(this).animate({
            width: 0, marginLeft: 0, avoidTransforms: true
        },
        500);
    });
});

/* Improved selectboxes */
$(function() {
    $('#bluman-form select').chosen();
});

/* rebinds the search form after an ajax call*/
function rebindForm() {
    $('#bluman-form select').chosen();
    if ($.cookie('bluman-form') != 'hidden') {
        $('#bluman-form').show();
        $('.collapse-search').addClass('collapse');
    }
}

function getParamsAsCSV(str, name, delimiter) {
    var regex = new RegExp(name+'=', 'g');
    var str2 = str.replace(regex, '');
    
    return str2.split('&').join(delimiter);
}