//
//  HVDSSHCredential.h
//  SwitchKey
//
//  Created by Harshad on 08/10/13.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HVDSSHCredential : NSObject

+ (NSString *)titleForPublicKey:(NSString *)publicKey;

- (instancetype)initWithTitle:(NSString *)title publicKey:(NSString *)publicKey privateKey:(NSString *)privateKey gitconfig:(NSString *)gitconfig;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)dictionaryRepresentation;

- (BOOL)isIdenticalToCredential:(HVDSSHCredential *)otherCredential;

@property (strong, readonly, nonatomic) NSString *title;
@property (strong, readonly, nonatomic) NSString *publicKey;
@property (strong, readonly, nonatomic) NSString *privateKey;
@property (strong, readonly, nonatomic) NSString *gitconfig;

@end
