import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;

//! Abstract Base Strategy for Piechart layouts
class PiechartTimeLayout {
    
    //! Applies the layout logic to the provided charts.
    //! @param hours [Piechart]
    //! @param minutes [Piechart]
    //! @param seconds [Piechart]
    //! @param showSeconds [Boolean] Whether seconds are enabled
    function apply(hours, minutes, seconds, showSeconds) {
        // To be overridden by subclasses
    }

    //! Provides a list of instances of available specialized layouts.
    //! @return [Array<PiechartTimeLayout>] List of instantiated available layouts.
    static function getLayouts() as Array<PiechartTimeLayout> {
        return [
            new PiechartTimeConcentricLayout(),
            new PiechartTimeHorizontalLayout(),
            new PiechartTimeStackedLayout(),
            new PiechartTimeDiminishingLayout()
        ];
    }
}
