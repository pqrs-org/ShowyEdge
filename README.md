DrasticInputSourceStatus
========================

DrasticInputSourceStatus changes a color of the menubar by a current Input Source.
You can recognize a current input source very easily.


System requirements
-------------------
Mac OS X 10.6 or higher.


How to build
------------

Requirements:

* OS X 10.7
* Xcode 4.3+
* Command Line Tools for Xcode

### Step1: Getting source code

Execute a following command in Terminal.app.

<pre>
git clone --depth 10 https://github.com/tekezo/DrasticInputSourceStatus.git
</pre>

### Step2: Building a package

Execute a following command in Terminal.app.

<pre>
cd DrasticInputSourceStatus
make package
</pre>

Then, DrasticInputSourceStatus-VERSION.app.zip has been created in the current directory.
It's a distributable package.
