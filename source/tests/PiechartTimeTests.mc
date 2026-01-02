import Toybox.Test;
import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

// -----------------------------------------------------------------------------
// 1. Enhanced Mock Object (The Spy)
// -----------------------------------------------------------------------------
class SpyDc {
    public var operations as Array<Dictionary> = [];
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

    function countCircles() {
        var count = 0;
        for (var i = 0; i < operations.size(); i++) {
            if (operations[i][:type].equals("circle")) {
                count++;
            }
        }
        return count;
    }

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
function testTimeManagerSeconds(logger as Test.Logger) as Boolean {
    // Renamed from testWithSecondsEnabled
    var manager = new PiechartTime();
    var spy = new SpyDc();

    manager.withSeconds()
           .draw(spy);

    // Expectation:
    // - 3 charts (Hours, Mins, Secs)
    // - Total circles: 3 * 2 = 6
    
    var circleCount = spy.countCircles();
    Test.assertMessage(circleCount >= 6, "Should draw at least 6 circles when Seconds are enabled");

    return true;
}

(:test)
function testTimeManagerConcentric(logger as Test.Logger) as Boolean {
    // Renamed from testConcentricLayering
    var manager = new PiechartTime();
    var spy = new SpyDc();

    manager.withSeconds()
           .withLayout(new PiechartTimeConcentricLayout())
           .draw(spy);

    var circles = spy.getCircles() as Array<Dictionary>;
    
    // Verify Hierarchy: Should have at least 3 distinct radius groups
    var distinctRadii = [];
    for (var i = 0; i < circles.size(); i++) {
        var r = circles[i][:radius];
        var isNew = true;
        for (var j = 0; j < distinctRadii.size(); j++) {
            if (distinctRadii[j] == r) { isNew = false; }
        }
        if (isNew) { distinctRadii.add(r); }
    }

    Test.assertMessage(distinctRadii.size() >= 3, "Should have 3 distinct sizes for concentric rings");
    
    return true;
}

(:test)
function testTimeManagerHorizontal(logger as Test.Logger) as Boolean {
    // Renamed from testHorizontalLayout (Collision Fix)
    var manager = new PiechartTime();
    var spy = new SpyDc();

    manager.withLayout(new PiechartTimeHorizontalLayout())
           .withSeconds()
           .draw(spy);

    var circles = spy.getCircles() as Array<Dictionary>;

    // Validate Horizontal Layout
    // Circles should have DIFFERENT X coordinates
    
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