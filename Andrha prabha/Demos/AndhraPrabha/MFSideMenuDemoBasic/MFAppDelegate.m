//
//  MFAppDelegate.m
//
//  Created by Michael Frederick on 4/4/13.
//  Copyright (c) 2013 Frederick Development. All rights reserved.
//

#import "MFAppDelegate.h"
#import "DemoViewController.h"
#import "SideMenuViewController.h"
#import "MFSideMenuContainerViewController.h"

@implementation MFAppDelegate

- (DemoViewController *)demoController {
    return [[DemoViewController alloc] initWithNibName:@"DemoViewController" bundle:nil];
}

- (UINavigationController *)navigationController {
    return [[UINavigationController alloc]
            initWithRootViewController:[self demoController]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    sleep(5);
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    SideMenuViewController *leftMenuViewController = [[SideMenuViewController alloc] init];
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:[self navigationController]
                                                    leftMenuViewController:leftMenuViewController
                                                    rightMenuViewController:nil];

    self.window.rootViewController = container;
    [self.window makeKeyAndVisible];
    
    return YES;
}
@end
