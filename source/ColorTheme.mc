import Toybox.Lang;


//! Data container for a complete chart color scheme
class ColorTheme {

    public var name as String;
    
    // Using public vars for simple data access objects (DAO)
    public var hourSlice as Number;
    public var hourOutline as Number;
    
    public var minutesSlice as Number;
    public var minutesOutline as Number;
    
    public var secondsSlice as Number;
    public var secondsOutline as Number;

    function initialize(
        _name, 
        _hSlice, _hOutline, 
        _mSlice, _mOutline, 
        _sSlice, _sOutline
    ) {
        name = _name;
        hourSlice = _hSlice;
        hourOutline = _hOutline;
        minutesSlice = _mSlice;
        minutesOutline = _mOutline;
        secondsSlice = _sSlice;
        secondsOutline = _sOutline;
    }
    
}