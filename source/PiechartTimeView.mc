using Toybox.Application.Properties;
using Toybox.Graphics;
using Toybox.WatchUi;

import Toybox.Lang;


class PiechartTimeView extends WatchUi.WatchFace {

    private var _piechartTime as PiechartTime;

    function initialize() {
        WatchFace.initialize();
        _piechartTime = new PiechartTime();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
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

        var showSeconds = PropertyUtils.getPropertyElseDefault(SHOW_SECONDS_PROPERTY, SHOW_SECONDS_MODE_DEFAULT);

        _piechartTime
            .showSeconds(showSeconds)
            .draw(dc);

    }

    private function _drawStandardTime(dc as Graphics.Dc or Null, hour as Number, minutes as Number, seconds as Number) {
        var standardTimeEnabled = PropertyUtils.getPropertyElseDefault(STANDARD_TIME_PROPERTY, STANDARD_TIME_MODE_DEFAULT);
        var standardTimeView = View.findDrawableById(STANDARD_TIME_LAYOUT_ID) as WatchUi.Text;
        if (standardTimeEnabled) {
            var standardTime = Lang.format("$1$:$2$:$3$", [
                hour.format("%d"),
                minutes.format("%02d"),
                seconds.format("%02d")
            ]);
            standardTimeView.setText(standardTime);
        } else {
            standardTimeView.setText("");
        }
    }

}