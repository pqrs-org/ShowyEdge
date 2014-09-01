ShowyEdge
=========

ShowyEdge displays a color bar at the top edge of the screen depending on the current input source.
You can recognize the current input source very easily even if you are using fullscreen apps.


Web pages
---------

* master: https://pqrs.org/osx/ShowyEdge/
* backup: http://tekezo.github.io/pqrs.org/


System requirements
-------------------
Mac OS X 10.7 or higher.


How to build
------------

System Requirements:

* OS X 10.9+
* Xcode 5.0.1+
* Command Line Tools for Xcode
* CocoaPods http://cocoapods.org/

### Step1: Getting source code

Execute a following command in Terminal.app.

<pre>
git clone --depth 10 https://github.com/tekezo/ShowyEdge.git
</pre>

### Step2: Building a package

Execute a following command in Terminal.app.

<pre>
cd ShowyEdge
make package
</pre>

Then, ShowyEdge-VERSION.app.zip has been created in the current directory.
It's a distributable package.


**Note:**<br />
Build may be failed if you changed environment values or changed /usr/bin files.<br />
Use clean environment (new account) if build was failed.
