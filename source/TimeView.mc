using Toybox.Application.Properties;
using Toybox.Graphics;
using Toybox.WatchUi;

import Toybox.Lang;


class TimeView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    function onShow() {
    }

    function onUpdate(dc) {

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());

        var clockTime = System.getClockTime();

        var hour = clockTime.hour;
        var minutes = clockTime.min;
        var seconds = clockTime.sec;

        _drawStandardTime(null, hour, minutes, seconds);
        View.onUpdate(dc);

    }

    private function _drawStandardTime(dc as Graphics.Dc or Null, hour as Number, minutes as Number, seconds as Number) {
        var standardTimeEnabled = PropertyUtils.getPropertyElseDefault(STANDARD_TIME_PROPERTY, STANDARD_TIME_MODE_DEFAULT);
        if (standardTimeEnabled) {
            var standardTime = Lang.format("$1$:$2$:$3$", [
                hour.format("%d"),
                minutes.format("%02d"),
                seconds.format("%02d")
            ]);
            var standardTimeView = View.findDrawableById(STANDARD_TIME_LAYOUT_ID) as WatchUi.Text;
            standardTimeView.setText(standardTime);
        }
    }

}