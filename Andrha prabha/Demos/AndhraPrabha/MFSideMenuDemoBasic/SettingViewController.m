//
//  SettingViewController.m
//  AndhraPrabha
//
//  Created by admin on 5/17/15.
//  Copyright (c) 2015 University of Wisconsin - Madison. All rights reserved.
//

#import "SettingViewController.h"
#import "MFSideMenu.h"
#import "ManageConstitutionsVC.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
@synthesize settingsTableView,manageCategories,subManageCategories;
@synthesize secondTV;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIViewOfSecondTableView];
    settingsTableView.delegate=self;
    settingsTableView.dataSource=self;
    secondTV.delegate=self;
    secondTV.dataSource=self;
    
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

-(void)UIViewOfSecondTableView
{
    secondTV=[[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+70, self.view.frame.origin.y+90,200, self.view.frame.size.height-120)];
    secondTV.hidden=YES;
    [self.view addSubview:secondTV];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[[UITableViewCell alloc]init];
    if (tableView==settingsTableView) {
        NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            
        }
        if (indexPath.row==4) {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
        cell.backgroundColor=[UIColor clearColor];
        
        cell.textLabel.text=[manageCategories objectAtIndex:indexPath.row];
        cell.detailTextLabel.text=[subManageCategories objectAtIndex:indexPath.row];
        
        return cell;
    }
    if (tableView==secondTV) {
        NSString *CellIdentifier = @"Cell1";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            
        }
       
        cell.backgroundColor=[UIColor blackColor];
        cell.textLabel.text=[NSString stringWithFormat:@"Row %i",indexPath.row];
        return cell;
        

    }
    else return cell;
   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==settingsTableView) {
        return  manageCategories.count;

    }
    if (tableView==secondTV) {
        return 10;
    }
    else return 1;
    
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==settingsTableView) {
        if (indexPath.row==2) {
            ManageConstitutionsVC * manage =[[ManageConstitutionsVC alloc]init];
            [self.navigationController pushViewController:manage animated:YES];
        }
        
      if (indexPath.row==0 || indexPath.row==1 || indexPath.row==5) {
          secondTV.hidden=NO;
      }
      else secondTV.hidden=YES;
    }
    if (indexPath.row==4) {
        NSUInteger index = [[tableView indexPathsForVisibleRows] indexOfObject:indexPath];
        
        if (index != NSNotFound) {
            UITableViewCell *cell = [[tableView visibleCells] objectAtIndex:index];
            if ([cell accessoryType] == UITableViewCellAccessoryNone) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            } else {
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
        }
    }
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
