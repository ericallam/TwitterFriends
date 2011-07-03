//
//  TwitterFriendsAppDelegate.h
//  TwitterFriends
//
//  Created by Eric Allam on 6/26/11.
//  Copyright 2011 EnvyLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>

@interface TwitterFriendsAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) ACAccount *twitterAccount;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)fetchAndStoreTwitterFriends;
- (void)storeTwitterFriends:(NSArray *)friendData;

@end
