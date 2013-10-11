//
//  HVDRootController.m
//  SwitchKey
//
//  Created by Harshad on 08/10/13.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import "HVDRootController.h"
#import "HVDSSHCredential.h"
#import "HVDSSHCredentialStore.h"
#import "HVDKeyMenuItem.h"

NSString *RCGitConfigTemplate = @"[user]\n\tname = \n\temail = ";

@interface HVDRootController () {

    HVDSSHCredentialStore *_credentialStore;

}

@property (strong, nonatomic) NSArray *credentials;

- (void)didEndSheet:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
- (void)refreshKeysSubmenu;
- (void)selectedKey:(id)sender;
- (void)refreshCurrentKeyMenuItem;

@end



@implementation HVDRootController

- (void)awakeFromNib {

    [self refreshCurrentKeyMenuItem];

    _credentialStore = [HVDSSHCredentialStore new];
    _credentials = [_credentialStore credentials];

    [self refreshKeysSubmenu];

}

- (IBAction)clickPreferences:(id)sender {

    [self.preferencesWindow orderFrontRegardless];

}

- (IBAction)clickQuit:(id)sender {

    [[NSApplication sharedApplication] terminate:self];
}

- (IBAction)clickAdd:(id)sender {

    if (_addSheet == nil) {
        [NSBundle loadNibNamed:@"AddWindow" owner:self];

        [self.gitconfigTextView setRichText:NO];
        [self.gitconfigTextView setString:RCGitConfigTemplate];

        [self.publicSignatureTextView setRichText:NO];
        [self.privateSignatureTextView setRichText:NO];

        NSFont *textFont = [NSFont fontWithName:@"Menlo-Regular" size:13.0f];
        [self.gitconfigTextView setFont:textFont];
        [self.publicSignatureTextView setFont:textFont];
        [self.privateSignatureTextView setFont:textFont];

        [_addSheet becomeKeyWindow];
        [_addSheet becomeFirstResponder];
    }

    [[NSApplication sharedApplication] beginSheet:_addSheet modalForWindow:self.preferencesWindow modalDelegate:self didEndSelector:@selector(didEndSheet:returnCode:contextInfo:) contextInfo:NULL];
}

- (IBAction)clickDelete:(id)sender {

    NSInteger selectedIndex = [self.keysTableView selectedRow];

    if (selectedIndex >= 0 && selectedIndex < self.credentials.count) {

        [_credentialStore removeCredential:self.credentials[selectedIndex]];

        [self setCredentials:_credentialStore.credentials];
        [self.keysTableView reloadData];

        [self refreshKeysSubmenu];
    }
}

- (IBAction)clickCancel:(id)sender {

    [[NSApplication sharedApplication] endSheet:self.addSheet];

}

- (IBAction)clickSave:(id)sender {

    NSString *publicKey = self.publicSignatureTextView.string;
    NSString *title = [HVDSSHCredential titleForPublicKey:publicKey];
    NSString *privateKey = self.privateSignatureTextView.string;

    NSString *gitconfig = nil;
    if (![self.gitconfigTextView.string isEqualToString:RCGitConfigTemplate]) {
        gitconfig = self.gitconfigTextView.string;
    }

    HVDSSHCredential *aNewCredential = [[HVDSSHCredential alloc] initWithTitle:title publicKey:publicKey privateKey:privateKey gitconfig:gitconfig];
    [_credentialStore addCredential:aNewCredential];

    [self setCredentials:_credentialStore.credentials];

    [self.keysTableView reloadData];

    [self refreshKeysSubmenu];

    [[NSApplication sharedApplication] endSheet:self.addSheet];
}

- (void)didEndSheet:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {

    [sheet orderOut:self];

    [self setGitconfigTextView:nil];
    [self setPublicSignatureTextView:nil];
    [self setPrivateSignatureTextView:nil];
    [self setAddSheet:nil];
}

- (void)refreshKeysSubmenu {

    [self.keysSubMenu removeAllItems];

    for (HVDSSHCredential *aCredential in self.credentials) {

        if (![aCredential isIdenticalToCredential:[HVDSSHCredentialStore currentCredential]]) {

            HVDKeyMenuItem *menuItem = [[HVDKeyMenuItem alloc] initWithAction:@selector(selectedKey:) keyEquivalent:@"" credential:aCredential];
            [menuItem setTarget:self];
            [menuItem setAction:@selector(selectedKey:)];
            [menuItem setEnabled:YES];
            [self.keysSubMenu addItem:menuItem];

        }
    }

}

- (void)selectedKey:(id)sender {

    if ([sender isKindOfClass:[HVDKeyMenuItem class]]) {

        HVDKeyMenuItem *theMenuItem = (HVDKeyMenuItem *)sender;

        [HVDSSHCredentialStore setCurrentCredential:theMenuItem.credential];

        [NSTask launchedTaskWithLaunchPath:@"/usr/bin/ssh-add" arguments:@[@"-D"]];

        [self refreshCurrentKeyMenuItem];
        [self refreshKeysSubmenu];
    }
}

- (void)refreshCurrentKeyMenuItem {
    HVDSSHCredential *currentCredential = [HVDSSHCredentialStore currentCredential];
    if (currentCredential.title != nil) {
        [self.currentKeyMenuItem setTitle:currentCredential.title];
    } else {
        [self.currentKeyMenuItem setTitle:@"<no title>"];
    }
}

#pragma mark - NSTableViewDatasource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
    return [self.credentials count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
    HVDSSHCredential *theCredential = self.credentials[rowIndex];

    if (theCredential.title == nil) {
        return @"<no title>";
    }

    return theCredential.title;
}

@end
