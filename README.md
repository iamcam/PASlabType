#PASlabType

PASlabType is a stripped-down and built-up port of Eric Loyer's [SlabType algorithm][1] for ActionScript and @freqdec's [slabText jQuery plugin][2]

[1]: http://erikloyer.com/index.php/blog/the_slabtype_algorithm_part_1_background/                         
[2]: https://github.com/freqdec/slabText

##Requirements & Installation
+ Add CoreText.framework to your project's Build Phases (Link Binary With Libraries)
+ Add the postscript (usually) names of the fonts you're using in the project to the project's plist file (See the demo)
+ Add fonts to the app's Target (Build Phases -> Copy Bundle Resources)
+ reference the PASlabType.h file in your controller's header

