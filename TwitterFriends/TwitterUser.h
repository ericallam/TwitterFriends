//
//  TwitterUser.h
//  TwitterFriends
//
//  Created by Eric Allam on 7/2/11.
//  Copyright (c) 2011 EnvyLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TwitterUser : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * profileImage;
@property (nonatomic, retain) NSString * profileImageURL;
@property (nonatomic, retain) NSString * screenName;
@property (nonatomic, retain) NSNumber * twitterID;

+ (NSUInteger)countWithContext:(NSManagedObjectContext *)context;

@end
