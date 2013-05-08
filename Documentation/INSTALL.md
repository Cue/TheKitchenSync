# TheKitchenSync Installation

There are three ways to integrate TheKitchenSync into your project:
* Use [Cocoapods](http://cocoapods.org/)
* Import TheKitchenSync.xcodeproj
* Pick and choose the files you need (use _-fobc-no-arc_ if your target uses ARC).

### Cocoapods
If you're already using Cocoapods then this will be very easy, just add `pod "TheKitchenSync"` to your Podfile
and type 'pod install':

If you haven't used Cocoapods before, read the installation instructions [here](http://cocoapods.org/#install).

## Get the code

### Git Clone
If you don't care about keeping up to date, just `git clone https://github.com/Cue/TheKitchenSync.git`.

### Git Subtree
If you're using git 1.8, you can use `git subtree` for easy inclusion of the TheKitchenSync codebase:

~~~~~~~~~~~~.bash
git subtree add --prefix=path/within/repo/for/TheKitchenSync --squash \
    git@github.com:Cue/TheKitchenSync.git master
~~~~~~~~~~~~

Later, you can upgrade to the latest revision of TheKitchenSync with:

~~~~~~~~~~~~.bash
git subtree pull --prefix=path/within/repo/for/TheKitchenSync --squash \
    git@github.com:Cue/TheKitchenSync.git master
~~~~~~~~~~~~

If you make changes and want to submit a pull request, fork TheKitchenSync, and then:

~~~~~~~~~~~~.bash
git subtree pull --prefix=path/within/repo/for/TheKitchenSync --squash \
    git@github.com:YourGitUsername/TheKitchenSync.git master
~~~~~~~~~~~~

and then submit your pull request from your forked repo.

## Add to your project

Open Finder, navigate to `TheKitchenSync.xcodeproj`, and drag it in to your project:

![Drag TheKitchenSync in to your project](https://github.com/Cue/TheKitchenSync/blob/master/Documentation/Images/DragToProject.png?raw=true)

should result in something like this:

![After adding TheKitchenSync](https://github.com/Cue/TheKitchenSync/blob/master/Documentation/Images/ShowInProject.png?raw=true)

Select your root project. Search for `header`

* Add relative or full path to `TheKitchenSync/Classes` to `Header Search Paths`

![Header search paths](https://github.com/Cue/TheKitchenSync/blob/master/Documentation/Images/HeaderSearchPaths.png?raw=true)

For each the target you want to use TheKitchenSync with

* Select `Build Phases`

* Open the `Link Binary With Libraries` panel

![Before linking libraries](https://github.com/Cue/TheKitchenSync/blob/master/Documentation/Images/BeforeLinkLibraries.png?raw=true)

* Add `libTheKitchenSync.a`

* Add `libc++.dylib`

![Link libraries](https://github.com/Cue/TheKitchenSync/blob/master/Documentation/Images/LinkLibraries.png?raw=true)

* Then in your source code type:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.objc
#import "TheKitchenSync.h"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You're now ready to start using TheKitchenSync!
