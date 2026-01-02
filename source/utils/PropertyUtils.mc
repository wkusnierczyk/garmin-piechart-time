using Toybox.Application.Properties;

import Toybox.Lang;


module PropertyUtils {

    function getPropertyElseDefault(propertyName as String, defaultValue) {
        var value;
        try {
            value = Properties.getValue(propertyName);
            if (value == null) {
                value = defaultValue;
            }
        } catch (e) {
            value = defaultValue;
        }
        return value;
    }

}