// using Toybox.Graphics;

// import Toybox.WatchUi;
// import Toybox.Lang;
// import Toybox.System;


// //! Static helper to load themes from JSON into ColorTheme objects
// class ColorThemeLoader {

//     static const DEFAULT_THEME_KEY = "default";
//     static const THEMES_KEY = "themes";
//     static const COLORS_KEY = "colors";
//     static const NAME_KEY = "name";
//     static const SLICE_KEY = "slice";
//     static const OUTLINE_KEY = "outline";
//     static const HOURS_KEY = "hours";
//     static const MINUTES_KEY = "minutes";
//     static const SECONDS_KEY = "seconds";

//     static const DEFAULT_THEME_NAME = "Monochrome";
//     static const DEFAULT_HOUR_OUTLINE_COLOR = Graphics.COLOR_WHITE;
//     static const DEFAULT_MINUTE_OUTLINE_COLOR = Graphics.COLOR_WHITE;
//     static const DEFAULT_SECOND_OUTLINE_COLOR = Graphics.COLOR_LT_GRAY;
//     static const DEFAULT_HOUR_SLICE_COLOR = Graphics.COLOR_LT_GRAY;
//     static const DEFAULT_MINUTE_SLICE_COLOR = Graphics.COLOR_DK_GRAY;
//     static const DEFAULT_SECOND_SLICE_COLOR = Graphics.COLOR_DK_GRAY;


//     //! Loads all themes from Rez.JsonData.ColorThemes
//     //! @return [Array<ColorTheme>]
//     static function loadThemes() as Array<ColorTheme> {

//         var colorThemes = [] as Array<ColorTheme>;
        
//         try {
//             var specification = WatchUi.loadResource(Rez.JsonData.ColorThemes) as Dictionary;

//             var themes = specification[THEMES_KEY] as Array;
//             for (var i = 0; i < themes.size(); ++i) {
//                 var theme = themes[i] as Dictionary;
//                 var name = theme[NAME_KEY] as String;
//                 var colors = theme[COLORS_KEY] as Dictionary;
//                 var hourColors = colors[HOURS_KEY] as Dictionary;
//                 var hourSliceColor = parseColor(hourColors[SLICE_KEY]) as Number;
//                 var hourOutlineColor = parseColor(hourColors[OUTLINE_KEY]) as Number;
//                 var minutesColors = colors[MINUTES_KEY] as Dictionary;
//                 var minutesSliceColor = parseColor(minutesColors[SLICE_KEY]) as Number;
//                 var minutesOutlineColor = parseColor(minutesColors[OUTLINE_KEY]) as Number;
//                 var secondsColors = colors[SECONDS_KEY] as Dictionary;
//                 var secondsSliceColor = parseColor(secondsColors[SLICE_KEY]) as Number;
//                 var secondsOutlineColor = parseColor(secondsColors[OUTLINE_KEY]) as Number;
                
//                 var colorTheme = new ColorTheme(name,
//                                                 hourSliceColor, hourOutlineColor,
//                                                 minutesSliceColor, minutesOutlineColor,
//                                                 secondsSliceColor, secondsOutlineColor);
                
//                 colorThemes.add(colorTheme);
//             }

//         } catch (ex) {
//             System.println("Error loading themes: " + ex.getErrorMessage());
//         }
        
//         return colorThemes;

//     }

//     static function getDefaultColorTheme() as ColorTheme {
//         return new ColorTheme(DEFAULT_THEME_NAME,
//                               DEFAULT_HOUR_SLICE_COLOR, DEFAULT_HOUR_OUTLINE_COLOR,
//                               DEFAULT_MINUTE_SLICE_COLOR, DEFAULT_MINUTE_OUTLINE_COLOR,
//                               DEFAULT_SECOND_SLICE_COLOR, DEFAULT_SECOND_OUTLINE_COLOR);
//     }

//     //! Helper: Parse hex string to Number
//     static function parseColor(hexString as String) as Number {

//         var valueOf = {
//             '0' => 0,
//             '1' => 1,
//             '2' => 2,
//             '3' => 3,
//             '4' => 4,
//             '5' => 5,
//             '6' => 6,
//             '7' => 7,
//             '8' => 8,
//             '9' => 9,
//             'A' => 10,
//             'B' => 11,
//             'C' => 12,
//             'D' => 13,
//             'E' => 14,
//             'F' => 15,
//             'a' => 10,
//             'b' => 11,
//             'c' => 12,
//             'd' => 13,
//             'e' => 14,
//             'f' => 15
//         };

//         var number = 0;
//         var characters = hexString.toCharArray();
        
//         for (var i = 0; i < characters.size(); ++i) {
//             var character = characters[i];
//             var value = 0;
//             if ((character >= '0' && character <= '9')
//                 or (character >= 'A' && character <= 'F')
//                 or (character >= 'a' && character <= 'f')) {
//                 value = valueOf[character];
//             }
//             number = (number * 16) + value;
//         }
        
//         return number;

//     }

// }