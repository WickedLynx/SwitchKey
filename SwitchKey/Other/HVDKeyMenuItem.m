//
//  HVDKeyMenuItem.m
//  SwitchKey
//
//  Created by Harshad on 09/10/13.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import "HVDKeyMenuItem.h"

#import "HVDSSHCredential.h"

@interface HVDKeyMenuItem ()

@property (strong, readwrite, nonatomic) HVDSSHCredential *credential;

@end

@implementation HVDKeyMenuItem

- (id)initWithAction:(SEL)aSelector keyEquivalent:(NSString *)charCode credential:(HVDSSHCredential *)credential {

    NSString *title = [HVDSSHCredential titleForPublicKey:credential.publicKey];
    if (title == nil) {
        title = @"<no title>";
    }

    self = [super initWithTitle:title action:aSelector keyEquivalent:charCode];

    if (self != nil) {

        _credential = credential;
    }

    return self;
}





@end
