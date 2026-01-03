import Toybox.Lang;
import Toybox.Graphics;

//! Shared Mock Object for Unit Tests.
//! Inherits from Piechart to satisfy type checking in method signatures.
class MockPiechart extends Piechart {

    // --- State for Color Tests ---
    public var lastSliceColor = null;
    public var lastOutlineColor = null;
    public var lastUnfilledColor = null;

    // --- State for Layout Tests ---
    public var x = 0;
    public var y = 0;
    public var r = 0;
    public var outlineThickness = 0;

    function initialize() {
        Piechart.initialize(); 
    }

    // --- Color Setters (Theme Tests) ---

    function withSliceColor(color) as Piechart {
        lastSliceColor = color;
        return self; 
    }

    function withOutlineColor(color) as Piechart {
        lastOutlineColor = color;
        return self;
    }

    function withUnfilledColor(color) as Piechart {
        lastUnfilledColor = color;
        return self;
    }

    // --- Geometry Setters (Layout Tests) ---

    function withCenter(cx, cy) as Piechart {
        x = cx; 
        y = cy;
        return self; 
    }

    function withRadius(rad) as Piechart {
        r = rad;
        return self;
    }

    function withOutlineThickness(th) as Piechart {
        outlineThickness = th;
        return self;
    }
}