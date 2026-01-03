import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;


//! Layout: Horizontal Row (Linear)
class PiechartTimeHorizontalLayout extends PiechartTimeLayout {

    function initialize() {
        PiechartTimeLayout.initialize();
    }

    function apply(hours, minutes, seconds, showSeconds) {

        var settings = System.getDeviceSettings();
        var screenWidth = settings.screenWidth;
        var centerY = settings.screenHeight / 2;

        var count = showSeconds ? 3 : 2;
        var itemSpace = screenWidth / count;
        // Padding calculation
        var radius = (0.9 * (itemSpace / 2)).toNumber(); 
        var outlineThickness = 5;

        // Position 1: Hours
        hours.withCenter(itemSpace / 2, centerY)
             .withRadius(radius)
             .withOutlineThickness(outlineThickness);

        // Position 2: Minutes
        minutes.withCenter(itemSpace / 2 + itemSpace, centerY)
               .withRadius(radius)
               .withOutlineThickness(outlineThickness);
        
        // Position 3: Seconds
        if (showSeconds) {
            seconds.withCenter(itemSpace / 2 + (itemSpace * 2), centerY)
                   .withRadius(radius)
                   .withOutlineThickness(outlineThickness);
        }
    }
}