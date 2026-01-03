import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

//! A fluent class for drawing circular pie-chart style timers.
//! This class allows for the creation of "Donut" or "Pie" style charts
//! where a slice fills up clockwise to represent progress.
//! It supports method chaining (fluent interface) for configuration.
class Piechart {

    // --- Constants ---

    //! Enumeration of standard time presets for chart configuration.
    enum PiechartType {
        //! Preset for a standard 12-hour clock face.
        PIECHART_12_HOURS,
        //! Preset for a 24-hour daily progress cycle.
        PIECHART_24_HOURS,
        //! Preset for standard 0-60 minutes.
        PIECHART_MINUTES,
        //! Preset for standard 0-60 seconds.
        PIECHART_SECONDS,
        //! Preset for 100 beats (Swatch time or otherwise).
        PIECHART_BEATS
    }

    //! Constant for a 24-hour cycle denominator
    static const HOUR_TURN_24H = 24;
    //! Constant for a 12-hour cycle denominator
    static const HOUR_TURN_12H = 12;

    //! Default turn value (denominator), defaults to 12 hours.
    const DEFAULT_HOUR_TURN = HOUR_TURN_12H;

    //! Default minutes denominator (60).
    static const MINUTES_TURN = 60;

    //! Default seconds denominator (60).
    static const SECONDS_TURN = 60;

    //! Default beats denominator (100).
    static const BEATS_TURN = 100;

    //! The initial default turn (denominator) for a new instance.
    const DEFAULT_TURN = DEFAULT_HOUR_TURN;

    //! The initial default value (numerator).
    const DEFAULT_VALUE = 0;

    //! Default radius of the chart in pixels.
    const DEFAULT_RADIUS = 25;

    //! Default thickness of the outline ring in pixels.
    const DEFAULT_OUTLINE_THICKNESS = 5;

    //! Default color for the outline ring.
    const DEFAULT_OUTLINE_COLOR = Graphics.COLOR_WHITE;

    //! Default color for the filled slice.
    const DEFAULT_SLICE_COLOR = Graphics.COLOR_WHITE;
    
    //! Default color for the unfilled background (fixing transparency issues).
    const DEFAULT_UNFILLED_COLOR = Graphics.COLOR_BLACK;

    //! Threshold to prevent drawing artifacts for extremely small values.
    //! If the fraction of the circle is less than this, the slice is not drawn.
    const SLICE_TO_TURN_FRACTION_THRESHOLD = 0.001;

    //! Default order of drawing the outline and the slice.
    const DEFAULT_SLICE_OVER_OUTLINE = false;

    // --- Member Variables ---

    //! The denominator of the chart (e.g., 60 for minutes).
    private var _turn = DEFAULT_TURN;

    //! The numerator of the chart (the elapsed time).
    private var _value = DEFAULT_VALUE;

    //! The X coordinate of the chart's center.
    private var _centerX;

    //! The Y coordinate of the chart's center.
    private var _centerY;

    //! The radius of the chart (center to outer edge).
    private var _radius = DEFAULT_RADIUS;

    //! The thickness of the outer boundary ring.
    private var _outlineThickness = DEFAULT_OUTLINE_THICKNESS;

    //! The color of the outer boundary ring.
    private var _outlineColor = DEFAULT_OUTLINE_COLOR;

    //! The color of the active time slice.
    private var _sliceColor = DEFAULT_SLICE_COLOR;
    
    //! The color of the inactive/background disc.
    private var _unfilledColor = DEFAULT_UNFILLED_COLOR;

    //! The order of drawing the outline and the slice.
    private var _sliceOverOutline = DEFAULT_SLICE_OVER_OUTLINE;

    // --- Initialization ---

    //! Constructor.
    //! Initializes the chart with default settings and centers it on the screen.
    function initialize() {
        var settings = System.getDeviceSettings();
        // Default to the physical center of the screen
        _centerX = settings.screenWidth / 2;
        _centerY = settings.screenHeight / 2;
    }

    // --- Fluent Interface ---

    //! Configures the chart's cycle (turn) based on a standard time preset.
    //! This helper method abstracts away the specific turn numbers for common 
    //! time units, automatically setting the correct denominator.
    //! @param type [Number] A value from the TimeType enum (e.g., Piechart.PIECHART_MINUTES).
    //! @return [Piechart] The current instance for chaining.
    function asTime(time as Number) as Piechart {
        switch (time) {
            case PIECHART_12_HOURS:
                _turn = HOUR_TURN_12H;
                break;
            case PIECHART_24_HOURS:
                _turn = HOUR_TURN_24H;
                break;
            case PIECHART_MINUTES:
                _turn = MINUTES_TURN;
                break;
            case PIECHART_SECONDS:
                _turn = SECONDS_TURN;
                break;
            default:
                // Safety fallback to prevent undefined behavior
                System.println("Piechart: Unknown time type passed to asTime(), defaulting to 12H.");
                _turn = HOUR_TURN_12H;
                break;
        }
        return self;
    }

