# Parametric Propeller Generator V2
This is a heavily modified fork of BouncyMonkeys ['Parametric Multi-Blade Propellor Generator'](https://www.thingiverse.com/thing:3506692). It was created by Niels Odijk and Maarten van Schagen for a research project because we needed even more parameters.

## Printing
These propellers can be quite difficult to print because of how thin they are. So make sure the blades are strong enough by setting the infill high. And don't forget to use a low layer height to keep the surface as smooth as possible. It is also recommended to sand the blades with very fine-grit sandpaper for the best performance..
The trailing edge of the blades may be truncated by your slicer because it is to thin to print.

## Parameters
Customization is where this design shines. This propeller generator splits the propeller design up into many mathematical functions, allowing you to change everything about the design. But don't worry by default these functions are set by literal parameters to simplify and speed up the customization process.
The following parameters can be set by the user, don't worry if you don't understand everything, the default values should work quite well.
- Number of blades
- Blade Pitch (inches or mm)
- Pitch adjustment factors
- Propeller diameter (inches or mm)
- Number of sections calculated (resolution)
- Chord length (blade width)
- Blade Sweep (curves the blades)
- Blade Thickness
- Blade height at the tip
- Blade curvature up or down
- Centerline position on the chord (part of the airfoil)
- Airfoil profile
- Hub hole diameter
- Hub diameter
- Hub blade connection distance
- Hub cutout diameter and slope (connection point to motor)
- Hub sag
- Hub pins

## Functions
The formulas may also be edited directly. The user has access to the following functions, r = length of the centerline to point / total length of centerline :
- CenterlineAngle(r)  (deg, bladesweep)
- CenterlineOffset(r)  (mm)
- BladeThickness(r)  (mm)
- BladeHeight(r)  (mm)
- RolAngle(r)  (deg)
- ChordLength(r)  (mm, blade width)
- PitchAngle(r)  (deg)

## Shortcomings
If you are still missing any options, feel free to implement them yourself. The code is quite legible. But don't forget to share-alike.
Something I would personally love to see implemented is an auto-generated airfoil. It would allow for fine-tuning thickness and camber as a function of the position on the chord line.
