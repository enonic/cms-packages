/**
 * jQuery Enonic Tree Plugin
 *
 * Copyright (c) 2011 -> ENONIC AS
 *
 */

(function($) {
	$.fn.enonicTree = function() {
		var tree = this;		
		
		// adds branch buttons for expanding/contracting submenu
		tree.find('li.parent').each(function() {
			var branchButton = $(document.createElement('a')).addClass('branch-button').attr('href', '#');
			$(this).prepend(branchButton);
		
		});
		
		// bind branch button click event
		tree.find('.branch-button').live('click', function() {
			$(this).nextAll('ul').each(function() {
				if ($(this).is(':visible')) {
					$(this).parent().addClass('contracted').removeClass('expanded');
				}
				else {
					$(this).parent().addClass('expanded').removeClass('contracted');
				}
				$(this).slideToggle();
			});
		});
		
		// bind click event for expanding/contracting entire menu
		tree.find('a.show-menu').live('click', function() {
			$(this).toggleClass('expand contract').nextAll('ul').slideToggle();
		});
		

	};
})(jQuery);