import Toybox.Test;
import Toybox.Lang;
import Toybox.Graphics;


// -----------------------------------------------------------------------------
// Unit Tests
// -----------------------------------------------------------------------------

(:test)
function testThemeApplication(logger as Test.Logger) as Boolean {
    var themeName = "Test Theme";
    var hSlice = 0xFF0000; var hOutline = 0xFFFFFF; var hUnfilled = 0x000000;
    var mSlice = 0x00FF00; var mOutline = 0xAAAAAA; var mUnfilled = 0x111111;
    var sSlice = 0x0000FF; var sOutline = 0x555555; var sUnfilled = 0x222222;

    var theme = new ColorTheme(
        themeName,
        hSlice, hOutline, hUnfilled,
        mSlice, mOutline, mUnfilled,
        sSlice, sOutline, sUnfilled
    );

    var mockHours = new MockPiechart();
    var mockMinutes = new MockPiechart();
    var mockSeconds = new MockPiechart();

    theme.apply(mockHours, mockMinutes, mockSeconds);

    Test.assertEqual(hSlice, mockHours.lastSliceColor);
    Test.assertEqual(hOutline, mockHours.lastOutlineColor);
    Test.assertEqual(hUnfilled, mockHours.lastUnfilledColor);

    Test.assertEqual(mSlice, mockMinutes.lastSliceColor);
    Test.assertEqual(mOutline, mockMinutes.lastOutlineColor);
    Test.assertEqual(mUnfilled, mockMinutes.lastUnfilledColor);

    Test.assertEqual(sSlice, mockSeconds.lastSliceColor);
    Test.assertEqual(sOutline, mockSeconds.lastOutlineColor);
    Test.assertEqual(sUnfilled, mockSeconds.lastUnfilledColor);

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
