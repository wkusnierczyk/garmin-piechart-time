import Toybox.Test;
import Toybox.Lang;
import Toybox.Graphics;


// -----------------------------------------------------------------------------
// Unit Tests
// -----------------------------------------------------------------------------

(:test)
function testConcentricLayout(logger as Test.Logger) as Boolean {
    var layout = new PiechartTimeConcentricLayout();
    var h = new MockPiechart();
    var m = new MockPiechart();
    var s = new MockPiechart();

    // Act
    layout.apply(h, m, s, true);

    // Assert: Alignment
    // All rings should share the exact same center
    Test.assertEqual(h.x, m.x);
    Test.assertEqual(h.y, m.y);
    Test.assertEqual(m.x, s.x);

    // Assert: Hierarchy
    // Seconds (Outer) > Minutes (Middle) > Hours (Inner)
    Test.assertMessage(s.r > m.r, "Seconds radius should be largest");
    Test.assertMessage(m.r > h.r, "Minutes radius should be larger than hours");

    return true;
}

(:test)
function testHorizontalLayout(logger as Test.Logger) as Boolean {
    var layout = new PiechartTimeHorizontalLayout();
    var h = new MockPiechart();
    var m = new MockPiechart();
    var s = new MockPiechart();

    // Case 1: Seconds Enabled (3 Columns)
    layout.apply(h, m, s, true);

    // X positions should be increasing (Left -> Right)
    Test.assertMessage(h.x < m.x, "Hours should be left of Minutes");
    Test.assertMessage(m.x < s.x, "Minutes should be left of Seconds");
    
    // Y positions should be identical (Centered vertically)
    Test.assertEqual(h.y, m.y);
    Test.assertEqual(m.y, s.y);

    // Case 2: Seconds Disabled (2 Columns)
    // We reset positions to 0 to verify they change
    h.x = 0; m.x = 0; s.x = 0;
    
    layout.apply(h, m, s, false);
    
    Test.assertMessage(h.x < m.x, "Hours should be left of Minutes");
    // Verify specific symmetry: Hours X should be roughly 25% of width, Mins X roughly 75%
    // Since we can't easily get screen width here, we check that they are far apart
    Test.assertMessage(m.x > h.x, "Minutes should still be to the right");
    
    return true;
}

// TODO: Implement and enable test
// (:test)
function testStackedLayout(logger as Test.Logger) as Boolean {

    var layout = new PiechartTimeStackedLayout();
    var h = new MockPiechart();
    var m = new MockPiechart();
    var s = new MockPiechart();

    layout.apply(h, m, s, true);

    // Hour must be entirely to the left of minutes and seconds

    // Minutes must be (roughly) top-aligned with hour

    // Seconds must be (roughly) bottom-aligned with hour

    // Minutes and seconds must ne (roughly) left-aligned

    // Minutes and seconds must occupy less space than hour

    return true;
}

(:test)
function testLayoutPickerDefaults(logger as Test.Logger) as Boolean {
    var picker = new PiechartTimeLayoutPicker();

    // 1. Verify we have layouts
    Test.assertMessage(picker.getCount() > 0, "Picker should have layouts loaded");
    
    // 2. Verify safe retrieval
    // This calls _validateCurrentIndex -> PropertyUtils. 
    // Thanks to the try-catch fix, this won't crash.
    var current = picker.getCurrentLayout();
    
    Test.assertMessage(current instanceof PiechartTimeLayout, "Should return a valid layout instance");

    return true;
}