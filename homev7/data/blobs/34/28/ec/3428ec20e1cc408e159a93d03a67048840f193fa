if (!cms) var cms = {}
if (!cms.confluence) cms.confluence = {}
if (!cms.util) cms.util = {}
if (!cms.confluence) cms.confluence = {}

cms.util = {
	addLoadEvent: function (fn) 
	{
		var oldonload = window.onload;
		if ( typeof window.onload != "function" )
      		window.onload = fn;
      	else
      		window.onload = function() 
			{
      			oldonload();
      			fn();
      		}
	}
};

cms.confluence = {
	resizeImages: function( maxWidth )
	{
		var confluenceDoc = document.getElementById('ConfluenceContent');
		var images = confluenceDoc.getElementsByTagName('img');
		var imagesLn = images.length;
		var image;
		for ( var i = 0; i < imagesLn; i ++)
		{
			image = images[i];
			image.originalWidth = image.width;
			image.originalHeight = image.height;
			if ( image.width > maxWidth )
			{
				image.setAttribute('width', '100%');
			}
		}
	}
};