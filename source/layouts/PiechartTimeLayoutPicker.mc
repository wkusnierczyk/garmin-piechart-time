import Toybox.Lang;

class PiechartTimeLayoutPicker {

    private var _layouts as Array<PiechartTimeLayout>;
    private var _currentIndex as Number;

    //! Constructor
    function initialize() {
        // Instantiate all available layouts once
        _layouts = PiechartTimeLayout.getLayouts();
        
        // Default to the first layout (Concentric)
        _currentIndex = 0;
    }

    //! Sets the current layout by index (e.g. from Property/Menu)
    //! @param index [Number] The index of the selected layout
    //! @return [PiechartTimeLayoutPicker] self for chaining
    function setIndex(index as Number) as PiechartTimeLayoutPicker {
        if (index >= 0 && index < _layouts.size()) {
            _currentIndex = index;
        } else {
            // Safety fallback
            _currentIndex = 0; 
        }
        return self;
    }

    //! Returns the currently selected layout strategy
    //! @return [PiechartTimeLayout] The active layout instance
    function getCurrentLayout() as PiechartTimeLayout {
        _currentIndex = PropertyUtils.getPropertyElseDefault(LAYOUT_PROPERTY, LAYOUT_DEFAULT);
        return _layouts[_currentIndex];
    }
    
    //! Helper to get the total number of layouts (useful for menu ranges)
    function getCount() as Number {
        return _layouts.size();
    }
}