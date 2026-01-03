import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;


//! Layout: Horizontal with diminishing sizes (Hours > Minutes > Seconds)
class PiechartTimeDiminishingLayout extends PiechartTimeLayout {

    // --- Experimentation Constants ---
    // Change these to tweak sizes
    private const RATIO_MINUTES = 2.0 / 3.0; // Minutes is 2/3 of Hours
    private const RATIO_SECONDS = 2.0 / 3.0; // Seconds is 2/3 of Minutes
    
    // Gap between charts (as a fraction of screen width)
    private const GAP_FRACTION = 0.02;

    function initialize() {
        PiechartTimeLayout.initialize();
    }

    function apply(hours, minutes, seconds, showSeconds) {

        var settings = System.getDeviceSettings();
        var screenWidth = settings.screenWidth;
        var centerY = settings.screenHeight / 2;

        // 1. Determine constraints
        // We leave 5% margin on left and right (90% usable width)
        var usableWidth = screenWidth * 0.9;
        
        var gap = (screenWidth * GAP_FRACTION).toNumber();
        if (gap < 1) { gap = 1; }

        // 2. Solve for "Base Unit" (Hours Diameter)
        // Equation: Width = D_h + Gap + D_m + Gap + D_s
        // Width = D_h + Gap + (D_h * Rm) + Gap + (D_h * Rm * Rs)
        // Width - Gaps = D_h * (1 + Rm + Rm*Rs)
        
        var gapsCount = showSeconds ? 2 : 1;
        var totalGapWidth = gap * gapsCount;
        var availableForCharts = usableWidth - totalGapWidth;

        // Sum of ratios
        var ratioSum = 1.0 + RATIO_MINUTES;
        if (showSeconds) {
            ratioSum += (RATIO_MINUTES * RATIO_SECONDS);
        }

        var hoursDiameter = availableForCharts / ratioSum;

        // 3. Calculate Radii
        var rHour = (hoursDiameter / 2).toNumber();
        var rMin  = (rHour * RATIO_MINUTES).toNumber();
        var rSec  = (rMin * RATIO_SECONDS).toNumber();

        // 4. Calculate Centers (Centering the entire group horizontally)
        
        // Actual width used (re-calculated with integer radii to be precise)
        var totalUsedWidth = (rHour * 2) + gap + (rMin * 2);
        if (showSeconds) {
            totalUsedWidth += gap + (rSec * 2);
        }

        // Start X position (Left edge of the group)
        var currentX = (screenWidth - totalUsedWidth) / 2;

        // --- Apply Hours ---
        // Center = LeftEdge + Radius
        var hX = currentX + rHour;
        hours.withCenter(hX, centerY)
             .withRadius(rHour)
             .withOutlineThickness(scaleThickness(rHour));
        
        // Move cursor: Past Hour + Gap
        currentX += (rHour * 2) + gap;

        // --- Apply Minutes ---
        var mX = currentX + rMin;
        minutes.withCenter(mX, centerY)
               .withRadius(rMin)
               .withOutlineThickness(scaleThickness(rMin));

        // Move cursor: Past Minute + Gap
        currentX += (rMin * 2) + gap;

        // --- Apply Seconds ---
        if (showSeconds) {
            var sX = currentX + rSec;
            seconds.withCenter(sX, centerY)
                   .withRadius(rSec)
                   .withOutlineThickness(scaleThickness(rSec));
        }
    }

    // Helper to scale outline thickness based on chart size (10% of radius)
    private function scaleThickness(radius) {
        var t = (radius * 0.1).toNumber();
        return (t < 1) ? 1 : t;
    }
}