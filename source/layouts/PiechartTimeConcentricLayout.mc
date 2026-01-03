import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;


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
