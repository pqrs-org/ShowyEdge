#import "MenuController.h"
#import "PreferencesManager.h"
#import "PreferencesWindowController.h"

@interface MenuController ()

@property(weak) IBOutlet PreferencesWindowController* preferencesWindowController;
@property NSStatusItem* item;

@end

@implementation MenuController

- (void)show {
  if (!self.item) {
    self.item = [NSStatusBar.systemStatusBar statusItemWithLength:NSSquareStatusItemLength];
    self.item.button.image = [NSImage imageNamed:@"menu"];

    NSMenu* menu = [[NSMenu alloc] initWithTitle:@"ShowyEdge"];

    NSString* version = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
    [menu addItemWithTitle:[NSString stringWithFormat:@"ShowyEdge %@", version]
                    action:nil
             keyEquivalent:@""];

    [menu addItem:[NSMenuItem separatorItem]];

    {
      NSMenuItem* menuItem = [[NSMenuItem alloc] initWithTitle:@"Preferences..."
                                                        action:@selector(showPreferences:)
                                                 keyEquivalent:@""];
      menuItem.target = self;
      [menu addItem:menuItem];
    }

    [menu addItem:[NSMenuItem separatorItem]];

    {
      NSMenuItem* menuItem = [[NSMenuItem alloc] initWithTitle:@"Quit ShowyEdge"
                                                        action:@selector(terminate:)
                                                 keyEquivalent:@""];
      menuItem.target = self;
      [menu addItem:menuItem];
    }

    self.item.menu = menu;
  }

  self.item.visible = PreferencesManager.showIconInMenubar;
}

- (void)showPreferences:(id)sender {
  [self.preferencesWindowController show];
}

- (void)terminate:(id)sender {
  [NSApp terminate:self];
}

@end
