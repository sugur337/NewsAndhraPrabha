//
//  SettingViewController.m
//  AndhraPrabha
//
//  Created by admin on 5/17/15.
//  Copyright (c) 2015 University of Wisconsin - Madison. All rights reserved.
//

#import "SettingViewController.h"
#import "MFSideMenu.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
@synthesize settingsTableView,manageCategories,subManageCategories;
- (void)viewDidLoad {
    [super viewDidLoad];
    settingsTableView.delegate=self;
    settingsTableView.dataSource=self;
    
    manageCategories=[[NSMutableArray alloc]init];
    subManageCategories=[[NSMutableArray alloc]init];
    [manageCategories addObject:@"Manage Categories"];
    [manageCategories addObject:@"Manage Districts"];
    [manageCategories addObject:@"Manage Constitutions"];
    [manageCategories addObject:@"Font Size"];
    [manageCategories addObject:@"Push Notification"];
    [manageCategories addObject:@"Manage Notification Categories"];
    [subManageCategories addObject:@"you can select categories here."];
    [subManageCategories addObject:@"you can select districts here."];
    [subManageCategories addObject:@"you can select constitutions here."];
    [subManageCategories addObject:@"small"];
    [subManageCategories addObject:@"Enabled"];
    [subManageCategories addObject:@"you can select Categories here for notifications."];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    cell.backgroundColor=[UIColor clearColor];
    
    cell.textLabel.text=[manageCategories objectAtIndex:indexPath.row];
    cell.detailTextLabel.text=[subManageCategories objectAtIndex:indexPath.row];
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
   return  manageCategories.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}

#pragma mark -
#pragma mark - UIBarButtonItems

- (void)setupMenuBarButtonItems {
    if(self.menuContainerViewController.menuState == MFSideMenuStateClosed &&
       ![[self.navigationController.viewControllers objectAtIndex:0] isEqual:self]) {
        self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
    } else {
        self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
    }
}

- (UIBarButtonItem *)leftMenuBarButtonItem {
    
    return [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu-icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftSideMenuButtonPressed:)];
}
- (UIBarButtonItem *)backBarButtonItem {
    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-arrow"]
                                            style:UIBarButtonItemStylePlain target:self
                                           action:@selector(backButtonPressed:)];
}
#pragma mark -
#pragma mark - UIBarButtonItem Callbacks

- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftSideMenuButtonPressed:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        [self setupMenuBarButtonItems];
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end