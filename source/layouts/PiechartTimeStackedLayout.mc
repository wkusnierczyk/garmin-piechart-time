import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;


//! Layout: Side Stack (Hours Left, Minutes/Seconds Right)
class PiechartTimeStackedLayout extends PiechartTimeLayout {

    function initialize() {
        PiechartTimeLayout.initialize();
    }

    function apply(hours, minutes, seconds, showSeconds) {

        var settings = System.getDeviceSettings();
        var screenWidth = settings.screenWidth;
        var screenHeight = settings.screenHeight;
        var centerY = settings.screenHeight / 2;

        // --- 1. Proportional Constants ---
        
        // Define Gap as ~2% of screen height (scales with screen size)
        var gap = (screenHeight * 0.02).toNumber(); 
        if (gap < 1) { gap = 1; }

        // --- 2. Geometry Setup ---
        
        // Centers: 37% (Left) and 71% (Right)
        var hoursX = (screenWidth * 0.37).toNumber();
        var stackX = (screenWidth * 0.71).toNumber();
        
        // Hours Radius: 22% of Screen Height
        var spaceY = 0.22;
        var hoursRadius = (screenHeight * spaceY).toNumber();
        var hoursTop = centerY - hoursRadius;
        var hoursBottom = centerY + hoursRadius;
        var totalHeight = hoursRadius * 2;
        
        // Hours Outline: ~10% of its radius
        var hoursThickness = (hoursRadius * 0.10).toNumber();
        if (hoursThickness < 1) { hoursThickness = 1; }

        hours.withCenter(hoursX, centerY)
             .withRadius(hoursRadius)
             .withOutlineThickness(hoursThickness);

        // --- 3. Calculate Stack Geometry ---
        
        // The stack fits exactly into the Hours height, minus the proportional gap
        var availableStackHeight = totalHeight - gap;
        
        // Distribute height: Minutes get 58%, Seconds get 42%
        var minutesDiameter = availableStackHeight * 0.58;
        var secondsDiameter = availableStackHeight * 0.42;
        
        var minutesRadius = (minutesDiameter / 2).toNumber();
        var secondsRadius = (secondsDiameter / 2).toNumber();

        // Calculate proportional thickness for stack items (~12% for readability on smaller circles)
        var minutesThickness = (minutesRadius * 0.12).toNumber();
        if (minutesThickness < 1) { minutesThickness = 1; }
        
        var secondsThickness = (secondsRadius * 0.12).toNumber();
        if (secondsThickness < 1) { secondsThickness = 1; }

        // --- 4. Vertical Positioning ---
        
        // Align Top of Minutes with Top of Hours
        var minutesY = hoursTop + minutesRadius;
        
        // Align Bottom of Seconds with Bottom of Hours
        var secondsY = hoursBottom - secondsRadius;
        
        // --- 5. Horizontal Positioning (Left Align Stack) ---
        
        // Base position for minutes is the stack column
        var minutesX = stackX;
        var minutesLeftEdge = minutesX - minutesRadius;
        
        // Calculate seconds X so its left edge matches the minutes left edge
        var secondsX = minutesLeftEdge + secondsRadius;

        minutes.withCenter(minutesX, minutesY)
               .withRadius(minutesRadius)
               .withOutlineThickness(minutesThickness);

        if (showSeconds) {
            seconds.withCenter(secondsX, secondsY)
                   .withRadius(secondsRadius)
                   .withOutlineThickness(secondsThickness);
        }
    }
}
