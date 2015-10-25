[![Build Status](https://travis-ci.org/Blackjacx/PublicCodeLibrary.svg)](https://travis-ci.org/Blackjacx/PublicCodeLibrary)
[![License MIT](https://go-shields.herokuapp.com/license-MIT-blue.png)](http://opensource.org/licenses/MIT)
[![Version](http://cocoapod-badges.herokuapp.com/v/PublicCodeLibrary/badge.png)](http://cocoadocs.org/docsets/PublicCodeLibrary)
[![Platform](http://cocoapod-badges.herokuapp.com/p/PublicCodeLibrary/badge.png)](http://cocoadocs.org/docsets/PublicCodeLibrary)

# PublicCodeLibrary

An Xcode project to build a static library of my iOS library. You need to 
build for Simulator as well as for your favourite architecture and link all 
together to get a universal library.

The library simplifies daily development by providing useful and well 
documented code (e.g categories, wrapper classes, ...). Personally I use it as a learning resource too. It should be a persistent example of how realize code quality, documentation and other important points of software craftsmanship.

## Next Steps

- implement an AlertView with block action methods so one can create alert view and attached actions in one place
- implement a documentation building script
- enhance documentation (see [http://cocoadocs.org/docsets/PublicCodeLibrary](http://cocoadocs.org/docsets/PublicCodeLibrary) for a percentage view)
- use cocoapods to include 3rd party frameworks
- include Cocoa Lumberjack Logging Framework

## Changelog

### 1.0.1

- fixed warnings
- implemented method to find instances of a given class in a view hierarchy
- updated to more safe version of empty string detection that also finds empty strings
- updated project settings

### 1.0.0

- modified base64 methods to use the newly introduced ones in iOS7 (compatible with iOS4 and above) -> Is much shorter now!
- make it a CocoaPods project to support this really nice package manager
- give category methods "pcl_" prefix to easily find them with code completion in main project. Just type 'pcl' on any category class and the code completion will do the rest
- integrate unit test bundle to be able to test the library
- integrate the library into TravisCI - be able to run the tests on every commit (see [https://travis-ci.org/Blackjacx/PublicCodeLibrary](https://travis-ci.org/Blackjacx/PublicCodeLibrary))

## License

PublicCodeLibrary is licensed under the terms of the MIT License.
See the included LICENSE file.
