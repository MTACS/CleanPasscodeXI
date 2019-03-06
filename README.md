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

Next, we need to grab the key of enable switch. Add the following inside the loadPrefs() method's brackets

```objective-c
static void loadPrefs() {

  NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/PreferenceBundles/com.yourname.tweakprefs.plist"]];
  
if (prefs) {
  
    enabled = [prefs objectForKey:@"enabled"] ? [[prefs objectForKey:@"enabled"] boolValue] : enabled;
    
  }

}
```

This will grab the key from the preference file and assign it to `static bool enabled` 

Now that we have a boolean inside our Tweak.xm, all we need to do is test if it is enabled.

### 4. Setting up our constructor and using the enable boolean

Now we must setup our constructor, which as special logos block that we can use to call our loadPrefs() method.

Add this anywhere in your tweak

```objective-c
%ctor {

  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), 
  NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.mtac.cpxiprefs/settingschanged"), 
  NULL, CFNotificationSuspensionBehaviorCoalesce);
  loadPrefs();

}
```

Now our enabled key is ready to use. 

### 5. Enabling/Disabling our Tweak.

To use our enabled key, simply use an if statement to test if it is set to YES

```objective-c
@interface SBUIPasscodeLockViewWithKeypad

@property (nonatomic,retain) UILabel * statusTitleView;

@end

%hook SBUIPasscodeLockViewWithKeypad

- (id)statusTitleView {

  if (enabled == YES) {

    if (showTitle == YES) {

      UILabel *label = MSHookIvar<UILabel *>(self, "_statusTitleView");

      label.text = @"";

      return label;

    } else {

      return %orig;

    }

  } else {

    return %orig;

  }

}

%end
```

You can see here, inside our %hook block, I test if enabled is equal to YES. If it is, the tweak uses MSHookIvar to grab the UILabel ivar, and change the text to "". Make sure to add else {} statements, as if enabled is equal to NO, you want to run %orig. %orig calls whatever was there by default, not adding this might cause problems.

Preference keys can be of any type. This uses `[[prefs objectForKey":@"key"] boolValue]` as it's testing for YES/NO. Different types can be used, such as boolValue, stringValue, intValue, floatValue...

### 6. Editing our Root.plist to change what's displayed in the Settings pane.

By default, Theos generates a key called Awesome Switch 1, inside Tweak > tweakprefs > Resources > Root.plist.

Open this plist and add the following between `<array>` and `</array>`

```xml
<dict>
			<key>cell</key>
			<string>PSSwitchCell</string>
			<key>default</key>
			<false/>
			<key>defaults</key>
			<string>com.mtac.cpxiprefs</string>
			<key>PostNotification</key>
			<string>com.mtac.cpxiprefs/settingsupdated</string>
			<key>key</key>
			<string>enabled</string>
			<key>label</key>
			<string>Enable Tweak</string>
</dict>
```

Under `<key>` change the `<string>` to "enabled". This is the key that loadPrefs() uses.

Also add the following to the XML block

```xml
<key>PostNotification</key>
<string>com.mtac.cpxiprefs/settingsupdated</string>
```

This calls preference's notifier to change the value inside the .plist

Change com.mtac.cpxiprefs to the same identifier you used for your preference bundle

### 7. Build your tweak

There are endless options for the types of PSCells, for more information check the source code of this tweak

All you have to do now is run

```bash
make package install
```

# If you find anything wrong with this writeup, make a pull request with the required changes or contact me on twitter @MTAC8
