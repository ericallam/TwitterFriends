//
//  TwitterFriendTableCell.h
//  TwitterFriends
//
//  Created by Eric Allam on 6/27/11.
//  Copyright 2011 EnvyLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterUser.h"

@interface TwitterFriendTableCell : UITableViewCell {
}

@property (nonatomic, strong) IBOutlet UILabel *screenNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) TwitterUser *twitterFriend;

@end
