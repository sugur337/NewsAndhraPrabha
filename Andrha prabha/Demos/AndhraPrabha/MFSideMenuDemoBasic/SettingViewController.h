//
//  SettingViewController.h
//  AndhraPrabha
//
//  Created by admin on 5/17/15.
//  Copyright (c) 2015 University of Wisconsin - Madison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) IBOutlet UITableView * settingsTableView;
@property (atomic,retain)       NSMutableArray  * manageCategories;
@property (atomic,retain)       NSMutableArray  * subManageCategories;
@property (nonatomic,strong)    UITableView * secondTV;

@end
