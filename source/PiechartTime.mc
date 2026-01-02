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

    function initialize() {
        // Create the children
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

    //! Override default hour slice color if desired
    function withHourSliceColor(sliceColor as Number) as PiechartTime {
        _hourChart.withSliceColor(sliceColor);
        return self;
    }

    //! Override default hour outline color if desired
    function withHourOutlineColor(outlineColor as Number) as PiechartTime {
        _hourChart.withOutlineColor(outlineColor);
        return self;
    }

    //! Override default minutes slice color if desired
    function withMinutesSliceColor(sliceColor as Number) as PiechartTime {
        _minutesChart.withSliceColor(sliceColor);
        return self;
    }

    //! Override default minutes outline color if desired
    function withMinutesOutlineColor(outlineColor as Number) as PiechartTime {
        _minutesChart.withOutlineColor(outlineColor);
        return self;
    }

    //! Override default seconds slice color if desired
    function withSecondsSliceColor(sliceColor as Number) as PiechartTime {
        _secondsChart.withSliceColor(sliceColor);
        return self;
    }

    //! Override default seconds outline color if desired
    function withSecondsOutlineColor(outlineColor as Number) as PiechartTime {
        _secondsChart.withOutlineColor(outlineColor);
        return self;
    }

    //! Override default colors if desired
    function withColorTheme(colorTheme as ColorTheme) as PiechartTime {
        _hourChart
            .withSliceColor(colorTheme.hourSlice)
            .withOutlineColor(colorTheme.hourOutline);
        _minutesChart
            .withSliceColor(colorTheme.minutesSlice)
            .withOutlineColor(colorTheme.minutesOutline);
        _secondsChart
            .withSliceColor(colorTheme.secondsSlice)
            .withOutlineColor(colorTheme.secondsOutline);
        return self;
    }

    // --- Main Logic ---

    function draw(dc) {
        // 1. Get Time
        var clock = System.getClockTime();
        
        // 2. Update Data (The "What")
        // TODO 12h or 24h based on a user setting
        _hourChart.withTurn(12).withValue(clock.hour % 12); // Simple 12h clock
        _minutesChart.withTurn(60).withValue(clock.min);
        _secondsChart.withTurn(60).withValue(clock.sec);

        // 3. Apply Layout (The "Where")
        if (_layout == LAYOUT_CONCENTRIC) {
            applyConcentricLayout(dc);
        } else if (_layout == LAYOUT_HORIZONTAL) {
            applyHorizontalLayout(dc);
        }

        // 4. Draw Enabled Charts
        _hourChart.draw(dc);
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
        _hourChart
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
        _hourChart
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