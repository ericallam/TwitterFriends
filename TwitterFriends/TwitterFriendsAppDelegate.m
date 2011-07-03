//
//  TwitterFriendsAppDelegate.m
//  TwitterFriends
//
//  Created by Eric Allam on 6/26/11.
//  Copyright 2011 EnvyLabs. All rights reserved.
//

#import "TwitterFriendsAppDelegate.h"
#import "Twitter/Twitter.h"
#import "TwitterUser.h"

@implementation TwitterFriendsAppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize accountStore;
@synthesize twitterAccount;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    
    // initialize the account store
    self.accountStore = [[ACAccountStore alloc] init];
    
    //NSLog(@"ACAccountStore: %@", self.accountStore);
    
    //Get the twitter account type
    ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    //request access to twitter:
    [self.accountStore requestAccessToAccountsWithType:twitterAccountType withCompletionHandler:^(BOOL granted, NSError *__strong error){
        
        if (granted) {
            self.twitterAccount = [[self.accountStore accountsWithAccountType:twitterAccountType] objectAtIndex:0];
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self fetchAndStoreTwitterFriends];
            });
            
            
        }else {
            NSLog(@"User did not grant access to their twitter account");
        }

        
        
    }];
    
    return YES;
}

- (void)storeTwitterFriends:(NSArray *)friendData {
    // Create a new instance of the entity managed by the fetched results controller.
    
    for (NSDictionary *element in friendData) {
        TwitterUser *newTwitterUser = [NSEntityDescription insertNewObjectForEntityForName:@"TwitterUser" inManagedObjectContext:self.managedObjectContext];
        
        newTwitterUser.name = [element objectForKey:@"name"];
        newTwitterUser.profileImageURL = [element objectForKey:@"profile_image_url"];
        newTwitterUser.screenName = [element objectForKey:@"screen_name"];
        newTwitterUser.twitterID = [element objectForKey:@"id"];
        
//        NSLog(@"Creating a new Twitter User in Core Data: %@", newTwitterUser);
        
    }
    
    [self saveContext];
    
    
}


- (void) fetchAndStoreTwitterFriends {
    
    // we need to make sure we havent already done this.
    
    NSUInteger count = [TwitterUser countWithContext:self.managedObjectContext];
    
    NSLog(@"TwitterUser count: %d", count);
    
    if(count == 0){
    
        NSURL *friendsURL = [NSURL URLWithString:@"http://api.twitter.com/1/statuses/friends.json?include_entities=true"];
        
        TWRequest *friendsRequest = [[TWRequest alloc] initWithURL:friendsURL parameters:nil requestMethod:TWRequestMethodGET];
        
        friendsRequest.account = self.twitterAccount;
        
        
        [friendsRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            
            NSLog(@"Fetching new twitter friends");
            
            NSError *jsonError = nil;
            NSArray *friendData = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
            
            if(jsonError){
                NSLog(@"Got a JSON error: %@, %@", jsonError, [jsonError userInfo]);
            }else {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    [self storeTwitterFriends:friendData];
                });
            }
            
            
        }];
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

- (NSFetchRequest *)fetchRequestFromTemplateWithName:(NSString *)name substitutionVariables:(NSDictionary *)variables {
    
    NSFetchRequest *fetchRequest = [[self managedObjectModel] fetchRequestFromTemplateWithName:name substitutionVariables:variables];
    
    return fetchRequest;
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TwitterFriends" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TwitterFriends.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
