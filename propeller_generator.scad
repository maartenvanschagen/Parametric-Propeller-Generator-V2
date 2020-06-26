// Cted by Hamish Trolove - Feb 2019
//www.techmonkeybusiness.com

// Heavily modified by Maarten van Schagen and Niels Odijk - Nov 2019 + Jun 2020

//Licensed under a Creative Commons license - attribution
// share alike. CC-BY-SA

//Airfoils:
// Points from naca4412.dat in the But dow archive: http://m-selig.ae.illinois.edu/ads/archives/coord_seligFmt.tar.gz
// Not necessarily in the same order as in: http://m-selig.ae.illinois.edu/ads/coord/naca4412.dat


//////////////////////////////////////////////////////
//////////////  CUSTOMIZABLE OPTIONS  ////////////////
//////////////////////////////////////////////////////

// * = formula adjustable below (which means, the value is adjustable for each calculated slice of the blade)
// ** = advanced formula


////////////////////
/*    [Blades]    */
////////////////////

//Rotation  --  1 is clockwise, 0 is counterclockwise
Clockwise = 1; // [0:false, 1:true]

//Number of blades
BladeNumber = 3;

//pitch* (inches)
PitchInches = 3;

//diameter (inches)
DiameterInches = 5;

//pitch* (mm)  --  Leave zero to use inches
PitchMM = 0;

//diameter (mm)  --  Leave zero to use inches
DiameterMM = 0;

//Number of sections calculated along the blade  -  Sets resolution
Sections = 50;

//Pitch adjustment factor hub end*
PitchAdjustmentHub = 1;

//Pitch adjustment factor tip end*
PitchAdjustmentTip = 1;

//Maximum chord length* (mm)  =  Blade width
MaxChordLength = 15;

//Blade sweep at the tip** (deg)  -  -90 < value < 90
BladeSweepFinalAngle = 20;

//Blade thickness* (factor)
ThicknessFactor = 1;

//Height of blade tip* (mm)  -  can be negative
BladeTipHeight = 3;

//Blade curvature in z direction*  -  Curve shape: z = x^BladeCurveHeight
BladeCurveHeight = 1.5;  

//Position of blade centerline on chord (%)  -  You can see the effects best when bladesweep is set to zero
CenterlinePosition = 35;

//Blade airfoil profile
AirfoilPoints = [[1000,1.3],[950,14.7],[900,27.1],[800,48.9],[700,66.9],[600,81.4],[500,91.9],[400,98],[300,97.6],[250,94.1],[200,88],[150,78.9],[100,65.9],[75,57.6],[50,47.3],[25,33.9],[12.5,24.4],[0,0],[12.5,-14.3],[25,-19.5],[50,-24.9],[75,-27.4],[100,-28.6],[150,-28.8],[200,-27.4],[250,-25],[300,-22.6],[400,-18],[500,-14],[600,-10],[700,-6.5],[800,-3.9],[900,-2.2],[950,-1.6],[1000,-1.3]];  //(naca4412 design)
/* IGNORE ME */ AirfoilWidth = max([for(i=AirfoilPoints) i[0]]) - min([for(i=AirfoilPoints) i[0]]);
/* IGNORE ME */ AirfoilHeight = max([for(i=AirfoilPoints) i[1]]) - min([for(i=AirfoilPoints) i[1]]);

/* IGNORE ME */ Pitch = (PitchMM > 0)? (PitchMM):(PitchInches * 25.4);  //Turn pitch values into metric
/* IGNORE ME */ Diameter = (DiameterMM > 0)? (DiameterMM):(DiameterInches * 25.4);  //Turn pitch values into metric


////////////////////
/*     [Hub]      */
////////////////////

//Screw hole diameter (mm)
HubScrewHoleDiameter = 5;

//Hub circle diameter (mm)
HubDiameter = 12;

//Blade connection distance from center (mm)
BladeConnectionDistance = 15;

//Imaginary diameter for guiding hub cone cutting angle (mm)  -  This number should be larger then HubDiameter
HubCutoutDiameter = 20;

//Thickness of the hub (mm)
HubThickness = 5;

//Sag the hub down (mm)
HubSag = 0;

//Diameter of hub pins (mm)  -  Set zero to disable
HubPinDiameter = 0;

//Pitch circle diameter of hub pins (mm)  -  Set zero to disable
HubPinPitchCircleDiameter = 0;



//////////////////////////////////////////////////////
//////////  CUSTOMIZABLE FORMULAS advanced ///////////
//////////////////////////////////////////////////////

//  The formulas below are calculated for every slice of the blade
//  r = length of centerline to point / total length of centerline
//  Diameter = User defined propeller diameter
//  Pitch = User defined propeller pirch


//Function for slope of the centerline (Bladesweep, section yaw)
function CenterlineAngle(r) = BladeSweepFinalAngle*r; // Should be in sync with CenterlineDistance(r)

//Function for distance from the centerline
function CenterlineOffset(r) = BladeSweepFinalAngle != 0 ? -(ln(cos(BladeSweepFinalAngle*r)))/(BladeSweepFinalAngle*PI/180) : 0;  // Is integral of tan(CenterlineAngle(r))

/* IGNORE ME */ CenterlineLength = sqrt(pow(.5*Diameter, 2) / (pow(0.5 * CenterlineOffset(1),2)+.25))/2;

//////////////////////////////////////////////////////
///////////  CUSTOMIZABLE FORMULAS simple ////////////
//////////////////////////////////////////////////////

