//
//  DetailViewController.h
//  TwitterFriends
//
//  Created by Eric Allam on 6/26/11.
//  Copyright 2011 EnvyLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterUser.h"

@interface DetailViewController : UIViewController {
    UIImageView *_avatarImageView;
}


@property (strong, nonatomic) TwitterUser *detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (nonatomic, strong) IBOutlet UIImageView *avatarImageView;

@end
