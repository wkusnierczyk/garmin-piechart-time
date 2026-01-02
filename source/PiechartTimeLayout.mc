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
            new PiechartTimeLinearLayout(),
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
class PiechartTimeLinearLayout extends PiechartTimeLayout {

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
        var radius = (itemSpace / 2) - 5; 
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
        var screenHeight = settings.screenHeight;
        var centerX = settings.screenWidth / 2;
        var centerY = settings.screenHeight / 2;
        
        // 1. Hours (Left Side - Large)
        var hoursX = centerX / 2;
        var hoursRadius = (screenHeight * 0.22).toNumber();
        var outlineThickness = 5;

        hours.withCenter(hoursX, centerY)
             .withRadius(hoursRadius)
             .withOutlineThickness(outlineThickness);

        // 2. Minutes (Right Top)
        var stackX = centerX + (centerX / 2);
        // Shift UP by 10%
        var minutesY = (centerY - (screenHeight * 0.10)).toNumber();
        var minutesRadius = (screenHeight * 0.12).toNumber(); 

        minutes.withCenter(stackX, minutesY)
               .withRadius(minutesRadius)
               .withOutlineThickness(3);

        // 3. Seconds (Right Bottom)
        if (showSeconds) {
            // Shift DOWN by 10% (Symmetric)
            var secondsY = (centerY + (screenHeight * 0.10)).toNumber(); 
            var secondsRadius = (screenHeight * 0.08).toNumber();

            seconds.withCenter(stackX, secondsY)
                   .withRadius(secondsRadius)
                   .withOutlineThickness(2);
        }
    }
}