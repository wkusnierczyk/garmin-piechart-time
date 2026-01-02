import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;
import Toybox.Time;
import Toybox.Time.Gregorian;

//! A High-Level component that manages multiple Piecharts to display Time.
class PiechartTime {

    // --- Layout Enum ---
    enum Layout {
        //! Three concentric rings (Seconds outer/largest, Hours inner/smallest).
        LAYOUT_CONCENTRIC,
        //! Three small charts arranged horizontally.
        LAYOUT_HORIZONTAL
    }

    const WITH_SECONDS_DEFAULT = false;
    
    const CONCENTRIC_LAYOUT_EXPANSE = 0.8;

    // --- Default Color Constants ---
    static const DEFAULT_HOUR_OUTLINE_COLOR = Graphics.COLOR_RED;
    static const DEFAULT_MINUTES_OUTLINE_COLOR = Graphics.COLOR_GREEN;
    static const DEFAULT_SECONDS_OUTLINE_COLOR = Graphics.COLOR_BLUE;

    static const DEFAULT_HOUR_SLICE_COLOR = Graphics.COLOR_DK_GRAY;
    static const DEFAULT_MINUTES_SLICE_COLOR = Graphics.COLOR_DK_GRAY;
    static const DEFAULT_SECONDS_SLICE_COLOR = Graphics.COLOR_DK_GRAY;

    // --- Configuration ---
    private var _showSeconds = WITH_SECONDS_DEFAULT;
    private var _layout = LAYOUT_CONCENTRIC;
    private var _screenCenter as Array;

    // --- Child Components ---
    private var _hourChart;
    private var _minutesChart;
    private var _secondsChart;

    //! Constructor.
    function initialize() {
        // Create the children with safe defaults
        _hourChart = new Piechart()
                            .withSliceColor(DEFAULT_HOUR_SLICE_COLOR)
                            .withOutlineColor(DEFAULT_HOUR_OUTLINE_COLOR);
        _minutesChart = new Piechart()
                            .withSliceColor(DEFAULT_MINUTES_SLICE_COLOR)
                            .withOutlineColor(DEFAULT_MINUTES_OUTLINE_COLOR);
        _secondsChart = new Piechart()
                            .withSliceColor(DEFAULT_SECONDS_SLICE_COLOR)
                            .withOutlineColor(DEFAULT_SECONDS_OUTLINE_COLOR);

        // Grab screen center once
        var settings = System.getDeviceSettings();
        _screenCenter = [settings.screenWidth / 2, settings.screenHeight / 2] as Array;
    }

    // --- Fluent API ---

    //! Enable seconds display
    //! @return [PiechartTime] self
    function withSeconds() as PiechartTime {
        _showSeconds = true;
        return self;
    }

    //! Disable seconds display
    //! @return [PiechartTime] self
    function withoutSeconds() as PiechartTime {
        _showSeconds = false;
        return self;
    }

    //! Select the visual layout strategy
    //! @param layout [PiechartTime.Layout]
    //! @return [PiechartTime] self
    function withLayout(layout as Layout) as PiechartTime {
        _layout = layout;
        return self;
    }

    //! Apply a full color theme to all charts
    //! @param colorTheme [ColorTheme] The theme data object
    //! @return [PiechartTime] self
    function withColorTheme(colorTheme as ColorTheme) as PiechartTime {
        _hourChart
            .withSliceColor(colorTheme.hourSlice)
            .withOutlineColor(colorTheme.hourOutline)
            .withUnfilledColor(colorTheme.hourUnfilled); // New
            
        _minutesChart
            .withSliceColor(colorTheme.minutesSlice)
            .withOutlineColor(colorTheme.minutesOutline)
            .withUnfilledColor(colorTheme.minutesUnfilled); // New
            
        _secondsChart
            .withSliceColor(colorTheme.secondsSlice)
            .withOutlineColor(colorTheme.secondsOutline)
            .withUnfilledColor(colorTheme.secondsUnfilled); // New
            
        return self;
    }

    // --- Main Logic ---

    //! Updates state and draws components to the screen
    //! @param dc [Graphics.Dc] Device Context
    function draw(dc) {
        // 1. Get Time
        var clock = System.getClockTime();
        
        // 2. Update Data (The "What")
        _hourChart.withTurn(12).withValue(clock.hour % 12); // Simple 12h clock
        _minutesChart.withTurn(60).withValue(clock.min);
        _secondsChart.withTurn(60).withValue(clock.sec);

        // 3. Apply Layout (The "Where")
        if (_layout == LAYOUT_CONCENTRIC) {
            applyConcentricLayout(dc);
        } else if (_layout == LAYOUT_HORIZONTAL) {
            applyHorizontalLayout(dc);
        }

        // 4. Draw Enabled Charts (PAINTER'S ALGORITHM)
        // We draw from Back (Largest) to Front (Smallest)
        
        // Layer 1 (Bottom): Seconds (Largest)
        if (_showSeconds) {
            _secondsChart.draw(dc);
        }
        
        // Layer 2 (Middle): Minutes
        _minutesChart.draw(dc);
        
        // Layer 3 (Top): Hours (Smallest)
        _hourChart.draw(dc);
    }

    // --- Layout Strategies ---

    //! Layout: Stacked Concentric Discs
    //! Seconds = Largest (Back), Hours = Smallest (Front)
    private function applyConcentricLayout(dc) {
        var centerX = _screenCenter[0];
        var centerY = _screenCenter[1];
        
        var maxRadius = (CONCENTRIC_LAYOUT_EXPANSE * (centerX < centerY ? centerX : centerY)).toNumber();
        // Divide space roughly into rings
        var thickness = maxRadius / 4; 
        
        // 1. Seconds (Largest / Back)
        _secondsChart
            .withCenter(centerX, centerY)
            .withRadius(maxRadius)
            .withOutlineThickness(2);

        // 2. Minutes (Middle)
        _minutesChart
            .withCenter(centerX, centerY)
            .withRadius(maxRadius - thickness)
            .withOutlineThickness(2);

        // 3. Hours (Smallest / Front)
        _hourChart
            .withCenter(centerX, centerY)
            .withRadius(maxRadius - (thickness * 2))
            .withOutlineThickness(2);
    }

    //! Layout: Horizontal Row (Hours - Mins - Secs)
    private function applyHorizontalLayout(dc) {
        var cy = _screenCenter[1];
        var screenW = _screenCenter[0] * 2;
        
        // Calculate item width
        var count = _showSeconds ? 3 : 2;
        var itemSpace = screenW / count;
        var radius = (itemSpace / 2) - 5; // Padding

        // Position 1: Hours
        _hourChart
            .withCenter(itemSpace / 2, cy)
            .withRadius(radius)
            .withOutlineThickness(3);

        // Position 2: Minutes
        _minutesChart
            .withCenter(itemSpace / 2 + itemSpace, cy)
            .withRadius(radius)
            .withOutlineThickness(3);

        // Position 3: Seconds
        if (_showSeconds) {
            _secondsChart
                .withCenter(itemSpace / 2 + (itemSpace * 2), cy)
                .withRadius(radius)
                .withOutlineThickness(3);
        }
    }
}