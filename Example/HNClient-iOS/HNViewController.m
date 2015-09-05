//
//  HNViewController.m
//  HNClient-iOS
//
//  Created by yuchan on 03/04/2015.
//  Copyright (c) 2014 yuchan. All rights reserved.
//

#import "HNViewController.h"
#import "HNClient.h"

@interface HNViewController ()

@end

@implementation HNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    HNClient *cl = [[HNClient alloc] init];
    [cl loadTopStories:^(HNItem *item, NSError *error) {
        if (item) {
            NSLog(@"%@", item.title);
        }
    } completion:^(BOOL isCancelled, NSArray *items) {
        NSLog(@"%ld", (long)[items count]);
        HNItem *par = [items objectAtIndex:0];
        
        [cl loadChild:par OnChildLoaded:^(HNItem *item, HNItem *parent) {
            NSLog(@"%@", item.username);
        } completion:^(BOOL isCancelled, NSArray *childs) {
            NSLog(@"%ld", (long)[childs count]);
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
