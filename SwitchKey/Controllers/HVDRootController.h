//
//  HVDRootController.h
//  SwitchKey
//
//  Created by Harshad on 08/10/13.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HVDRootController : NSObject <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSMenu *dropDownMenu;
@property (weak) IBOutlet NSMenu *keysSubMenu;
@property (weak) IBOutlet NSMenuItem *currentKeyMenuItem;
@property (weak) IBOutlet NSWindow *preferencesWindow;
@property (weak) IBOutlet NSWindow *addSheet;
@property (weak) IBOutlet NSTableView *keysTableView;
@property (strong) IBOutlet NSTextView *publicSignatureTextView;
@property (strong) IBOutlet NSTextView *privateSignatureTextView;
@property (strong) IBOutlet NSTextView *gitconfigTextView;
@property (weak) IBOutlet NSButton *saveButton;



- (IBAction)clickPreferences:(id)sender;
- (IBAction)clickQuit:(id)sender;
- (IBAction)clickAdd:(id)sender;
- (IBAction)clickDelete:(id)sender;
- (IBAction)clickCancel:(id)sender;
- (IBAction)clickSave:(id)sender;


@end
