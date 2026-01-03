using Toybox.Application;
using Toybox.WatchUi;


class PiechartTimeApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
    }

    function onStop(state) {
    }

    function getInitialView() {
        return [ new PiechartTimeView() ];
    }

    function onSettingsChanged() as Void {
        WatchUi.requestUpdate();
    }

    function getSettingsView() {
        return [ new PiechartTimeSettingsMenu(), new PiechartTimeSettingsDelegate() ];
    }

}