import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;
import Toybox.Time;
import Toybox.Time.Gregorian;

//! A High-Level component that manages multiple Piecharts to display Time.
class PiechartTime {

    const WITH_SECONDS_DEFAULT = false;
    
    const CONCENTRIC_LAYOUT_EXPANSE = 0.6;

    // --- Default Color Constants ---
    static const DEFAULT_HOUR_OUTLINE_COLOR = Graphics.COLOR_RED;
    static const DEFAULT_MINUTES_OUTLINE_COLOR = Graphics.COLOR_GREEN;
    static const DEFAULT_SECONDS_OUTLINE_COLOR = Graphics.COLOR_BLUE;

    static const DEFAULT_HOUR_SLICE_COLOR = Graphics.COLOR_DK_GRAY;
    static const DEFAULT_MINUTES_SLICE_COLOR = Graphics.COLOR_DK_GRAY;
    static const DEFAULT_SECONDS_SLICE_COLOR = Graphics.COLOR_DK_GRAY;

    // --- Configuration ---
    private var _showSeconds = WITH_SECONDS_DEFAULT;
    private var _layoutPicker as PiechartTimeLayoutPicker;
    private var _themePicker as ColorThemePicker;

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

        _layoutPicker = new PiechartTimeLayoutPicker();
        _themePicker = new ColorThemePicker();
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

    //! Enable or disable seconds display
    //! @param showSeconds [Boolean]
    //! @return [PiechartTime] self
    function showSeconds(showSeconds as Boolean) as PiechartTime {
        _showSeconds = showSeconds;
        return self;
    }

    // //! Select the visual layout strategy
    // //! @param layout [PiechartTime.Layout]
    // //! @return [PiechartTime] self
    // function withLayout(layout as Layout) as PiechartTime {
    //     _layout = layout;
    //     return self;
    // }

    //! Apply a full color theme to all charts
    //! @param colorTheme [ColorTheme] The theme data object
    //! @return [PiechartTime] self
    function withColorTheme(colorTheme as ColorTheme) as PiechartTime {
        _hourChart
            .withSliceColor(colorTheme.hourSlice)
            .withOutlineColor(colorTheme.hourOutline)
            .withUnfilledColor(colorTheme.hourUnfilled); 
            
        _minutesChart
            .withSliceColor(colorTheme.minutesSlice)
            .withOutlineColor(colorTheme.minutesOutline)
            .withUnfilledColor(colorTheme.minutesUnfilled);
            
        _secondsChart
            .withSliceColor(colorTheme.secondsSlice)
            .withOutlineColor(colorTheme.secondsOutline)
            .withUnfilledColor(colorTheme.secondsUnfilled);
            
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
        var layout = _layoutPicker.getCurrentLayout();
        layout.apply(_hourChart, _minutesChart, _secondsChart, _showSeconds);

        // 4. Apply color theme (The "How")
        var theme = _themePicker.getCurrentTheme();
        theme.apply(_hourChart, _minutesChart, _secondsChart);
            
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

}