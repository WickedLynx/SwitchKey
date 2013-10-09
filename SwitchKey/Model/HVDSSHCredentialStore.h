//
//  HVDSSHCredentialStore.h
//  SwitchKey
//
//  Created by Harshad on 08/10/13.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HVDSSHCredential;

@interface HVDSSHCredentialStore : NSObject

+ (HVDSSHCredential *)currentCredential;
+ (void)setCurrentCredential:(HVDSSHCredential *)credential;
+ (BOOL)credentialsAvailable;

@property (strong, readonly, nonatomic) NSArray *credentials;

- (void)refresh;
- (void)addCredential:(HVDSSHCredential *)credential;
- (void)removeCredential:(HVDSSHCredential *)credential;


@end
