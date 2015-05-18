//
//  SideMenuViewController.m
//  MFSideMenuDemo
//
//  Created by Michael Frederick on 3/19/12.

#import "SideMenuViewController.h"
#import "MFSideMenu.h"
#import "DemoViewController.h"
#import "SettingViewController.h"

@implementation SideMenuViewController
@synthesize districtArray,expandedSections,selectedCellIndexPath;
@synthesize apJillaArrays,apUniversities,tsUniversities,dictionary;
@synthesize linkData,tidData,allTitlesArray,tsJillaArrays,jsjillaMlidArrays,apjillaMlidArrays;
#pragma mark -
#pragma mark - UITableViewDataSource
-(void)viewDidLoad{
    linkData=@"link_title";
    tidData=@"tid";
    allTitlesArray=[[NSMutableArray alloc]init];
    tsJillaArrays=[[NSMutableArray alloc]init];
    jsjillaMlidArrays=[[NSMutableArray alloc]init];
    apjillaMlidArrays=[[NSMutableArray alloc]init];

    districtArray=[[NSMutableArray alloc]initWithObjects:@"బిజినెస్",@"ఆధ్యాత్మికం",@"క్రీడా ప్రభ",@"ప్రత్యేక పేజీలు",@"ఫోటో గేలరీ",@"బిజినెస్", nil];
    apJillaArrays=[[NSMutableArray alloc]init];
    apUniversities=[[NSMutableArray alloc]init];
    tsUniversities=[[NSMutableArray alloc]init];
    
    if (!expandedSections)
    {
        expandedSections = [[NSMutableIndexSet alloc] init];
    }
    self.tableView.backgroundColor=[UIColor blackColor];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self menuForAndhraPrabhaLink];
}
-(void)menuForAndhraPrabhaLink
{
    NSURL *myURL1 = [NSURL URLWithString:@"http://www.prabhanews.com/webservices?type=menu"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL1 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
     
    completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
    NSLog(@"Finished with status code: %li", (long)[(NSHTTPURLResponse *)response statusCode]);
    NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSDictionary * dataValue =[jsonObject objectForKey:@"data"];
for (NSDictionary * dict in dataValue) {
NSString * linkTitle =[dict objectForKey:@"link_title"];
NSString * tids =[dict objectForKey:@"tid"];
                                   
if ([[dict objectForKey:@"plid"]isEqualToString:@"1146"]) {
    NSString * string=[dict objectForKey:@"link_title"];
    [apUniversities addObject:string];
}
if ([[dict objectForKey:@"plid"]isEqualToString:@"787"]) {
    NSString * string=[dict objectForKey:@"link_title"];
    NSString * mlID =[dict objectForKey:@"mlid"];
    [jsjillaMlidArrays addObject:mlID];
    [tsJillaArrays addObject:string];
}
if ([[dict objectForKey:@"plid"]isEqualToString:@"1145"]) {
    NSString * string=[dict objectForKey:@"link_title"];
    [tsUniversities addObject:string];
}
if ([[dict objectForKey:@"plid"]isEqualToString:@"772"]) {
    NSString * string=[dict objectForKey:@"link_title"];
    [apJillaArrays addObject:string];
    NSString * mlID =[dict objectForKey:@"mlid"];
    [apjillaMlidArrays addObject:mlID];
}
  dictionary=[[NSDictionary alloc]initWithObjectsAndKeys:linkTitle,linkData,tids,tidData, nil];
                                   
                                [allTitlesArray addObject:dictionary];
                               }
                               
                               
                           }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 12;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( selectedCellIndexPath != nil && [selectedCellIndexPath compare: indexPath] == NSOrderedSame )
    {
        return 100;
    }
    
    return 50;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self tableView:tableView canCollapseSection:section])
    {
        if ([expandedSections containsIndex:section])
        {
            if (section==6) {
                return districtArray.count;
            }
            if (section==2) {
                return tsJillaArrays.count;
            }
            if (section==3) {
                return apJillaArrays.count;
            }
            if (section==4) {
                return tsUniversities.count;
            }
            if (section==5) {
                return apUniversities.count;
            }
            // return rows when expanded
        }
        
        return 1; // only top row showing
    }
    
    // Return the number of rows in the section.
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.backgroundColor=[UIColor blackColor];
    UIFont *myFont = [ UIFont fontWithName: @"Arial" size: 18.0 ];
    cell.textLabel.font  = myFont;
    cell.textLabel.textColor=[UIColor colorWithRed:191/74 green:240/88 blue:28/94 alpha:1.0];
    cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            cell.textLabel.text=@"ముఖ్యాంశాలు";
        }
    }
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            cell.textLabel.text=@"సినిమా";
        }
    }
    if (indexPath.section==7) {
        if (indexPath.row==0) {
            cell.textLabel.text=@"సెట్టింగ్స్";
        }
    }
    if (indexPath.section==8) {
        if (indexPath.row==0) {
            cell.textLabel.text=@"మా గురించి";
        }
    }
    if (indexPath.section==9) {
        if (indexPath.row==0) {
            cell.textLabel.text=@"సంప్రదించండి";
        }
    }
    if (indexPath.section==10) {
        if (indexPath.row==0) {
            cell.textLabel.text=@"భక్తిప్రభ";
        }
    }
    if (indexPath.section==11) {
        if (indexPath.row==0) {
            cell.textLabel.text=@"హెల్ప్";
        }
    }
    // Configure the cell...
    
    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
        if (!indexPath.row)
        {
            if (indexPath.section==2) {
                cell.textLabel.text =@"టి యస్ జిల్లాలు";
            }
            if (indexPath.section==3) {
                cell.textLabel.text =@"ఏపి జిల్లాలు";
            }
            if (indexPath.section==4) {
                cell.textLabel.text =@"టియస్ యూనివర్సిటీస్";
            }
            if (indexPath.section==5) {
                cell.textLabel.text =@"ఏపి యూనివర్సిటీస్";
            }
            if (indexPath.section==6) {
                cell.textLabel.text =@"కేటగిరీస్";
            }
            // only top row showing
            
            if ([expandedSections containsIndex:indexPath.section])
            {
                
                UIImageView *imView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UITableContract"]];
                cell.accessoryView = imView;
            }
            else
            {
                
                UIImageView *imView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UITableExpand"]];
                cell.accessoryView = imView;
            }
        }
        else
        {
            if (indexPath.section == 2) {
                cell.textLabel.text = [tsJillaArrays objectAtIndex:indexPath.row];
            }
            if (indexPath.section == 3) {
                cell.textLabel.text = [apJillaArrays objectAtIndex:indexPath.row];
            }
            if (indexPath.section == 4) {
                cell.textLabel.text = [tsUniversities objectAtIndex:indexPath.row];
            }
            if (indexPath.section == 5) {
                cell.textLabel.text = [apUniversities objectAtIndex:indexPath.row];
            }
            if (indexPath.section == 6) {
                cell.textLabel.text = [districtArray objectAtIndex:indexPath.row];
            }
            cell.accessoryView = nil;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    }
    
    
    return cell;
}

