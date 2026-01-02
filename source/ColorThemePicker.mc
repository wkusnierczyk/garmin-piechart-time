using Toybox.Graphics;

import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.System;


//! Manages the loading, storage, and selection of ColorThemes.
//! Replaces the static ColorThemeLoader with a stateful picker.
class ColorThemePicker {

    // --- JSON Keys ---
    static const DEFAULT_THEME_KEY = "default";
    static const THEMES_KEY = "themes";
    static const COLORS_KEY = "colors";
    static const NAME_KEY = "name";
    static const SLICE_KEY = "slice";
    static const OUTLINE_KEY = "outline";
    static const HOURS_KEY = "hours";
    static const MINUTES_KEY = "minutes";
    static const SECONDS_KEY = "seconds";


    // --- Fallback Defaults ---
    static const DEFAULT_THEME_NAME = "Monochrome";

    static const DEFAULT_HOUR_SLICE_COLOR = Graphics.COLOR_WHITE;
    static const DEFAULT_HOUR_OUTLINE_COLOR = Graphics.COLOR_WHITE;

    static const DEFAULT_MINUTE_SLICE_COLOR = Graphics.COLOR_LT_GRAY;
    static const DEFAULT_MINUTE_OUTLINE_COLOR = Graphics.COLOR_LT_GRAY;

    static const DEFAULT_SECOND_SLICE_COLOR = Graphics.COLOR_DK_GRAY;
    static const DEFAULT_SECOND_OUTLINE_COLOR = Graphics.COLOR_DK_GRAY;


    // --- State ---
    private var _themes as Array<ColorTheme>;
    private var _themeNames as Array<String>;
    private var _currentIndex as Number;

    // --- Initialization ---
    function initialize() {
        _themes = [];
        _themeNames = [];
        _currentIndex = 0;

        // 1. Load from JSON
        loadFromResource();

        // 2. Safety Fallback: If no themes loaded, create the default one
        if (_themes.size() == 0) {
            var defaultTheme = createFallbackTheme();
            _themes.add(defaultTheme);
            _currentIndex = 0;
        }

        // TODO
        for (var i = 0; i < _themes.size(); ++i) {
            _themeNames.add(_themes[i].name);
        }

    }

    // --- Public API ---

    function size() as Number {
        return _themes.size();
    }

    //! Returns the current index (useful for saving settings)
    function getCurrentIndex() as Number {
        return _currentIndex;
    }

    //! Returns the currently active ColorTheme
    function getCurrentTheme() as ColorTheme {
        return _themes[_currentIndex];
    }

    //! Returns names of available themes (for building menus)
    function getThemeNames() as Array<String> {
        return _themeNames;
    }

    //! Sets the current theme by index (e.g. from User Settings)
    //! @param index [Number] The new index
    //! @return [Boolean] true if index changed, false if invalid
    function setIndex(index as Number) as Boolean {
        if (index >= 0 && index < _themes.size()) {
            _currentIndex = index;
            return true;
        }
        return false;
    }

    // --- Internal Logic ---

    //! Loads themes and parses the "default" key to set initial index
    private function loadFromResource() {

        var themes = [];
        var currentIndex = 0;

        try {
            var specification = WatchUi.loadResource(Rez.JsonData.ColorThemes) as Dictionary;
            // TODO
            // if (specification == null) { return; }

            // 1. Parse Themes List
            var themesList = specification[THEMES_KEY] as Array;
            for (var i = 0; i < themesList.size(); ++i) {
                var themeData = themesList[i] as Dictionary;
                var name = themeData[NAME_KEY] as String;
                
                var colors = themeData[COLORS_KEY] as Dictionary;
                var hourColors = colors[HOURS_KEY] as Dictionary;
                var minutesColors = colors[MINUTES_KEY] as Dictionary;
                var secondsColors = colors[SECONDS_KEY] as Dictionary;

                // Parse using your specific helper implementation
                var theme = new ColorTheme(
                    name,
                    parseColor(hourColors[SLICE_KEY]),
                    parseColor(hourColors[OUTLINE_KEY]),
                    parseColor(minutesColors[SLICE_KEY]),
                    parseColor(minutesColors[OUTLINE_KEY]),
                    parseColor(secondsColors[SLICE_KEY]),
                    parseColor(secondsColors[OUTLINE_KEY])
                );
                themes.add(theme);
            }

            // 2. Set Default Index based on JSON "default" key
            // Look for "default": "ThemeName" in the JSON root
            var defaultName = specification[DEFAULT_THEME_KEY] as String;
            if (defaultName != null) {
                for (var i = 0; i < themes.size(); ++i) {
                    if (themes[i].name.equals(defaultName)) {
                        currentIndex = i;
                        break;
                    }
                }
            }

        } catch (ex) {
            System.println("ThemePicker: Error loading themes - " + ex.getErrorMessage());
        }
        _themes = themes;
        _currentIndex = currentIndex;

    }

    //! Creates the hardcoded default theme
    private function createFallbackTheme() as ColorTheme {
        return new ColorTheme(
            DEFAULT_THEME_NAME,
            DEFAULT_HOUR_SLICE_COLOR, DEFAULT_HOUR_OUTLINE_COLOR,
            DEFAULT_MINUTE_SLICE_COLOR, DEFAULT_MINUTE_OUTLINE_COLOR,
            DEFAULT_SECOND_SLICE_COLOR, DEFAULT_SECOND_OUTLINE_COLOR
        );
    }

    //! Helper: Parse hex string to Number using your specific logic
    private function parseColor(hexString as String) as Number {
        var valueOf = {
            '0' => 0, '1' => 1, '2' => 2, '3' => 3, '4' => 4,
            '5' => 5, '6' => 6, '7' => 7, '8' => 8, '9' => 9,
            'A' => 10, 'B' => 11, 'C' => 12, 'D' => 13, 'E' => 14, 'F' => 15,
            'a' => 10, 'b' => 11, 'c' => 12, 'd' => 13, 'e' => 14, 'f' => 15
        };

        var number = 0;
        var characters = hexString.toCharArray();
        
        for (var i = 0; i < characters.size(); ++i) {
            var character = characters[i];
            var value = 0;
            if ((character >= '0' && character <= '9')
                or (character >= 'A' && character <= 'F')
                or (character >= 'a' && character <= 'f')) {
                value = valueOf[character];
            }
            number = (number * 16) + value;
        }
        
        return number;
    }

}