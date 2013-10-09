//
//  HVDSSHCredential.m
//  SwitchKey
//
//  Created by Harshad on 08/10/13.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import "HVDSSHCredential.h"

NSString *CredentialTitleKey = @"title";
NSString *CredentialPublicKeyKey = @"publicKey";
NSString *CredentialPrivateKeyKey = @"privateKey";
NSString *CredentialGitconfigKey = @"gitconfig";

@interface HVDSSHCredential ()


@property (strong, readwrite, nonatomic) NSString *title;
@property (strong, readwrite, nonatomic) NSString *publicKey;
@property (strong, readwrite, nonatomic) NSString *privateKey;
@property (strong, readwrite, nonatomic) NSString *gitconfig;
@end

@implementation HVDSSHCredential

#pragma mark - Initialisation

- (instancetype)initWithTitle:(NSString *)title publicKey:(NSString *)publicKey privateKey:(NSString *)privateKey gitconfig:(NSString *)gitconfig {
    self = [super init];

    if (self != nil) {

        _title = title;
        if ([_title isKindOfClass:[NSNull class]]) {
            _title = nil;
        }

        _publicKey = publicKey;
        if ([_publicKey isKindOfClass:[NSNull class]]) {
            _publicKey = nil;
        }
        _privateKey = privateKey;
        if ([_privateKey isKindOfClass:[NSNull class]]) {
            _privateKey = nil;
        }
        _gitconfig = gitconfig;
        if ([_gitconfig isKindOfClass:[NSNull class]]) {
            _privateKey = nil;
        }
    }

    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {

    NSString *title = dictionary[CredentialTitleKey];
    NSString *publicKey = dictionary[CredentialPublicKeyKey];
    NSString *privateKey = dictionary[CredentialPrivateKeyKey];
    NSString *gitconfig = dictionary[CredentialGitconfigKey];

    return [self initWithTitle:title publicKey:publicKey privateKey:privateKey gitconfig:gitconfig];
}

#pragma mark - Public methods

+ (NSString *)titleForPublicKey:(NSString *)publicKey {

    NSString *title = nil;
    NSArray *publicKeyComponents = [publicKey componentsSeparatedByString:@" "];
    if ([publicKeyComponents count] > 2) {

        title = [publicKeyComponents lastObject];
        title = [title stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    }

    return title;
}

- (NSDictionary *)dictionaryRepresentation {

    NSMutableDictionary *dictionary = [NSMutableDictionary new];

    if (self.title != nil) {
        dictionary[CredentialTitleKey] = self.title;
    }

    if (self.publicKey != nil) {
        dictionary[CredentialPublicKeyKey] = self.publicKey;
    }

    if (self.privateKey != nil) {
        dictionary[CredentialPrivateKeyKey] = self.privateKey;
    }

    if (self.gitconfig != nil) {
        dictionary[CredentialGitconfigKey] = self.gitconfig;
    }

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)isIdenticalToCredential:(HVDSSHCredential *)otherCredential {

    return [otherCredential.publicKey isEqualToString:self.publicKey] && [otherCredential.privateKey isEqualToString:self.privateKey];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"{title: %@,\npublic key: %@,\nprivate key: %@,\ngit config: %@\n}", self.title, self.publicKey, self.privateKey, self.gitconfig];
}

@end
