({
	doProductPreview : function(component, event, helper) {
        
        // These javascript functions require that Jquery is included before this.
        var frameNum = 2;			// Used to indicate which frame of a group of pictures should be used
        var maxFrames = 8;			// Total number of frames in a set of pictures Can be made higher or lower depending on the pictures used
        var thresholdForDrag = 20; 	// How much the cursor's x position needs to move to change the frame number
        
        var productName = component.get("v.mainProduct").Name;
        productName = productName.split(' ').join('_');
        
        // Path to folder that has images, needs to be changed to whatever the path actually is
        var pathToImages = component.get("v.CommunityURLFor360View") + "/resource/KCPQ_ProductPreview_" + productName + "/images"; 
        
        var colorNamesLst = component.get("v.colorNames");
        var prodFolderName = 'car_black';
        if(colorNamesLst.length > 0){
            prodFolderName = component.get("v.colorNames")[0];
        }
        
        var folder = productName + "/car_" + prodFolderName; // Folder name for groups of images, in this case it changes based on the color of the car chosen
        var imageNameSuffix = "-large.jpg";	// Part of shared name for all the images
        var dragging = false;				// Boolean to determine if the user is currently holding 
        var anchorPos;						// Position to compare with where the mouse is currently, to determine if there needs to be a frame change
        
        $("document").ready(function(){
            //var productName = component.get("v.mainProduct").Name;
            //productName = productName.split(' ').join('_');
            preload(folder);	
            updatePicture($(".productPreview"));
        });
        
        /**
		When a user clicks on one of the color buttons, try to preload the images of that group 
        and change the folder to be that set of images
		*/
        $(".productTypeButton").click(function(){
            folder = productName + "/" + $(this).data("folder");
            preload(folder);
            updatePicture($(".productPreview"));
        });
        
        /**
		When a user starts to press left click on the preview, this gets called
		The user is starting their drag in this method
		*/
        $(".productPreview").mousedown(function(event){
            $(this).css("cursor","ew-resize");
            dragging = true;
            anchorPos = event.pageX;
        });
        
        /**
		Check if the mouse is dragging, then check if current x position of the mouse is past the threshold
		If it is pass the threshold in either direction, then update the frame number to correspond to that.
		*/
        $(".productPreview").mousemove(function(event){
            if(dragging){
                var cursorX = event.pageX;
                if((cursorX - anchorPos) > thresholdForDrag || (cursorX - anchorPos) < -1 * thresholdForDrag ){
                    if((cursorX - anchorPos) > 0){
                        frameNum++;
                        if( frameNum > maxFrames){
                            frameNum = 1;
                        }				
                    }else{
                        frameNum--;
                        if( frameNum < 1){
                            frameNum = maxFrames;
                        }				
                    }
                    anchorPos = cursorX;
                    updatePicture($(this));
                }
            }
        });
        
        /**
		If the left mouse button is brought up or if the mouse leaves the product preview, 
        then the user is no longer dragging
		*/
        $(".productPreview").mouseup(function(){
            $(this).css("cursor","auto");
            dragging=false;
        });
        
        $(".productPreview").mouseleave(function(){
            $(this).css("cursor","auto");
            dragging=false;
        });
        
        /**
		Build the url used to get each specific image, then set it onto the preview.
		*/
        function updatePicture($productPreview){
            // need to make sure this built URL is correct for project
            var url = pathToImages + "/" + folder + "/" + frameNum + imageNameSuffix;
            $productPreview.css("background","url('" + url + "')  no-repeat center center"); 
            $productPreview.css("background-size","100%"); 	
        }
        
        /**
		This function is supposed to preload images to prevent flickering, 
        though not fully working right now
		*/
        function preload(folderVar){
            var $imageBuffer = $('.bufferContainer');
            $imageBuffer.empty();
            var images = [];
            for (var i = 1; i <= maxFrames; ++i) {
                var img = new Image();
                var url = pathToImages + "/" + folderVar + "/" + i + imageNameSuffix;
                img.src = url;
                $imageBuffer.append(img).css("background","url('" + url + "')  no-repeat center center"); ;
            }
        }
        
	},
})