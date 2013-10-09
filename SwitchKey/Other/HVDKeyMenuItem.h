//
//  HVDKeyMenuItem.h
//  SwitchKey
//
//  Created by Harshad on 09/10/13.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HVDSSHCredential;

@interface HVDKeyMenuItem : NSMenuItem

- (id)initWithAction:(SEL)aSelector keyEquivalent:(NSString *)charCode credential:(HVDSSHCredential *)credential;

@property (strong, readonly, nonatomic) HVDSSHCredential *credential;

@end