//  The formulas below are calculated for every slice of the blade
//  r = length of centerline to point / total length of centerline
//  CenterlineLength = Total centerline length = (radius when bladesweep = 0)
//  Pitch = User defined propeller pitch
//  AirfoilWidth = Width of unscaled airfoil shape
//  AirfoilHeight = Height of unscaled airfoil shape
//  
//  To calculate total length of the centerline to a point use r * CenterlineLength


//Blade thickness (mm)
function BladeThickness(r) = ThicknessFactor * AirfoilHeight * (ChordLength(r)/AirfoilWidth); //Set height based on ChordLength and airfoil designed scaled by the ThicknessFactor

//Height of blade (mm)  //Make sure it goes through (0, 0) to connect it to the hub
function BladeHeight(r) = BladeTipHeight * pow(r, BladeCurveHeight) / CenterlineLength; // Should be in sync with CenterlineDistance(r)

//Blade rol angle (deg) = angle upwards or downwards //This has a very small effect, make this zero if you're not sure how to use this
function RolAngle(r) = atan(BladeTipHeight/CenterlineLength * BladeCurveHeight * pow(r, BladeCurveHeight - 1)); // atan(Derivative of BladeHeight(r))

//The following blade width shape is a function taken from an existing blade.
//It defines the centercord length (mm) (blade width)
function ChordLength(r) = (1.392*pow(r,4) -1.570*pow(r,3)-2.46*pow(r,2)+3.012*r+0.215) * MaxChordLength;

//Function to adjust the pitch angle to match manufactured blades (which are flatter), this function is only used in BladeAngle(r), so you can delete this function if you wish to edit PitchAngle(r) instead
function PitchAngleAdjustment(r) = (PitchAdjustmentTip-PitchAdjustmentHub)/CenterlineLength*r+PitchAdjustmentHub;

//Blade pitch (deg)
function PitchAngle(r) = atan(Pitch/(2*PI*r*CenterlineLength)) * PitchAngleAdjustment(r);



//The following variable is used as a message that is displayed in the customizer
//Want to customize the formulas used to indicate the shape? You can edit these in the source OpenSCAD code!
//CustomizeFormulas = 0;

//////////////////////////////////////////////////////
/////////////////  PROPELLER DESIGN  /////////////////
//////////////////////////////////////////////////////

// If you want to change the propeller, try editing the modules BladeSlice(r) or Blade()
mergeSlices = true; //Enable or disable merging of slices (helpfull for debugging, set to true for standard renders)

SectionLength =  CenterlineLength/Sections;  //Length of each section

module Hub()
{
    hull() // Attach hull cilinder to blade slice for extra strength
    {
        translate([0,0,-HubSag])cylinder (r = HubDiameter/2, h = HubThickness, center = true, $fn = 100);
       rotate([90,0,0])BladeSlice(BladeConnectionDistance/2 / CenterlineLength);
    }
}

module Hubcutout()
{
    union()
    {
        //Main cutting shape
        cylinder (r = HubScrewHoleDiameter/2, h = HubThickness*10, center = true, $fn = 100);
        translate([0,0,-1.5*HubThickness])cylinder (r2 = HubDiameter/2, r1 = HubCutoutDiameter/2, h = 2*HubThickness, center = true, $fn = 100);
        
        //Pins (if enabled)
        if(HubPinDiameter > 0 && HubPinPitchCircleDiameter > 0)
        {
            translate([0.5*HubPinPitchCircleDiameter,0,0])cylinder(r = 0.5*HubPinDiameter, h = HubThickness*3, center = true, $fn = 100);
            translate([-0.5*HubPinPitchCircleDiameter,0,0])cylinder(r = 0.5*HubPinDiameter, h = HubThickness*3, center = true, $fn = 100);
        }
    }
}

module BladeSlice(r)
{
    PitchAngle = PitchAngle(r);
    ChordLength = ChordLength(r); //Width of blade
    CenterlineAngle = CenterlineAngle(r); //Yaw angle
    Height = BladeHeight(r) * CenterlineLength;
    RolAngle = RolAngle(r);
    CenterlineOffset = CenterlineOffset(r) * CenterlineLength;
    BladeThickness = BladeThickness(r);
    Offset = r*CenterlineLength;
    
    translate([CenterlineOffset, Height, Offset])
    rotate([-RolAngle, CenterlineAngle, -PitchAngle])
    linear_extrude(height=0.00000001, slices = 0)  //Turn into 3d object so we can move and rotate it in 3d
    translate([-CenterlinePosition/100*ChordLength,0])  //Set the centerline in the correct position
    scale([ChordLength/AirfoilWidth, BladeThickness/AirfoilHeight]) //Scale to correct width and height (CentercordLength and BladeThickness are set in mm)
        polygon(points=AirfoilPoints); 
}

module Blade()
{
    union()
    {
    for(i = [0:Sections-1])
        {
            if(mergeSlices){
                //For standard renders
                hull(){ //hull the blade slices to fill space in between
                    BladeSlice(i*SectionLength/CenterlineLength);     //Section start
                    BladeSlice((i+1)*SectionLength/CenterlineLength); //Section end
                }
            }else{
                //For debugging
                union(){ //union the blade slices to keep open space in between
                    BladeSlice(i*SectionLength/CenterlineLength);     //Section start
                    BladeSlice((i+1)*SectionLength/CenterlineLength); //Section end
                }
            }
        }
    }
}

// Main object
module main(){
    difference()
    {
        union()
        {
            for(i = [0:BladeNumber-1])
            {
                rotate([90,0,i*360/BladeNumber])Blade();
                rotate([0,0,i*360/BladeNumber])Hub();
                //A hub piece is generated for each blade, but they are all merged
            }
        }
        Hubcutout();
    }
}


//Start drawing, mirror if needed
if(!Clockwise){
    mirror([1, 0, 0])main();
}else{
    main();
}
