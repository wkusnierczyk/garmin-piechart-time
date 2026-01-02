using Toybox.Application;
using Toybox.Test;

import Toybox.Lang;


const TEST_NAME = "name";
const TEST_INPUT = "input";
const TEST_INPUT_HOUR = "hour";
const TEST_INPUT_MINUTES = "minutes";
const TEST_INPUT_SECONDS = "seconds";
const TEST_EXPECTED = "expected";
const TEST_ERROR_TEMPLATE = "Test '$1$' failed: expected '$2$', got '$3$'";


(:test)
function testTime(logger) as Boolean {

    var pass = true;

    var tests = Application.loadResource(Rez.JsonData.BaseTimeTests) as Array<Dictionary>;
    for (var i = 0; i < tests.size(); ++i) {

        var test = tests[i];
        var name = test[TEST_NAME] as String;
        
        var input = test[TEST_INPUT] as Dictionary<String, Number>;
        var inputHour = input[TEST_INPUT_HOUR] as Number;
        var inputMinutes = input[TEST_INPUT_MINUTES] as Number;
        var inputSeconds = input[TEST_INPUT_SECONDS] as Number;
        
        var expected = test[TEST_EXPECTED] as Dictionary<String, String;
        var expectedHour = expected[TEST_INPUT_HOUR] as String;
        var expectedMinutes = expected[TEST_INPUT_MINUTES] as String;
        var expectedSeconds = expected[TEST_INPUT_SECONDS] as String;

        var actual = PiechartTime.formatTime(inputHour, inputMinutes, inputSeconds) as Dictionary<Object, String>;
        
        var actualHour = actual[:hour] as String;
        if (!actualHour.equals(expectedHour)) {
            var message = Lang.format(TEST_ERROR_TEMPLATE, [name, expectedHour, actualHour]);
            logger.error(message);
            pass = false;
        }

        var actualMinutes = actual[:minutes] as String;
        if (!actualMinutes.equals(expectedMinutes)) {
            var message = Lang.format(TEST_ERROR_TEMPLATE, [name, expectedMinutes, actualMinutes]);
            logger.error(message);
            pass = false;
        }

        var actualSeconds = actual[:seconds] as String;
        if (!actualSeconds.equals(expectedSeconds)) {
            var message = Lang.format(TEST_ERROR_TEMPLATE, [name, expectedSeconds, actualSeconds]);
            logger.error(message);
            pass = false;
        }

    }

    return pass;

}
