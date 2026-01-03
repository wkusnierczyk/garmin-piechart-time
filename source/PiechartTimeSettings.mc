using Toybox.Application.Properties;
using Toybox.WatchUi;

import Toybox.Lang;


class PiechartTimeSettingsMenu extends WatchUi.Menu2 {

    function initialize() {

        Menu2.initialize({:title => CUSTOMIZE_MENU_TITLE});

        var standardTimeEnabled = PropertyUtils.getPropertyElseDefault(STANDARD_TIME_PROPERTY, STANDARD_TIME_MODE_DEFAULT);
        addItem(new WatchUi.ToggleMenuItem(
            STANDARD_TIME_LABEL, 
            null, 
            STANDARD_TIME_PROPERTY, 
            standardTimeEnabled, 
            null
        ));

        var showSecondsEnabled = PropertyUtils.getPropertyElseDefault(SHOW_SECONDS_PROPERTY, SHOW_SECONDS_MODE_DEFAULT);
        addItem(new WatchUi.ToggleMenuItem(
            SHOW_SECONDS_LABEL, 
            null, 
            SHOW_SECONDS_PROPERTY, 
            showSecondsEnabled, 
            null
        ));

        var layoutSelection = PropertyUtils.getPropertyElseDefault(LAYOUT_PROPERTY, LAYOUT_DEFAULT);
        var layoutName = LAYOUT_NAMES[layoutSelection];
        addItem(new WatchUi.MenuItem(
            LAYOUT_LABEL,
            layoutName,
            LAYOUT_PROPERTY,
            null
        ));

        var themeSelection = PropertyUtils.getPropertyElseDefault(THEME_PROPERTY, THEME_DEFAULT);
        var themeName = THEME_NAMES[themeSelection];
        addItem(new WatchUi.MenuItem(
            THEME_LABEL,
            themeName,
            THEME_PROPERTY,
            null
        ));

    }

}


class PiechartTimeSettingsDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {

        var id = item.getId();
        
        if (id.equals(STANDARD_TIME_PROPERTY) && item instanceof WatchUi.ToggleMenuItem) {
            Properties.setValue(STANDARD_TIME_PROPERTY, item.isEnabled());
        }

        if (id.equals(LAYOUT_PROPERTY) && item instanceof WatchUi.MenuItem) {
            var currentLayout = PropertyUtils.getPropertyElseDefault(LAYOUT_PROPERTY, LAYOUT_DEFAULT);
            var newLayout = ((currentLayout - 1) % LAYOUT_NAMES.size()) + 2;
            Properties.setValue(LAYOUT_PROPERTY, newLayout);
            item.setSubLabel(LAYOUT_NAMES[newLayout - 1]);
        }

        if (id.equals(THEME_PROPERTY) && item instanceof WatchUi.MenuItem) {
            var currentTheme = PropertyUtils.getPropertyElseDefault(THEME_PROPERTY, THEME_DEFAULT);
            var newTheme = ((currentTheme - 1) % THEME_NAMES.size()) + 2;
            Properties.setValue(THEME_PROPERTY, newTheme);
            item.setSubLabel(THEME_NAMES[newTheme - 1]);
        }

    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

}
