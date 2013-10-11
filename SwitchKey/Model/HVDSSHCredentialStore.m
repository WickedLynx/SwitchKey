//
//  HVDSSHCredentialStore.m
//  SwitchKey
//
//  Created by Harshad on 08/10/13.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import "HVDSSHCredentialStore.h"

#import "HVDSSHCredential.h"

NSString *const CSPublicKeyFileName = @"id_rsa.pub";
NSString *const CSPrivateKeyFileName = @"id_rsa";
NSString *const CSGitConfigFileName = @".gitconfig";
NSString *const CSAppSupportFolderName = @"SwitchKey";
NSString *const CSCredentialsFileName = @"Credentials.plist";

@interface HVDSSHCredentialStore ()

+ (NSString *)SSHDirectoryPath;
- (void)saveCredentialsToDisk;

@property (strong, readwrite, nonatomic) NSArray *credentials;

@end

@implementation HVDSSHCredentialStore

#pragma mark - Initialisation

- (id)init {
    self = [super init];

    if (self != nil) {

        [self refresh];

        if (self.credentials.count == 0 && [HVDSSHCredentialStore credentialsAvailable]) {

            [self addCredential:[HVDSSHCredentialStore currentCredential]];

        } else {

            HVDSSHCredential *currentCredential = [HVDSSHCredentialStore currentCredential];
            BOOL credentialAlreadyAdded = NO;

            for (HVDSSHCredential *aCredential in self.credentials) {

                if ([aCredential isIdenticalToCredential:currentCredential]) {
                    credentialAlreadyAdded = YES;
                }
            }

            if (!credentialAlreadyAdded) {
                [self addCredential:currentCredential];
            }
        }

    }

    return self;
}

#pragma mark - Private methods

+ (NSString *)SSHDirectoryPath {

    NSString *homeDirectory = NSHomeDirectory();

    return [homeDirectory stringByAppendingPathComponent:@".ssh"];
}

+ (NSString *)applicationSupportDirectoryPath {

    NSString *path = nil;

    NSArray *appSuportDirectoryPaths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    if (appSuportDirectoryPaths.count > 0) {

        path = appSuportDirectoryPaths[0];
        path = [path stringByAppendingPathComponent:CSAppSupportFolderName];
    }

    return path;

}

- (void)saveCredentialsToDisk {

    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;

    if ([fileManager fileExistsAtPath:[HVDSSHCredentialStore applicationSupportDirectoryPath] isDirectory:&isDirectory]) {

        if (!isDirectory) {

            [fileManager removeItemAtPath:[HVDSSHCredentialStore applicationSupportDirectoryPath] error:nil];
            [fileManager createDirectoryAtPath:[HVDSSHCredentialStore applicationSupportDirectoryPath] withIntermediateDirectories:NO attributes:nil error:nil];
        }

    } else {

        [fileManager createDirectoryAtPath:[HVDSSHCredentialStore applicationSupportDirectoryPath] withIntermediateDirectories:NO attributes:nil error:nil];
    }

    NSMutableArray *credentialsAsDictionaries = [[NSMutableArray alloc] initWithCapacity:self.credentials.count];
    for (HVDSSHCredential *aCredential in self.credentials) {
        [credentialsAsDictionaries addObject:[aCredential dictionaryRepresentation]];
    }

    [credentialsAsDictionaries writeToFile:[[HVDSSHCredentialStore applicationSupportDirectoryPath] stringByAppendingPathComponent:CSCredentialsFileName] atomically:NO];

}

#pragma mark - Public methods

+ (BOOL)credentialsAvailable {
    HVDSSHCredential *currentCredential = [self currentCredential];

    if (currentCredential.publicKey != nil && currentCredential.privateKey != nil) {
        return YES;
    }

    return NO;
}

+ (HVDSSHCredential *)currentCredential {

    HVDSSHCredential *credential = nil;

    NSString *publicKeyFilePath = [[HVDSSHCredentialStore SSHDirectoryPath] stringByAppendingPathComponent:CSPublicKeyFileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:publicKeyFilePath]) {

        NSString *publicKey = [NSString stringWithContentsOfFile:publicKeyFilePath encoding:NSUTF8StringEncoding error:nil];
        if (publicKey.length > 0) {

            NSString *privateKeyPath = [[HVDSSHCredentialStore SSHDirectoryPath] stringByAppendingPathComponent:CSPrivateKeyFileName];
            NSString *privateKey = [NSString stringWithContentsOfFile:privateKeyPath encoding:NSUTF8StringEncoding error:nil];

            NSString *title = [HVDSSHCredential titleForPublicKey:publicKey];

            NSString *gitconfig = [NSString stringWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:CSGitConfigFileName] encoding:NSUTF8StringEncoding error:nil];

            credential = [[HVDSSHCredential alloc] initWithTitle:title publicKey:publicKey privateKey:privateKey gitconfig:gitconfig];
        }
    }

    return credential;
}

+ (void)setCurrentCredential:(HVDSSHCredential *)credential {

    [credential.publicKey writeToFile:[[self SSHDirectoryPath] stringByAppendingPathComponent:CSPublicKeyFileName] atomically:NO encoding:NSUTF8StringEncoding error:nil];

    [credential.privateKey writeToFile:[[self SSHDirectoryPath] stringByAppendingPathComponent:CSPrivateKeyFileName] atomically:NO encoding:NSUTF8StringEncoding error:nil];

    [credential.gitconfig writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:CSGitConfigFileName] atomically:NO encoding:NSUTF8StringEncoding error:nil];

}

- (void)refresh {

    NSArray *savedCredentials = [NSArray arrayWithContentsOfFile:[[HVDSSHCredentialStore applicationSupportDirectoryPath] stringByAppendingPathComponent:CSCredentialsFileName]];

    NSMutableArray *credentials = [NSMutableArray arrayWithCapacity:savedCredentials.count];
    for (NSDictionary *credentialDictionary in savedCredentials) {
        HVDSSHCredential *aCredential = [[HVDSSHCredential alloc] initWithDictionary:credentialDictionary];
        [credentials addObject:aCredential];
    }

    [self setCredentials:credentials];
}

- (void)addCredential:(HVDSSHCredential *)credential {

    NSMutableArray *credentials = [self.credentials mutableCopy];
    [credentials addObject:credential];

    [self setCredentials:[NSArray arrayWithArray:credentials]];

    [self saveCredentialsToDisk];

    [self refresh];
}

- (void)removeCredential:(HVDSSHCredential *)credential {

    NSMutableArray *credentials = [self.credentials mutableCopy];
    [credentials removeObject:credential];

    [self setCredentials:credentials];

    [self saveCredentialsToDisk];

    [self refresh];
}




@end
