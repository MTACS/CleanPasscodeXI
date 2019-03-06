#import <UIKit/UIKit.h>

static bool enabled = NO;

static bool showCancel = NO;

static bool showEmergency = NO;

static bool showPasscodeCircles = NO;

static bool showTitle = NO;

static void loadPrefs() {

  NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.mtac.cpxiprefs.plist"]];

  if (prefs) {

    enabled = [prefs objectForKey:@"enabled"] ? [[prefs objectForKey:@"enabled"] boolValue] : enabled;

    showCancel = [prefs objectForKey:@"showCancel"] ? [[prefs objectForKey:@"showCancel"] boolValue] : showCancel;

    showEmergency = [prefs objectForKey:@"showEmergency"] ? [[prefs objectForKey:@"showEmergency"] boolValue] : showEmergency;

    showPasscodeCircles = [prefs objectForKey:@"showPasscodeCircles"] ? [[prefs objectForKey:@"showPasscodeCircles"] boolValue] : showPasscodeCircles;

    showTitle = [prefs objectForKey:@"showTitle"] ? [[prefs objectForKey:@"showTitle"] boolValue] : showTitle;

  }

}

%ctor {

  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.mtac.rxiprefs/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  loadPrefs();

}

@interface SBUIPasscodeLockViewBase : UIView

@property (nonatomic) bool showsCancelButton;
@property (nonatomic) bool showsEmergencyCallButton;

@end

%hook SBUIPasscodeLockViewBase

- (void)layoutSubviews {

  if (enabled == YES) {

    if (showEmergency == YES) {

      %orig;

      self.showsEmergencyCallButton = NO;

    } else {

      %orig;

    }

    if (showCancel == YES) {

      %orig;

      self.showsCancelButton = NO;

    } else {

      %orig;

    }

  } else {

    %orig;

  }

}

%end

@interface SBUISimpleFixedDigitPasscodeEntryField

@property (nonatomic, assign, readwrite, getter=isHidden) BOOL hidden;

@end

%hook SBUISimpleFixedDigitPasscodeEntryField

- (void)layoutSubviews {

  if (enabled == YES) {

    if (showPasscodeCircles == YES) {

      self.hidden = YES;

    }

  } else {

    %orig;

  }

}

%end

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

- (id)statusSubtitleView {

  if (enabled == YES) {

    if (showTitle == YES) {

      UILabel *label = MSHookIvar<UILabel *>(self, "_statusSubtitleView");

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
