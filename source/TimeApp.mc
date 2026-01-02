using Toybox.Application;
using Toybox.WatchUi;


class TimeApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
    }

    function onStop(state) {
    }

    function getInitialView() {
        return [ new TimeView() ];
    }

    function onSettingsChanged() as Void {
        WatchUi.requestUpdate();
    }

    function getSettingsView() {
        return [ new TimeSettingsMenu(), new TimeSettingsDelegate() ];
    }

}