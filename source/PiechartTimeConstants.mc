using Toybox.Application;
using Toybox.Graphics;

import Toybox.Lang;


// Colors
const HOUR_COLOR = Graphics.COLOR_WHITE;
const MINUTES_COLOR = Graphics.COLOR_LT_GRAY;
const SECONDS_COLOR = Graphics.COLOR_DK_GRAY;


// Time rendering
const MAX_HOURS = 23;
const MAX_MINUTES = 59;


// Layouts (only for standard time, which is fixed; base time layout is dynamic, depending on the base)
const STANDARD_TIME_LAYOUT_ID = "StandardTimeLayout";


// Fonts
const HOUR_FONT = Application.loadResource(Rez.Fonts.HourFont);
const MINUTES_FONT = Application.loadResource(Rez.Fonts.MinutesFont);
const SECONDS_FONT = Application.loadResource(Rez.Fonts.SecondsFont);


// Settings
const CUSTOMIZE_MENU_TITLE = Application.loadResource(Rez.Strings.Time);

const STANDARD_TIME_LABEL = Application.loadResource(Rez.Strings.StandardTimeMenuTitle);
const STANDARD_TIME_PROPERTY = "ShowStandardTime";
const STANDARD_TIME_MODE_DEFAULT = true;

const MULTI_OPTION_LABEL = Application.loadResource(Rez.Strings.MultiOptionMenuTitle);
const MULTI_OPTION_PROPERTY = "MultiOption";
const MULTI_OPTION_DEFAULT = 1;

const MULTI_OPTION_NAMES = Application.loadResource(Rez.JsonData.MultiOptionValues) as Array<String>;
