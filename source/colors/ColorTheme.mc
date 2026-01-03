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
    function initialize(
        name, 
        hourSlice, hourOutline, hourUnfilled,
        minutesSlice, minutesOutline, minutesUnfilled,
        secondsSlice, secondsOutline, secondsUnfilled
    ) {
        self.name = name;
        
        self.hourSlice = hourSlice;
        self.hourOutline = hourOutline;
        self.hourUnfilled = hourUnfilled;
        
        self.minutesSlice = minutesSlice;
        self.minutesOutline = minutesOutline;
        self.minutesUnfilled = minutesUnfilled;
        
        self.secondsSlice = secondsSlice;
        self.secondsOutline = secondsOutline;
        self.secondsUnfilled = secondsUnfilled;
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