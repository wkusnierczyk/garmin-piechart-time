using Toybox.Application.Properties;
using Toybox.WatchUi;

import Toybox.Lang;


class TimeSettingsMenu extends WatchUi.Menu2 {

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

        var multiOptionSelection = PropertyUtils.getPropertyElseDefault(MULTI_OPTION_PROPERTY, MULTI_OPTION_DEFAULT);
        var multiOptoinName = MULTI_OPTION_NAMES[multiOptionSelection];
        addItem(new WatchUi.MenuItem(
            MULTI_OPTION_LABEL, 
            multiOptoinName, 
            MULTI_OPTION_PROPERTY, 
            null
        ));

    }

}


class TimeSettingsDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {

        var id = item.getId();
        
        if (id.equals(STANDARD_TIME_PROPERTY) && item instanceof WatchUi.ToggleMenuItem) {
            Properties.setValue(STANDARD_TIME_PROPERTY, item.isEnabled());
        }

        if (id.equals(MULTI_OPTION_PROPERTY) && item instanceof WatchUi.MenuItem) {
            var currentOption = PropertyUtils.getPropertyElseDefault(MULTI_OPTION_PROPERTY, MULTI_OPTION_DEFAULT);
            var newOption = (currentOption % MULTI_OPTION_NAMES.size()) + 1;
            Properties.setValue(MULTI_OPTION_PROPERTY, newOption);
            item.setSubLabel(MULTI_OPTION_NAMES[newOption -1]);
        }

    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

}
