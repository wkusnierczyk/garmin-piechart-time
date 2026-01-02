import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;


//! A fluent class for drawing circular pie-chart style timers.
//!
//! This class allows for the creation of "Donut" or "Pie" style charts
//! where a slice fills up clockwise to represent progress.
//! It supports method chaining (fluent interface) for configuration.
class PiechartTime {

    // --- Constants ---

    //! Constant for a 24-hour cycle denominator
    const HOUR_TURN_24h = 24;

    //! Constant for a 12-hour cycle denominator
    const HOUR_TURN_12H = 12;

    //! Default turn value (denominator), defaults to 12 hours.
    const DEFAULT_HOUR_TURN = HOUR_TURN_12H;

    //! Default minutes denominator (60).
    const DEFAULT_MINUTES_TURN = 60;

    //! Default seconds denominator (60).
    const DEFAULT_SECONDS_TURN = 60;

    //! The initial default turn (denominator) for a new instance.
    const DEFAULT_TURN = DEFAULT_HOUR_TURN;

    //! The initial default value (numerator).
    const DEFAULT_VALUE = 0;

    //! Default radius of the chart in pixels.
    const DEFAULT_RADIUS = 25;

    //! Default thickness of the outline ring in pixels.
    const DEFAULT_OUTLINE_THICKNESS = 1;

    //! Default color for the outline ring.
    const DEFAULT_OUTLINE_COLOR = Graphics.COLOR_WHITE;

    //! Default color for the filled slice.
    const DEFAULT_SLICE_COLOR = Graphics.COLOR_WHITE;

    //! Threshold to prevent drawing artifacts for extremely small values.
    //! If the fraction of the circle is less than this, the slice is not drawn.
    const SLICE_TO_TURN_FRACTION_THRESHOLD = 0.001;

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

    //! The color of the outer boundary ring.
    private var _outlineColor = DEFAULT_OUTLINE_COLOR;

    //! The thickness of the outer boundary ring.
    private var _outlineThickness = DEFAULT_OUTLINE_THICKNESS;

    //! The color of the active time slice.
    private var _sliceColor = DEFAULT_SLICE_COLOR;

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

    //! Sets the denominator for the chart.
    //! @param turn [Number] The full cycle value (e.g., 12, 24, or 60).
    //! @return [PiechartTime] The current instance for chaining.
    function withTurn(turn as Number) as PiechartTime {
        _turn = turn;
        return self;
    }

    //! Sets the current value to display (numerator).
    //! The value is duck-typed (Number or Float).
    //! @param value [Number|Float] The time elapsed.
    //! @return [PiechartTime] The current instance for chaining.
    function withValue(value) as PiechartTime {
        _value = value;
        return self;
    }

    //! Sets the absolute center position of the chart.
    //! @param centerX [Number] The X coordinate.
    //! @param centerY [Number] The Y coordinate.
    //! @return [PiechartTime] The current instance for chaining.
    function withCenter(centerX as Number, centerY as Number) as PiechartTime {
        _centerX = centerX;
        _centerY = centerY;
        return self;
    }

    //! Sets the radius of the chart.
    //! @param radius [Number] The distance from center to the outer edge.
    //! @return [PiechartTime] The current instance for chaining.
    function withRadius(radius as Number) as PiechartTime {
        _radius = radius;
        return self;
    }

    //! Sets the color of the outer ring.
    //! @param color [Graphics.ColorType] The color constant (e.g., Graphics.COLOR_RED).
    //! @return [PiechartTime] The current instance for chaining.
    function withOutlineColor(color as Graphics.ColorType) as PiechartTime {
        _outlineColor = color;
        return self;
    }

    //! Sets the thickness of the outer ring.
    //! @param thickness [Number] Thickness in pixels.
    //! @return [PiechartTime] The current instance for chaining.
    function withOutlineThickness(thickness as Number) as PiechartTime {
        _outlineThickness = thickness;
        return self;
    }

    //! Sets the color of the filled pie slice.
    //! @param color [Graphics.ColorType] The color constant.
    //! @return [PiechartTime] The current instance for chaining.
    function withSliceColor(color as Graphics.ColorType) as PiechartTime {
        _sliceColor = color;
        return self;
    }

    // --- Drawing Logic ---

    //! Draws the chart onto the provided Device Context (DC).
    //! @param dc [Toybox.Graphics.Dc] The device context to draw on.
    function draw(dc as Dc) {

        // 1. Draw the Outline Ring
        dc.setColor(_outlineColor, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(_outlineThickness);
        
        // drawCircle draws along the center of the pen width.
        // We subtract half the thickness so the stroke sits exactly inside the defined radius.
        dc.drawCircle(_centerX, _centerY, _radius - (_outlineThickness / 2.0));

        // 2. Draw the Pie Slice
        // Handle wrapping (e.g., if value is 25 hours on a 24h clock, it becomes 1).
        // Note: Use caution if _value is a Float; modulo (%) behaves differently across languages for floats.
        // Ideally _value here matches the type of _turn for modulo operations.
        _value = _value % _turn;

        // Calculate the percentage (0.0 to 1.0)
        // We cast parameters to float to ensure floating point division is performed.
        var fraction = _value.toFloat() / _turn.toFloat();

        // Only draw if there is value and it fits within reasonable bounds (avoids 0-width artifacts)
        if (fraction > SLICE_TO_TURN_FRACTION_THRESHOLD) {
            dc.setColor(_sliceColor, Graphics.COLOR_TRANSPARENT);

            // To create a solid wedge using drawArc:
            // The pen width must equal the radius of the slice.
            // The arc radius must be half of that width.
            
            // We want the slice to fit *inside* the outline ring with a 1px gap.
            var sliceRadius = _radius - _outlineThickness - 1;
            
            // Set pen width to the full length of the slice (center to edge)
            var arcPenWidth = sliceRadius;
            
            // The drawing radius is the center point of that pen width
            var arcDrawingRadius = sliceRadius / 2;

            dc.setPenWidth(arcPenWidth);

            // Coordinate system: 
            // 90 degrees = 12 o'clock position
            var startAngle = 90;
            
            // Monkey C drawArc takes degrees. 
            // Clockwise movement subtracts from the start angle.
            var degreesToDraw = fraction * 360;
            var endAngle = startAngle - degreesToDraw;

            dc.drawArc(_centerX, _centerY, arcDrawingRadius, Graphics.ARC_CLOCKWISE, startAngle, endAngle);
        }

    }
    
}