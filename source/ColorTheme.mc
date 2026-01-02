import Toybox.Lang;

//! Data container for a complete chart color scheme
class ColorTheme {

    public var name as String;
    
    // Using public vars for simple data access objects (DAO)
    
    // -- Hours --
    public var hourSlice as Number;
    public var hourOutline as Number;
    public var hourUnfilled as Number; // New
    
    // -- Minutes --
    public var minutesSlice as Number;
    public var minutesOutline as Number;
    public var minutesUnfilled as Number; // New
    
    // -- Seconds --
    public var secondsSlice as Number;
    public var secondsOutline as Number;
    public var secondsUnfilled as Number; // New

    //! Constructor
    function initialize(
        _name, 
        _hSlice, _hOutline, _hUnfilled,
        _mSlice, _mOutline, _mUnfilled,
        _sSlice, _sOutline, _sUnfilled
    ) {
        name = _name;
        
        hourSlice = _hSlice;
        hourOutline = _hOutline;
        hourUnfilled = _hUnfilled;
        
        minutesSlice = _mSlice;
        minutesOutline = _mOutline;
        minutesUnfilled = _mUnfilled;
        
        secondsSlice = _sSlice;
        secondsOutline = _sOutline;
        secondsUnfilled = _sUnfilled;
    }
}