    //! Sets the denominator for the chart.
    //! @param turn [Number] The full cycle value (e.g., 12, 24, or 60).
    //! @return [Piechart] The current instance for chaining.
    function withTurn(turn as Number) as Piechart {
        _turn = turn;
        return self;
    }

    //! Sets the current value to display (numerator).
    //! The value is duck-typed (Number or Float).
    //! @param value [Number|Float] The time elapsed.
    //! @return [Piechart] The current instance for chaining.
    function withValue(value) as Piechart {
        _value = value;
        return self;
    }

    //! Sets the absolute center position of the chart.
    //! @param centerX [Number] The X coordinate.
    //! @param centerY [Number] The Y coordinate.
    //! @return [Piechart] The current instance for chaining.
    function withCenter(centerX as Number, centerY as Number) as Piechart {
        _centerX = centerX;
        _centerY = centerY;
        return self;
    }

    //! Sets the radius of the chart.
    //! @param radius [Number] The distance from center to the outer edge.
    //! @return [Piechart] The current instance for chaining.
    function withRadius(radius as Number) as Piechart {
        _radius = radius;
        return self;
    }

    //! Sets the thickness of the outer ring.
    //! @param thickness [Number] Thickness in pixels.
    //! @return [Piechart] The current instance for chaining.
    function withOutlineThickness(thickness as Number) as Piechart {
        _outlineThickness = thickness;
        return self;
    }

    //! Sets the color of the outer ring.
    //! @param color [Graphics.ColorType] The color constant (e.g., Graphics.COLOR_RED).
    //! @return [Piechart] The current instance for chaining.
    function withOutlineColor(color as Graphics.ColorType) as Piechart {
        _outlineColor = color;
        return self;
    }

    //! Sets the color of the filled pie slice.
    //! @param color [Graphics.ColorType] The color constant.
    //! @return [Piechart] The current instance for chaining.
    function withSliceColor(color as Graphics.ColorType) as Piechart {
        _sliceColor = color;
        return self;
    }
    
    //! Sets the color of the background "unfilled" disc.
    //! @param color [Graphics.ColorType] The color constant.
    //! @return [Piechart] The current instance for chaining.
    function withUnfilledColor(color as Graphics.ColorType) as Piechart {
        _unfilledColor = color;
        return self;
    }

    //! Sets the order of drawing to slice over outline.
    //! @return [Piechart] The current instance for chaining.
    function withSliceOverOutline() as Piechart {
        _sliceOverOutline = true;
        return self;
    }

    //! Sets the order of drawing to outline over slice.
    //! @return [Piechart] The current instance for chaining.
    function withOutlineOverSlice() as Piechart {
        _sliceOverOutline = false;
        return self;
    }


    // --- Drawing Logic ---

    //! Draws the chart onto the provided Device Context (DC).
    //! @param dc [Toybox.Graphics.Dc] The device context to draw on.
    function draw(dc) {

        _drawUnfilled(dc);

        if (_sliceOverOutline) {
            _drawOutline(dc);
            _drawSlice(dc);
        } else {
            _drawSlice(dc);
            _drawOutline(dc);
        }

    }

    private function _drawUnfilled(dc) {
        var radius = _radius - (_outlineThickness / 2.0);
        var arcDrawingRadius = radius / 2;
        dc.setColor(_unfilledColor, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(radius);
        dc.drawCircle(_centerX, _centerY, arcDrawingRadius);
    }

    private function _drawSlice(dc) {

        var sliceRadius = _radius - (_outlineThickness / 2.0);
        var arcPenWidth = sliceRadius;
        var arcDrawingRadius = sliceRadius / 2;
        var value = _value % _turn;
        var fraction = value.toFloat() / _turn.toFloat();

        if (fraction > SLICE_TO_TURN_FRACTION_THRESHOLD) {
            dc.setColor(_sliceColor, Graphics.COLOR_TRANSPARENT);
            dc.setPenWidth(arcPenWidth);

            var startAngle = 90; // 12 o'clock
            var degreesToDraw = fraction * 360;
            var endAngle = startAngle - degreesToDraw;

            dc.drawArc(_centerX, _centerY, arcDrawingRadius, Graphics.ARC_CLOCKWISE, startAngle, endAngle);
        }

    }

    private function _drawOutline(dc) {
        dc.setColor(_outlineColor, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(_outlineThickness);
        // Draw along the center of the pen width
        dc.drawCircle(_centerX, _centerY, _radius - (_outlineThickness / 2.0));
    }

    // --- Unit Test Helpers ---
    // These methods allow the test runner to inspect the private internal state of the object.
    
    //! Helper to retrieve the current Turn denominator
    function getTurn() {
        return _turn;
    }

    //! Helper to retrieve the current Value numerator
    function getValue() {
        return _value;
    }

    //! Helper to retrieve the current Radius
    function getRadius() {
        return _radius;
    }

}