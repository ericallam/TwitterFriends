//
//  TwitterUser.m
//  TwitterFriends
//
//  Created by Eric Allam on 7/2/11.
//  Copyright (c) 2011 EnvyLabs. All rights reserved.
//

#import "TwitterUser.h"


@implementation TwitterUser
@dynamic name;
@dynamic profileImage;
@dynamic profileImageURL;
@dynamic screenName;
@dynamic twitterID;

+ (NSUInteger)countWithContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity: [NSEntityDescription entityForName:@"TwitterUser" inManagedObjectContext: context]];
    
    NSError *error = nil;
    NSUInteger count = [context countForFetchRequest: request error: &error];
    
    if(error != nil){
        NSLog(@"There was an error in getting count: %@", error);
        return 0;
    }else{
        return count;
    }
    
}

@end
