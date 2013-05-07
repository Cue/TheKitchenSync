# CueConcurrency Installation

There are three ways to integrate CueConcurrency into your project:
* Use [Cocoapods](http://cocoapods.org/)
* Import CueConcurrency.xcodeproj
* Pick and choose the files you need.

### Cocoapods
If you're already using Cocoapods then this will be very easy, just add the following line to your Podfile
and type 'pod install':
~~~~~~~~~~~~~~.ruby
pod "CueConcurrency"
~~~~~~~~~~~~~~

If you haven't used Cocoapods before, read the installation instructions [here](http://cocoapods.org/#install).

### CueConcurrency.xcodeproj
You can also just take the included project file and drag it from finder into your Xcode workspace/project. 
Once you've done that,  you'll need to add CueConcurrency/Classes to your headers path and link against libCueConcurrency.a

### Pick and choose
If you only need a single class, just grab it! Make sure to get any of that file's #includes as well!
