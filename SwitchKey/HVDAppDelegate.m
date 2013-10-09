//
//  HVDAppDelegate.m
//  SwitchKey
//
//  Created by Harshad on 08/10/13.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import "HVDAppDelegate.h"
#import "HVDRootController.h"

@interface HVDAppDelegate () {

    NSStatusItem *_statusItem;

}

@end

@implementation HVDAppDelegate

- (void)awakeFromNib {

    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [_statusItem setHighlightMode:YES];
    [_statusItem setTitle:@"SSH"];

    [_statusItem setMenu:self.rootController.dropDownMenu];
}





@end
