jQuery.fn.reverse = function () {
    return this.pushStack(this.get().reverse(), arguments);
};

$(function () {
    $('.prevImage').click(function (event) {
        event.preventDefault();
        flowFeedImages($(this).closest('ul'), 'left');
    });
    
    $('.nextImage').click(function (event) {
        event.preventDefault();
        flowFeedImages($(this).closest('ul'), 'right');
    });
    
    $('.showList').click(function (event) {
        event.preventDefault();
        $(this).addClass('selected');
        $(this).siblings('.showSlideshow').removeClass('selected');
        $(this).siblings('.prevImage').hide();
        $(this).siblings('.nextImage').hide();
        $(this).parent().siblings('.feedInfo').hide();
        $(this).closest('ul').removeClass('slideshow').addClass('list');
    });
    
    $('.showSlideshow').click(function (event) {
        event.preventDefault();
        $(this).addClass('selected');
        $(this).siblings('.showList').removeClass('selected');
        if (! $(this).parent().siblings('.item:first').hasClass('current')) {
            $(this).siblings('.prevImage').show();
        } else {
            $(this).parent().siblings('.feedInfo').show();
        }
        
        if (! $(this).parent().siblings('.item:last').hasClass('current')) {
            $(this).siblings('.nextImage').show();
        }
        
        $(this).closest('ul').removeClass('list').addClass('slideshow');
    });
    
    $('.showMore').click(function (event) {
        event.preventDefault();
        feedList = $(this).closest('ul');
        showPage = Number($(this).attr('rel')) + 1;
        $(this).attr('rel', showPage);
        feedUrl = $(this).attr('href') + '%26page%3D' + showPage;
        loadFeedImages(feedList, feedUrl);
    });
});

function loadFeedImages(feedList, feedUrl) {
    
    $(feedList).find('li.system').toggleClass('loading').text('Loading...');
    
    $.get(feedUrl, function (data) {
        feedChannelData = $(data).find('channel:first');
        
        feedChannelDataTitle = $(feedChannelData).children('title:first').text();
        feedChannelDataLastUpdate = $(feedChannelData).children('pubDate:first').text();
        $(feedList).find('li.feedInfo').html(feedChannelDataTitle + '<br />Last updated: ' + feedChannelDataLastUpdate);
        
        var i = 0;
        
        $(data).find('item').each(function () {
            itemTitle = $(this).children('title:first').text();
            itemDescription = $(this).children('description:first').text();
            itemDate = $(this).children('pubDate:first').text();
            itemUrl = $(this).children('link:first').text();
            //itemId = 'feedItem_' + itemUrl.replace(/[^a-z0-9]/gi, '').substr(0, 100);
            itemId = 'feedItem_' + i;
            itemImageThumb = $(this).find('media\\:thumbnail:first').attr('url');
            itemImage = itemImageThumb.replace(/_t.jpg/i, '_m.jpg');
            
            if ($('li#' + itemId).length == 0) {
                
                altClass = (++ i % 2 == 0? 'alt1': 'alt2');
                
                listElement = $(document.createElement('li')).attr('id', itemId).addClass('item').addClass(altClass);
                
                if ($(feedList).find('li.item').size() == 0) {
                    listElement.addClass('current');
                }
                if ($(feedList).find('li.item:last').hasClass('current')) {
                    listElement.addClass('current1');
                    if ($(feedList).hasClass('slideshow')) {
                        $(feedList).find('.nextImage').show();
                    }
                }
                if ($(feedList).find('li.item:last').hasClass('current1')) {
                    listElement.addClass('current2');
                }
                
                listElementLink = $(document.createElement('a')).attr('href', itemUrl);
                listElementImageThumb = $(document.createElement('img')).attr('src', itemImageThumb).addClass('thumb');
                listElementLink.append(listElementImageThumb);
                listElementImage = $(document.createElement('img')).attr('src', itemImage).addClass('medium');
                listElementLink.append(listElementImage);
                listElement.append(listElementLink);
                
                listElementInfo = $(document.createElement('div')).addClass('info');
                
                listElementTitle = $(document.createElement('h3')).text(itemTitle);
                listElementInfo.append(listElementTitle);
                
                listElementDate = $(document.createElement('span')).text(itemDate);
                listElementInfo.append(listElementDate);
                
                listElement.append(listElementInfo);
                
                $(feedList).append(listElement);
            }
        });
        
        $(feedList).find('li.system').toggleClass('loading').text('');
    });
}

function flowFeedImages(feedList, direction) {
    var prevImage = $(feedList).find('.prevImage:first');
    var nextImage = $(feedList).find('.nextImage:first');
    var feedInfo = $(feedList).find('.feedInfo:first');
    var numOfItems = $(feedList).find('li.item').size();
    
    currentPosition = Number($(prevImage).attr('rel'));    
    
    if ((direction == 'left') && (currentPosition > 0)) {
        currentPosition = currentPosition - 1;
    } else if (currentPosition < (numOfItems - 1)) {
        currentPosition = currentPosition + 1;
    }
    
    $(prevImage).attr('rel', currentPosition);
    
    if (currentPosition == 0) {
        prevImage.hide();
        feedInfo.show();
    } else {
        prevImage.show();
        feedInfo.hide();
    }
    
    currentPosition == ($(feedList).find('li.item').size() - 1)? nextImage.hide(): nextImage.show();
    
    $(feedList).find('li.item:eq(' + (currentPosition - 2) + ')').addClass('current-2').removeClass('current-1');
    $(feedList).find('li.item:eq(' + (currentPosition - 1) + ')').addClass('current-1').removeClass('current').removeClass('current-2');
    $(feedList).find('li.item:eq(' + currentPosition + ')').addClass('current').removeClass('current-1').removeClass('current1');
    $(feedList).find('li.item:eq(' + (currentPosition + 1) + ')').addClass('current1').removeClass('current').removeClass('current2');
    $(feedList).find('li.item:eq(' + (currentPosition + 2) + ')').addClass('current2').removeClass('current1');
    
    $(feedList).find('li.item:lt(' + (currentPosition - 2) + ')').removeClass('current-2');
    $(feedList).find('li.item:gt(' + (currentPosition + 2) + ')').removeClass('current2');
}