# CleanPasscodeXI

This tweak hides the annoying buttons on the passcode entry screen of iOS. It supports iOS 10 and higher, but works best on iOS 11 and iOS 12.

# Writeup

The source code of the tweak is [here](https://github.com/MTACS/CleanPasscodeXI/blob/master/Tweak.xm), but the point of this writeup is how to add preferences to an existing tweak

### 1. Change directory to the path of your tweak and run $THEOS/bin/nic.pl to create a new instance

![alt text](https://github.com/MTACS/CleanPasscodeXI/blob/master/images/1.png "")

### 2. Select the number that corresponds with "iphone/preference_bundle_modern"

For project name, add something that relates to the name of the main tweak. For CleanPasscodeXI I used cpxiprefs.

Enter the bundle identifier for your preferences. If you use com.yourname.tweak for the tweak, use com.yourname.projectname, with projectname being the one you chose in the previous step.

Enter a name for the author.

Next, it will ask for a class name prefix. This is just an identifier Theos uses on the front of your main preference controller .m and .h files.

![alt text](https://github.com/MTACS/CleanPasscodeXI/blob/master/images/2.png "")

### 3. Open your main tweak project folder in an editor of your choice. I am using Visual Studio Code, as I find it provides the best syntax highlighting for Objective-C but many editors have the same function.

This will show how to add a simple Enable switch to your tweak.

Open your Tweak.xm file, and add the following to the top

```objective-c
static bool enabled = NO;
```
Next create a static function called loadPrefs()

```objective-c
static void loadPrefs() {

}
```

Inside this function, we need to create a NSMutableDictionary which will load from our tweak's preference file

```objective-c
static void loadPrefs() {

  NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/PreferenceBundles/com.yourname.tweakprefs.plist"]];

}
```

Replace com.yourname.tweakprefs.plist with the tweak's bundle identifier from Step 2. Make sure it's the id of the preferences and not the tweak itself.





