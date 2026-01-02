import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;

//! Abstract Base Strategy for Piechart layouts
class PiechartTimeLayout {
    
    //! Applies the layout logic to the provided charts.
    //! @param hours [Piechart]
    //! @param minutes [Piechart]
    //! @param seconds [Piechart]
    //! @param showSeconds [Boolean] Whether seconds are enabled
    function apply(hours, minutes, seconds, showSeconds) {
        // To be overridden by subclasses
    }

    //! Provides a list of instances of available specialized layouts.
    //! @return [Array<PiechartTimeLayout>] List of instantiated available layouts.
    static function getLayouts() as Array<PiechartTimeLayout> {
        return [
            new PiechartTimeConcentricLayout(),
            new PiechartTimeHorizontalLayout(),
            new PiechartTimeStackedLayout()
        ];
    }
}

//! Layout: Three concentric rings (Seconds outer, Hours inner)
class PiechartTimeConcentricLayout extends PiechartTimeLayout {
    
    private const EXPANSION_FACTOR = 0.6;

    function initialize() {
        PiechartTimeLayout.initialize();
    }

    function apply(hours, minutes, seconds, showSeconds) {
        
        var settings = System.getDeviceSettings();
        var centerX = settings.screenWidth / 2;
        var centerY = settings.screenHeight / 2;
        
        // Calculate max radius based on smallest screen dimension
        var limit = (centerX < centerY) ? centerX : centerY;
        var maxRadius = (limit * EXPANSION_FACTOR).toNumber();
        var thickness = (maxRadius / 3.5).toNumber();
        var outlineThickness = 5;

        // 1. Seconds (Outer Ring)
        seconds.withCenter(centerX, centerY)
               .withRadius(maxRadius)
               .withOutlineThickness(outlineThickness);

        // 2. Minutes (Middle Ring)
        minutes.withCenter(centerX, centerY)
               .withRadius(maxRadius - thickness)
               .withOutlineThickness(outlineThickness);

        // 3. Hours (Inner Ring)
        hours.withCenter(centerX, centerY)
               .withRadius(maxRadius - (thickness * 2))
               .withOutlineThickness(outlineThickness);
    }
}

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
        
        // Centers: 33% (Left) and 67% (Right)
        var hoursX = (screenWidth * 0.33).toNumber();
        var stackX = (screenWidth * 0.67).toNumber();
        
        // Hours Radius: 22% of Screen Height
        var hoursRadius = (screenHeight * 0.22).toNumber();
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
        // secondsLeft = minutesLeft
        // secondsX - secondsRadius = minutesX - minutesRadius
        // secondsX = minutesX - minutesRadius + secondsRadius
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