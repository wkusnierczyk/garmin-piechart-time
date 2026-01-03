import Toybox.Lang;

//! Data container for a complete chart color scheme
class ColorTheme {

    public var name as String;
    
    // Using public vars for simple data access objects (DAO)
    
    // -- Hours --
    public var hourSlice as Number;
    public var hourOutline as Number;
    public var hourUnfilled as Number; 
    
    // -- Minutes --
    public var minutesSlice as Number;
    public var minutesOutline as Number;
    public var minutesUnfilled as Number;
    
    // -- Seconds --
    public var secondsSlice as Number;
    public var secondsOutline as Number;
    public var secondsUnfilled as Number;

    //! Constructor
    function initialize(name, hourColors as Dictionary, minutesColors as Dictionary, secondsColors as Dictionary) {

        self.name = name;

        self.hourSlice = hourColors[:hourSlice];
        self.hourOutline = hourColors[:hourOutline];
        self.hourUnfilled = hourColors[:hourUnfilled];
        
        self.minutesSlice = minutesColors[:minutesSlice];
        self.minutesOutline = minutesColors[:minutesOutline];
        self.minutesUnfilled = minutesColors[:minutesUnfilled];
        
        self.secondsSlice = secondsColors[:secondsSlice];
        self.secondsOutline = secondsColors[:secondsOutline];
        self.secondsUnfilled = secondsColors[:secondsUnfilled];
    }

    function apply(hour as Piechart, minutes as Piechart, seconds as Piechart) {
        hour
            .withSliceColor(hourSlice)
            .withOutlineColor(hourOutline)
            .withUnfilledColor(hourUnfilled);
        minutes
            .withSliceColor(minutesSlice)
            .withOutlineColor(minutesOutline)
            .withUnfilledColor(minutesUnfilled);
        seconds
            .withSliceColor(secondsSlice)
            .withOutlineColor(secondsOutline)
            .withUnfilledColor(secondsUnfilled);
    }

}