using Toybox.Graphics;
using Toybox.System;
using Toybox.WatchUi;

import Toybox.Lang;


//! Manages the loading, storage, and selection of ColorThemes.
//! Replaces the static ColorThemeLoader with a stateful picker.
class ColorThemePicker {

    // --- JSON Keys ---
    static const THEMES_KEY = "themes";
    static const COLORS_KEY = "colors";
    static const NAME_KEY = "name";
    
    static const HOURS_KEY = "hours";
    static const MINUTES_KEY = "minutes";
    static const SECONDS_KEY = "seconds";
    
    static const SLICE_KEY = "slice";
    static const OUTLINE_KEY = "outline";
    static const UNFILLED_KEY = "unfilled";
    
    static const DEFAULT_THEME_KEY = "default";

    // --- Fallback Defaults ---
    static const DEFAULT_THEME_NAME = "Monochrome";

    static const DEFAULT_HOUR_SLICE_COLOR = Graphics.COLOR_LT_GRAY;
    static const DEFAULT_HOUR_OUTLINE_COLOR = Graphics.COLOR_WHITE;
    
    static const DEFAULT_MINUTES_SLICE_COLOR = Graphics.COLOR_DK_GRAY;
    static const DEFAULT_MINUTES_OUTLINE_COLOR = Graphics.COLOR_LT_GRAY;
    
    static const DEFAULT_SECONDS_SLICE_COLOR = Graphics.COLOR_DK_GRAY;
    static const DEFAULT_SECONDS_OUTLINE_COLOR = Graphics.COLOR_DK_GRAY;
    
    static const DEFAULT_UNFILLED_COLOR = Graphics.COLOR_BLACK; // Default background

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

        // 3. Populate names list
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
        _updateCurrentIndex();
        return _currentIndex;
    }

    //! Returns the currently active ColorTheme
    function getCurrentTheme() as ColorTheme {
        _updateCurrentIndex();
        return _themes[_currentIndex];
    }

    //! Returns names of available themes (for building menus)
    function getThemeNames() as Array<String> {
        return _themeNames;
    }


    // --- Internal Logic ---

    //! Loads themes and parses the "default" key to set initial index
    private function loadFromResource() {
        try {
            var specification = WatchUi.loadResource(Rez.JsonData.ColorThemes) as Dictionary;

            // 1. Parse Themes List
            var themesList = specification[THEMES_KEY] as Array;
            for (var i = 0; i < themesList.size(); ++i) {
                var themeData = themesList[i] as Dictionary;
                var name = themeData[NAME_KEY] as String;
                
                var colors = themeData[COLORS_KEY] as Dictionary;
                var hourColors = colors[HOURS_KEY] as Dictionary;
                var minutesColors = colors[MINUTES_KEY] as Dictionary;
                var secondsColors = colors[SECONDS_KEY] as Dictionary;

                // Parse using specific helpers, defaulting to BLACK for unfilled if missing
                var theme = new ColorTheme(
                    name,
                    // Hours
                    {
                        :hourSlice => parseColor(hourColors[SLICE_KEY]),
                        :hourOutline => parseColor(hourColors[OUTLINE_KEY]),
                        :hourUnfilled => parseOptionalColor(hourColors, UNFILLED_KEY),
                    },
                    
                    // Minutes
                    {
                        :minutesSlice => parseColor(minutesColors[SLICE_KEY]),
                        :minutesOutline => parseColor(minutesColors[OUTLINE_KEY]),
                        :minutesUnfilled => parseColor(minutesColors[UNFILLED_KEY]),
                    },
                    // Seconds
                    {
                        :secondsSlice => parseColor(secondsColors[SLICE_KEY]),
                        :secondsOutline => parseColor(secondsColors[OUTLINE_KEY]),
                        :secondsUnfilled => parseColor(secondsColors[UNFILLED_KEY]),
                    }
                );
                _themes.add(theme);
            }

            // 2. Set Default Index based on JSON "default" key
            var defaultName = specification[DEFAULT_THEME_KEY] as String;
            for (var i = 0; i < _themes.size(); ++i) {
                if (_themes[i].name.equals(defaultName)) {
                    _currentIndex = i;
                    break;
                }
            }

        } catch (ex) {
            System.println("ThemePicker: Error loading themes - " + ex.getErrorMessage());
        }
    }

    //! Creates the hardcoded default theme
    private function createFallbackTheme() as ColorTheme {
        return new ColorTheme(
            DEFAULT_THEME_NAME,
            {
                :hourSlice => DEFAULT_HOUR_SLICE_COLOR,
                :hourOutline => DEFAULT_HOUR_OUTLINE_COLOR,
                :hourUnfilled => DEFAULT_UNFILLED_COLOR,
            },
            {
                :minutesSlice => DEFAULT_MINUTES_SLICE_COLOR,
                :minutesOutline => DEFAULT_MINUTES_OUTLINE_COLOR,
                :minutesUnfilled => DEFAULT_UNFILLED_COLOR,
            },
            {
                :secondsSlice => DEFAULT_SECONDS_SLICE_COLOR,
                :secondsOutline => DEFAULT_SECONDS_OUTLINE_COLOR,
                :secondsUnfilled => DEFAULT_UNFILLED_COLOR,
            }
        );
    }
    
    //! Helper: Parse optional color key. Returns DEFAULT_UNFILLED if missing.
    private function parseOptionalColor(dict as Dictionary, key as String) as Number {
        if (dict.hasKey(key)) {
            return parseColor(dict[key]);
        }
        return DEFAULT_UNFILLED_COLOR;
    }

    //! Helper: Parse hex string to Number
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

    private function _updateCurrentIndex() {
        _currentIndex = PropertyUtils.getPropertyElseDefault(THEME_PROPERTY, THEME_DEFAULT);
    }

}