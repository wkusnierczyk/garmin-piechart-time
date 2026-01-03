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
    
    // Pickers for loading from system properties
    private var _layoutPicker as PiechartTimeLayoutPicker;
    private var _themePicker as ColorThemePicker;
    
    // Optional override for testing or manual control
    private var _layoutOverride as PiechartTimeLayout or Null;

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
    function withSeconds() as PiechartTime {
        _showSeconds = true;
        return self;
    }

    //! Disable seconds display
    function withoutSeconds() as PiechartTime {
        _showSeconds = false;
        return self;
    }

    //! Enable or disable seconds display
    function showSeconds(showSeconds as Boolean) as PiechartTime {
        _showSeconds = showSeconds;
        return self;
    }

    //! Select the visual layout strategy manually (overrides system setting)
    //! @param layout [PiechartTimeLayout] The strategy instance
    function withLayout(layout as PiechartTimeLayout) as PiechartTime {
        _layoutOverride = layout;
        return self;
    }

    //! Apply a full color theme to all charts
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
    function draw(dc) {

        // 1. Get Time
        var clockTime = System.getClockTime();
        var hour = clockTime.hour;
        var minutes = clockTime.min;
        var seconds = clockTime.sec;

        // 2. Update Data
        _hourChart.withTurn(12).withValue(hour % 12);
        _minutesChart.withTurn(60).withValue(minutes);
        _secondsChart.withTurn(60).withValue(seconds);

        // 3. Determine Layout (Override > Picker)
        var layout = _layoutOverride;
        if (layout == null) {
            layout = _layoutPicker.getCurrentLayout();
        }
        
        // 4. Apply Layout
        layout.apply(_hourChart, _minutesChart, _secondsChart, _showSeconds);

        // 5. Apply color theme
        var theme = _themePicker.getCurrentTheme();
        theme.apply(_hourChart, _minutesChart, _secondsChart);
            
        // 6. Draw (Painter's Algorithm: Largest/Back to Smallest/Front)
        if (_showSeconds) {
            _secondsChart.draw(dc);
        }
        _minutesChart.draw(dc);
        _hourChart.draw(dc);
    }
}