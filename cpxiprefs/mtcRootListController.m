#include "mtcRootListController.h"
#include <spawn.h>

@implementation mtcRootListController
@synthesize doneButton;

- (instancetype)init {

	self = [super init];

	if (self) {

		self.doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"

			style:UIBarButtonItemStylePlain
			target:self
			action:@selector(dismissKeyboard)];

		self.doneButton.tintColor = [UIColor blackColor];

		self.navigationItem.rightBarButtonItem = self.doneButton;

	}

	return self;

}


- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;

}

- (void)respring {

	pid_t pid;

	int status;

	const char* args[] = {"killall", "-9", "backboardd", NULL};

	posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);

	waitpid(pid, &status, WEXITED);

}

- (void)twitter {

	[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://twitter.com/mtac8"]];

}

- (void)donate {

	[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://paypal.me/mtac"]]; 

}

- (void)dismissKeyboard {

	[self.view endEditing:YES];

}

@end
