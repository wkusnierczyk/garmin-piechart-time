import Toybox.Test;
import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

// -----------------------------------------------------------------------------
// 1. Enhanced Mock Object (The Spy)
// -----------------------------------------------------------------------------
//! A smart mock that records a history of drawing operations
class SpyDc {
    public var operations  as Array<Dictionary> = [];
    public var currentPenWidth = 1;
    public var currentColor = Graphics.COLOR_WHITE;

    function setColor(foreground, background) {
        currentColor = foreground;
    }

    function setPenWidth(width) {
        currentPenWidth = width;
    }

    function drawCircle(x, y, r) {
        operations.add({
            :type => "circle",
            :x => x,
            :y => y,
            :radius => r,
            :penWidth => currentPenWidth,
            :color => currentColor
        });
    }

    function drawArc(x, y, r, attr, start, end) {
        operations.add({
            :type => "arc",
            :x => x,
            :y => y,
            :radius => r,
            :start => start,
            :end => end,
            :penWidth => currentPenWidth,
            :color => currentColor
        });
    }

    //! Helper to count how many circles were drawn
    function countCircles() {
        var count = 0;
        for (var i = 0; i < operations.size(); i++) {
            if (operations[i][:type].equals("circle")) {
                count++;
            }
        }
        return count;
    }

    //! Helper to get all circle operations
    function getCircles() {
        var circles = [];
        for (var i = 0; i < operations.size(); i++) {
            if (operations[i][:type].equals("circle")) {
                circles.add(operations[i]);
            }
        }
        return circles;
    }
}

// -----------------------------------------------------------------------------
// 2. The Unit Tests
// -----------------------------------------------------------------------------

(:test)
function testDefaultConfiguration(logger as Test.Logger) as Boolean {
    // defaults: Concentric Layout, No Seconds
    var manager = new PiechartTime();
    var spy = new SpyDc();

    manager.draw(spy);

    // Expectation: 
    // - Seconds are OFF, so we only expect drawing for Hours and Minutes.
    // - Each chart draws 1 Unfilled Circle + 1 Outline Circle + 1 Slice Arc (maybe)
    // - Minimum expected circles: 2 charts * 2 circles (bg + outline) = 4 circles.
    
    var circleCount = spy.countCircles();
    Test.assertMessage(circleCount >= 4, "Should draw at least 4 circles (Background + Outline for Hours & Minutes)");
    
    // Validate Concentric Layout
    // All circles should share the same center (roughly screen center)
    var circles = spy.getCircles() as Array<Dictionary>;
    var firstX = circles[0][:x];
    var firstY = circles[0][:y];

    for (var i = 1; i < circles.size(); i++) {
        Test.assertEqual(firstX, circles[i][:x]);
        Test.assertEqual(firstY, circles[i][:y]);
    }

    return true;
}

(:test)
function testWithSecondsEnabled(logger as Test.Logger) as Boolean {
    var manager = new PiechartTime();
    var spy = new SpyDc();

    manager.withSeconds() // Enable seconds
           .draw(spy);

    // Expectation:
    // - Now we have 3 charts (Hours, Mins, Secs).
    // - Minimum circles: 3 charts * 2 circles (bg + outline) = 6 circles.
    
    var circleCount = spy.countCircles();
    Test.assertMessage(circleCount >= 6, "Should draw at least 6 circles when Seconds are enabled");

    return true;
}

(:test)
function testConcentricLayering(logger as Test.Logger) as Boolean {
    var manager = new PiechartTime();
    var spy = new SpyDc();

    // Concentric Layout logic implies:
    // Seconds Radius > Minutes Radius > Hours Radius
    manager.withSeconds()
           .withLayout(PiechartTime.LAYOUT_CONCENTRIC)
           .draw(spy);

    var circles = spy.getCircles() as Array<Dictionary>;
    
    // We need to find the distinct radii used to verify the hierarchy.
    // Since we can't easily map a circle back to "Hours" vs "Minutes" without assuming order,
    // we simply check that we have at least 3 distinct radius groups.
    
    var distinctRadii = [];
    for (var i = 0; i < circles.size(); i++) {
        var r = circles[i][:radius];
        var isNew = true;
        // Simple distinct check
        for (var j = 0; j < distinctRadii.size(); j++) {
            if (distinctRadii[j] == r) { isNew = false; }
        }
        if (isNew) { distinctRadii.add(r); }
    }

    Test.assertMessage(distinctRadii.size() >= 3, "Should have 3 distinct sizes for concentric rings");
    
    return true;
}

(:test)
function testHorizontalLayout(logger as Test.Logger) as Boolean {
    var manager = new PiechartTime();
    var spy = new SpyDc();

    manager.withLayout(PiechartTime.LAYOUT_HORIZONTAL)
           .withSeconds()
           .draw(spy);

    var circles = spy.getCircles() as Array<Dictionary>;

    // Validate Horizontal Layout
    // Circles should have DIFFERENT X coordinates, but SAME Y coordinate
    
    var distinctX = [];
    var firstY = circles[0][:y];
    var yAligned = true;

    for (var i = 0; i < circles.size(); i++) {
        // Check Y alignment
        if (circles[i][:y] != firstY) { yAligned = false; }

        // Collect X
        var x = circles[i][:x];
        var isNew = true;
        for (var j = 0; j < distinctX.size(); j++) {
            if (distinctX[j] == x) { isNew = false; }
        }
        if (isNew) { distinctX.add(x); }
    }

    Test.assertMessage(yAligned, "All charts should be vertically aligned in Horizontal layout");
    Test.assertMessage(distinctX.size() >= 3, "Should have 3 distinct X positions for Horizontal layout");

    return true;
}