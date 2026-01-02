import Toybox.Test;
import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

// -----------------------------------------------------------------------------
// 1. The Mock Object (The Spy)
// -----------------------------------------------------------------------------
class MockDc {
    public var lastColor = null;
    public var lastPenWidth = null;
    public var lastArcStart = null;
    public var lastArcEnd = null;
    public var drawArcCalled = false;

    function setColor(foreground, background) {
        lastColor = foreground;
    }

    function setPenWidth(width) {
        lastPenWidth = width;
    }

    function drawCircle(x, y, r) {
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

    // FIXED: assertEqual only takes (expected, actual)
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

    // FIXED: Use assertMessage for custom messages
    Test.assertMessage(mockDc.drawArcCalled, "drawArc should have been called");
    
    // FIXED: assertEqual only takes (expected, actual)
    Test.assertEqual(90, mockDc.lastArcStart);
    // Use float 0.0f to match the type
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