import Toybox.Test;
import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

// -----------------------------------------------------------------------------
// 1. The Mock Object (The Spy)
// -----------------------------------------------------------------------------
class MockDc {
    public var lastColor = null;
    public var lastPenWidth = 0; // Initialize to 0 safety
    public var lastArcStart = null;
    public var lastArcEnd = null;
    public var drawArcCalled = false;

    // Track circle calls specifically
    public var backgroundCircleDrawn = false;
    public var backgroundCircleColor = null;
    public var outlineCircleDrawn = false;
    public var outlineCircleColor = null;

    function setColor(foreground, background) {
        lastColor = foreground;
    }

    function setPenWidth(width) {
        lastPenWidth = width;
    }

    function drawCircle(x, y, r) {
        // Distinguish between the 'Unfilled' background and the 'Outline'
        // based on pen width.
        // Unfilled uses a width roughly equal to radius (very thick).
        // Outline uses a width of ~1-3px (very thin).
        if (lastPenWidth > 5) {
            backgroundCircleDrawn = true;
            backgroundCircleColor = lastColor;
        } else {
            outlineCircleDrawn = true;
            outlineCircleColor = lastColor;
        }
    }

    function drawArc(x, y, r, attr, start, end) {
        drawArcCalled = true;
        lastArcStart = start;
        lastArcEnd = end;
    }
}

// -----------------------------------------------------------------------------
// 2. The Unit Tests
// -----------------------------------------------------------------------------

(:test)
function testFluentConfiguration(logger as Test.Logger) as Boolean {
    var chart = new Piechart();
    chart
        .asTime(Piechart.PIECHART_MINUTES)
        .withValue(15)
        .withRadius(50);
    
    Test.assertEqual(60, chart.getTurn());
    Test.assertEqual(15, chart.getValue());
    Test.assertEqual(50, chart.getRadius());

    return true;
}

(:test)
function test24HourPreset(logger as Test.Logger) as Boolean {
    var chart = new Piechart();
    chart.asTime(Piechart.PIECHART_24_HOURS); 
    
    Test.assertEqual(24, chart.getTurn());
    return true;
}

(:test)
function testDrawingMath(logger as Test.Logger) as Boolean {
    var chart = new Piechart();
    var mockDc = new MockDc();
    // 15 minutes on a 60 minute dial (25%)
    // Expected: Start 90 (12 o'clock), End 0 (3 o'clock)
    chart.asTime(Piechart.PIECHART_MINUTES)
         .withValue(15);
    chart.draw(mockDc); 

    Test.assertMessage(mockDc.drawArcCalled, "drawArc should have been called for the slice");
    Test.assertEqual(90, mockDc.lastArcStart);
    Test.assertEqual(0.0f, mockDc.lastArcEnd);
    
    return true;
}

(:test)
function testValueWrapping(logger as Test.Logger) as Boolean {
    var chart = new Piechart();
    var mockDc = new MockDc();
    // 75 minutes on a 60 minute dial -> should wrap to 15
    chart.asTime(Piechart.PIECHART_MINUTES)
         .withValue(75);
    chart.draw(mockDc);

    Test.assertEqual(0.0f, mockDc.lastArcEnd);

    return true;
}

(:test)
function testUnfilledBehavior(logger as Test.Logger) as Boolean {
    var chart = new Piechart();
    var mockDc = new MockDc();

    // Setup: Red slice, Blue outline, Grey background
    chart.withUnfilledColor(Graphics.COLOR_LT_GRAY)
         .withOutlineColor(Graphics.COLOR_BLUE)
         .withOutlineThickness(2)
         .withValue(10);

    chart.draw(mockDc);

    // 1. Verify Unfilled Background (Thick Circle)
    Test.assertMessage(mockDc.backgroundCircleDrawn, "Background 'unfilled' circle was not drawn");
    Test.assertEqual(Graphics.COLOR_LT_GRAY, mockDc.backgroundCircleColor);

    // 2. Verify Outline (Thin Circle)
    Test.assertMessage(mockDc.outlineCircleDrawn, "Outline ring was not drawn");
    Test.assertEqual(Graphics.COLOR_BLUE, mockDc.outlineCircleColor);

    return true;
}