#pragma mark -
#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
    if ((section==0)||(section==1)||(section==7)||(section==8)||(section==9)||(section==10)||(section==11)){
        return NO;
    }
    else
        return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell=[[UITableViewCell alloc]init];
    DemoViewController *demoController = [[DemoViewController alloc] initWithNibName:@"DemoViewController" bundle:nil];
    demoController.title = cell.textLabel.text;
    demoController.sectionID=indexPath.section;
    demoController.rowID= indexPath.row;
    cell.textLabel.text = [[allTitlesArray objectAtIndex:indexPath.row] objectForKey:@"link_title"];
    
    
    if ((indexPath.section==7&& indexPath.row==0)) {
        SettingViewController * sVC=[[SettingViewController alloc]init];
        
UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:sVC];
        cell.textLabel.text=@"సెట్టింగ్స్";
        sVC.title=cell.textLabel.text;
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        [self.navigationController pushViewController:sVC animated:YES];
    }
    
    if ((indexPath.section==8&& indexPath.row==0)) {
        
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:demoController];
        cell.textLabel.text=@"మా గురించి";
        demoController.title=cell.textLabel.text;
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        [self.navigationController pushViewController:demoController animated:YES];
    }
    
    if ((indexPath.section==9&& indexPath.row==0)) {
        
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:demoController];
        cell.textLabel.text=@"సంప్రదించండి";
        demoController.title=cell.textLabel.text;
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        [self.navigationController pushViewController:demoController animated:YES];
    }
    if (indexPath.section==0)
    {
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:demoController];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        
        [self.navigationController pushViewController:demoController animated:YES];
        
        cell.textLabel.text = @"ముఖ్యాంశాలు";
        demoController.title=cell.textLabel.text;
        for (NSDictionary *item in allTitlesArray) {
            
            if ([[item objectForKey:@"link_title"]isEqualToString:cell.textLabel.text]) {
                NSLog(@"cheked value of diction: %@",[item objectForKey:@"link_title"]);
                int tidValue = [[item objectForKey:@"tid"] intValue];
                NSLog(@"label: %@ tid: %i",cell.textLabel.text,tidValue);
                demoController.myTid = tidValue;
                
                return;
            }
            
        }
        
    }
    
    if (indexPath.section==1)
    {
        NSLog(@"cell indes path is given %@",cell.textLabel.text);
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:demoController];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        
        [self.navigationController pushViewController:demoController animated:YES];
        
        cell.textLabel.text = @"సినిమా";
        demoController.title=cell.textLabel.text;
        for (NSDictionary *item in allTitlesArray) {
            
            if ([[item objectForKey:@"link_title"]isEqualToString:cell.textLabel.text]) {
                NSLog(@"cheked value of diction: %@",[item objectForKey:@"link_title"]);
                int tidValue = [[item objectForKey:@"tid"] intValue];
                NSLog(@"label: %@ tid: %i",cell.textLabel.text,tidValue);
                demoController.myTid = tidValue;
                
                return;
            }
            
        }
        
    }
    if (indexPath.section==10)
    {
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:demoController];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        
        [self.navigationController pushViewController:demoController animated:YES];
        
        cell.textLabel.text = @"భక్తిప్రభ";
        demoController.title=cell.textLabel.text;
        for (NSDictionary *item in allTitlesArray) {
            
            if ([[item objectForKey:@"link_title"]isEqualToString:cell.textLabel.text]) {
                NSLog(@"cheked value of diction: %@",[item objectForKey:@"link_title"]);
                int tidValue = [[item objectForKey:@"tid"] intValue];
                NSLog(@"label: %@ tid: %i",cell.textLabel.text,tidValue);
                demoController.myTid = tidValue;
                
                return;
            }
            
        }
        
    }
    if (indexPath.section==2 && indexPath.row)
    {
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:demoController];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        
        [self.navigationController pushViewController:demoController animated:YES];
        NSLog(@"section :%ld,row:%ld",(long)indexPath.section,(long)indexPath.row);
        demoController.jillaTextField.hidden=YES;
        cell.textLabel.text = [tsJillaArrays objectAtIndex:indexPath.row];
        demoController.title=cell.textLabel.text;
        demoController.cellID=[jsjillaMlidArrays objectAtIndex:indexPath.row];
        NSLog(@"democontroller value for cellid is %@",demoController.cellID);
        for (NSDictionary *item in allTitlesArray) {
            
            if ([[item objectForKey:@"link_title"]isEqualToString:cell.textLabel.text]) {
                NSLog(@"cheked value of diction: %@",[item objectForKey:@"link_title"]);
                int tidValue = [[item objectForKey:@"tid"] intValue];
                NSLog(@"label: %@ tid: %i",cell.textLabel.text,tidValue);
                demoController.myTid = tidValue;
                
                return;
            }
            
        }
        
    }
    if (indexPath.section==3 && indexPath.row)
    {
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:demoController];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        [self.navigationController pushViewController:demoController animated:YES];
        demoController.cellID=[apjillaMlidArrays objectAtIndex:indexPath.row];
        NSLog(@"democontroller value for cellid is %@",demoController.cellID);
        
        cell.textLabel.text = [apJillaArrays objectAtIndex:indexPath.row];
        demoController.title=cell.textLabel.text;
        for (NSDictionary *item in allTitlesArray) {
            
            if ([[item objectForKey:@"link_title"]isEqualToString:cell.textLabel.text]) {
                NSLog(@"cheked value of diction: %@",[item objectForKey:@"link_title"]);
                int tidValue = [[item objectForKey:@"tid"] intValue];
                NSLog(@"label: %@ tid: %i",cell.textLabel.text,tidValue);
                demoController.myTid = tidValue;
                
                return;
            }
            
        }
        
    }
    if (indexPath.section==4 && indexPath.row)
    {
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:demoController];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        
        [self.navigationController pushViewController:demoController animated:YES];
        
        cell.textLabel.text = [tsUniversities objectAtIndex:indexPath.row];
        demoController.title=cell.textLabel.text;
        for (NSDictionary *item in allTitlesArray) {
            
            if ([[item objectForKey:@"link_title"]isEqualToString:cell.textLabel.text]) {
                NSLog(@"cheked value of diction: %@",[item objectForKey:@"link_title"]);
                int tidValue = [[item objectForKey:@"tid"] intValue];
                NSLog(@"label: %@ tid: %i",cell.textLabel.text,tidValue);
                demoController.myTid = tidValue;
                
                return;
            }
            
        }
        
    }
    if (indexPath.section==5 && indexPath.row)
    {
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:demoController];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        
        [self.navigationController pushViewController:demoController animated:YES];
        cell.textLabel.text = [apUniversities objectAtIndex:indexPath.row];
        demoController.title=cell.textLabel.text;
        for (NSDictionary *item in allTitlesArray) {
            
            if ([[item objectForKey:@"link_title"]isEqualToString:cell.textLabel.text]) {
                NSLog(@"cheked value of diction: %@",[item objectForKey:@"link_title"]);
                int tidValue = [[item objectForKey:@"tid"] intValue];
                NSLog(@"label: %@ tid: %i",cell.textLabel.text,tidValue);
                demoController.myTid = tidValue;
                
                return;
            }
            
        }
        
    }
    
    if (indexPath.section==6 && indexPath.row)
    {
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:demoController];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        
        [self.navigationController pushViewController:demoController animated:YES];
        
        cell.textLabel.text = [districtArray objectAtIndex:indexPath.row];
        NSLog(@"cell text clicked for the given item is%@",cell.textLabel.text);
        demoController.title=cell.textLabel.text;
        for (NSDictionary *item in allTitlesArray) {
            
            if ([[item objectForKey:@"link_title"]isEqualToString:cell.textLabel.text]) {
                NSLog(@"cheked value of diction: %@",[item objectForKey:@"link_title"]);
                int tidValue = [[item objectForKey:@"tid"] intValue];
                NSLog(@"label: %@ tid: %i",cell.textLabel.text,tidValue);
                demoController.myTid = tidValue;
                
                return;
            }
            
        }
        
    }
    
    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
        if (!indexPath.row)
        {
            // only first row toggles exapand/collapse
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            NSInteger section = indexPath.section;
            BOOL currentlyExpanded = [expandedSections containsIndex:section];
            NSInteger rows;
            
            
            NSMutableArray *tmpArray = [NSMutableArray array];
            
            if (currentlyExpanded)
            {
                rows = [self tableView:tableView numberOfRowsInSection:section];
                [expandedSections removeIndex:section];
                
            }
            else
            {
                [expandedSections addIndex:section];
                rows = [self tableView:tableView numberOfRowsInSection:section];
            }
            for (int i=0; i<rows-1; i++)
            {
                NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i+1
                                                               inSection:section];
                [tmpArray addObject:tmpIndexPath];
            }
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            if (currentlyExpanded)
            {
                [tableView deleteRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
                
                UIImageView *imView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UITableExpand"]];
                cell.accessoryView = imView;
            }
            else
            {
                [tableView insertRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
                
                UIImageView *imView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UITableContract"]];
                cell.accessoryView = imView;
            }
        }
    }
    
    //NSLog(@"section :%ld,row:%ld",(long)indexPath.section,(long)indexPath.row);
}

@end
