//
//  DetailViewController.h
//  TwitterFriends
//
//  Created by Eric Allam on 6/26/11.
//  Copyright 2011 EnvyLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
