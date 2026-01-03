import Toybox.Test;
import Toybox.Lang;
import Toybox.Graphics;


// -----------------------------------------------------------------------------
// Unit Tests
// -----------------------------------------------------------------------------

(:test)
function testThemeApplication(logger as Test.Logger) as Boolean {
    var themeName = "Test Theme";
    var hourSlice = 0xFF0000; var hourOutline = 0xFFFFFF; var hourUnfilled = 0x000000;
    var minutesSlice = 0x00FF00; var minutesOutline = 0xAAAAAA; var minutesUnfilled = 0x111111;
    var secondsSlice = 0x0000FF; var secondsOutline = 0x555555; var secondsUnfilled = 0x222222;

    var theme = new ColorTheme(
        themeName,
        {
            :hourSlice => hourSlice,
            :hourOutline => hourOutline,
            :hourUnfilled => hourUnfilled
        },
        {
            :minutesSlice => minutesSlice,
            :minutesOutline => minutesOutline,
            :minutesUnfilled => minutesUnfilled
        },
        {
            :secondsSlice => secondsSlice,
            :secondsOutline => secondsOutline,
            :secondsUnfilled => secondsUnfilled
        }
    );

    var mockHours = new MockPiechart();
    var mockMinutes = new MockPiechart();
    var mockSeconds = new MockPiechart();

    theme.apply(mockHours, mockMinutes, mockSeconds);

    Test.assertEqual(hourSlice, mockHours.lastSliceColor);
    Test.assertEqual(hourOutline, mockHours.lastOutlineColor);
    Test.assertEqual(hourUnfilled, mockHours.lastUnfilledColor);

    Test.assertEqual(minutesSlice, mockMinutes.lastSliceColor);
    Test.assertEqual(minutesOutline, mockMinutes.lastOutlineColor);
    Test.assertEqual(minutesUnfilled, mockMinutes.lastUnfilledColor);

    Test.assertEqual(secondsSlice, mockSeconds.lastSliceColor);
    Test.assertEqual(secondsOutline, mockSeconds.lastOutlineColor);
    Test.assertEqual(secondsUnfilled, mockSeconds.lastUnfilledColor);

    return true;
}

(:test)
function testPickerDefaults(logger as Test.Logger) as Boolean {
    var picker = new ColorThemePicker();

    Test.assertMessage(picker.size() > 0, "Picker should have at least one theme");
    
    // 1. Get the actual current index (set by JSON default or property)
    var currentIndex = picker.getCurrentIndex();
    
    // 2. Get the current theme
    var currentTheme = picker.getCurrentTheme();
    Test.assertMessage(currentTheme instanceof ColorTheme, "getCurrentTheme() should return a ColorTheme object");
    
    // 3. Verify Consistency
    var names = picker.getThemeNames();
    
    Test.assertEqual(picker.size(), names.size());
    // Use currentIndex to verify name, rather than assuming 0
    Test.assertEqual(currentTheme.name, names[currentIndex]);

    return true;
}
