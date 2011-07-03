//
//  TwitterFriendTableCell.m
//  TwitterFriends
//
//  Created by Eric Allam on 6/27/11.
//  Copyright 2011 EnvyLabs. All rights reserved.
//

#import "TwitterFriendTableCell.h"

@implementation TwitterFriendTableCell

@synthesize screenNameLabel, nameLabel, imageView;
@synthesize twitterFriend = _twitterFriend;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTwitterFriend:(TwitterUser *)twitterUser {
    _twitterFriend = twitterUser;
    
    self.screenNameLabel.text = _twitterFriend.screenName;
    self.nameLabel.text = _twitterFriend.name;
    
    NSData *imageData = _twitterFriend.profileImage;
    
    if(imageData == nil){
        // we need to get the data from the url
        // and then save it in the object
        NSString *profileURL = _twitterFriend.profileImageURL;
        NSManagedObjectContext *context = _twitterFriend.managedObjectContext;
        
        NSLog(@"GET %@ for %@", profileURL, _twitterFriend.screenName);
        
        self.imageView.image = nil;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
            NSData *newImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:profileURL]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _twitterFriend.profileImage = newImageData;
                self.imageView.image = [UIImage imageWithData:newImageData];
                [self setNeedsLayout];
                
                NSError *error = nil;
                if (context != nil)
                {
                    if ([context hasChanges] && ![context save:&error])
                    {
                        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                        abort();
                    } 
                }
            });
            
        });
        
    }else{
        UIImage *avatar = [UIImage imageWithData:imageData];
        self.imageView.image = avatar;
    }
}

@end
