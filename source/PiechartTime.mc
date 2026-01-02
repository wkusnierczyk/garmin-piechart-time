import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;
import Toybox.Time;
import Toybox.Time.Gregorian;

//! A High-Level component that manages multiple Piecharts to display Time.
class PiechartTime {

    // --- Layout Enum ---
    enum Layout {
        //! Three concentric rings (Hours outer, Seconds inner).
        LAYOUT_CONCENTRIC,
        //! Three small charts arranged horizontally.
        LAYOUT_HORIZONTAL
    }

    const WITH_SECONDS_DEFAULT = false;

    const DEFAULT_HOUR_OUTLINE_COLOR = Graphics.COLOR_RED;
    const DEFAULT_MINUTE_OUTLINE_COLOR = Graphics.COLOR_GREEN;
    const DEFAULT_SECOND_OUTLINE_COLOR = Graphics.COLOR_BLUE;

    const DEAFULT_HOUR_SLICE_COLOR = Graphics.COLOR_DK_GRAY;
    const DEAFULT_MINUTE_SLICE_COLOR = Graphics.COLOR_DK_GRAY;
    const DEAFULT_SECOND_SLICE_COLOR = Graphics.COLOR_DK_GRAY;

    // --- Configuration ---
    private var _showSeconds = WITH_SECONDS_DEFAULT;
    private var _layout = LAYOUT_CONCENTRIC;
    private var _screenCenter as Array;

    // --- Child Components ---
    private var _hoursChart;
    private var _minutesChart;
    private var _secondsChart;

    function initialize() {
        // Create the children
        _hoursChart   = new Piechart().withColors(DEFAULT_HOUR_OUTLINE_COLOR, DEAFULT_HOUR_SLICE_COLOR);
        _minutesChart = new Piechart().withColors(DEFAULT_MINUTE_OUTLINE_COLOR, DEAFULT_MINUTE_SLICE_COLOR);
        _secondsChart = new Piechart().withColors(DEFAULT_SECOND_OUTLINE_COLOR, DEAFULT_SECOND_SLICE_COLOR);
        
        // Grab screen center once
        var settings = System.getDeviceSettings();
        _screenCenter = [settings.screenWidth / 2, settings.screenHeight / 2] as Array;
    }

    // --- Fluent API ---

    //! Toggle seconds display
    function withSeconds() as PiechartTime {
        _showSeconds = true;
        return self;
    }

    //! Toggle seconds display
    function withoutSeconds() as PiechartTime {
        _showSeconds = true;
        return self;
    }

    //! Select the visual layout strategy
    function withLayout(layout as Layout) as PiechartTime {
        _layout = layout;
        return self;
    }

    //! Override default hour colors if desired
    function withHourColors(outlineColor as Number, sliceColor as Number) as PiechartTime {
        _hoursChart.withColors(outlineColor, sliceColor);
        return self;
    }

    //! Override default minutes colors if desired
    function withMinutesColors(outlineColor as Number, sliceColor as Number) as PiechartTime {
        _minutesChart.withColors(outlineColor, sliceColor);
        return self;
    }

    //! Override default seconds colors if desired
    function withSecondsColors(outlineColor as Number, sliceColor as Number) as PiechartTime {
        _secondsChart.withColors(outlineColor, sliceColor);
        return self;
    }

    //! Override default colors if desired
    function withColorTheme(h as Number, m as Number, s as Number) as PiechartTime {
        _hoursChart.withColors(h, Graphics.COLOR_DK_GRAY);
        _minutesChart.withColors(m, Graphics.COLOR_DK_GRAY);
        _secondsChart.withColors(s, Graphics.COLOR_DK_GRAY);
        return self;
    }

    // --- Main Logic ---

    function draw(dc) {
        // 1. Get Time
        var clock = System.getClockTime();
        
        // 2. Update Data (The "What")
        _hoursChart.withTurn(12).withValue(clock.hour % 12); // Simple 12h clock
        _minutesChart.withTurn(60).withValue(clock.min);
        _secondsChart.withTurn(60).withValue(clock.sec);

        // 3. Apply Layout (The "Where")
        if (_layout == LAYOUT_CONCENTRIC) {
            applyConcentricLayout(dc);
        } else if (_layout == LAYOUT_HORIZONTAL) {
            applyHorizontalLayout(dc);
        }

        // 4. Draw Enabled Charts
        _hoursChart.draw(dc);
        _minutesChart.draw(dc);
        if (_showSeconds) {
            _secondsChart.draw(dc);
        }
    }

    // --- Layout Strategies ---

    //! Layout: Concentric Rings (Apple Watch style)
    //! Hours = Outer, Minutes = Middle, Seconds = Inner
    private function applyConcentricLayout(dc) {
        var centerX = _screenCenter[0];
        var centerY = _screenCenter[1];
        
        // Dynamic sizing based on screen
        var maxRadius = (centerX < centerY ? centerX : centerY) - 5; // 5px padding from screen edge
        var thickness = maxRadius / 5; // Arbitrary aesthetic ratio
        var gap = 2;

        // Outer Ring (Hours)
        _hoursChart
            .withCenter(centerX, centerY)
            .withRadius(maxRadius)
            .withOutlineThickness(thickness);

        // Middle Ring (Minutes)
        _minutesChart
            .withCenter(centerX, centerY)
            .withRadius(maxRadius - thickness - gap)
            .withOutlineThickness(thickness);

        // Inner Ring (Seconds)
        _secondsChart
            .withCenter(centerX, centerY)
            .withRadius(maxRadius - (thickness * 2) - (gap * 2))
            .withOutlineThickness(thickness);
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
        _hoursChart
            .withCenter(itemSpace / 2, cy)
            .withRadius(radius)
            .withOutlineThickness(3); // Thinner line for small charts

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