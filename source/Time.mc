using Toybox.Application;

import Toybox.Lang;


module Time {

    function formatTime(hour as Number, minutes as Number, base as Number) as Dictionary<Object, String> {
        return {
            :hour => "", 
            :minutes => "",
            :seconds => ""        
        };
    }

}
