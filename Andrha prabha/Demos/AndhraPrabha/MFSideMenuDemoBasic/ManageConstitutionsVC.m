//
//  ManageConstitutionsVC.m
//  AndhraPrabha
//
//  Created by admin on 5/18/15.
//  Copyright (c) 2015 University of Wisconsin - Madison. All rights reserved.
//

#import "ManageConstitutionsVC.h"
#import "M13Checkbox.h"
@interface ManageConstitutionsVC ()

@end

@implementation ManageConstitutionsVC
@synthesize constitutionTV;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor purpleColor];

 
    UIView * leftView =[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+180, 60, 150, self.view.frame.size.height-40)];
    leftView.backgroundColor=[UIColor yellowColor];
   [self.view addSubview:leftView];
    
    
    constitutionTV=[[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+10, 60, 160, self.view.frame.size.height-40)];
    [constitutionTV setBackgroundColor:[UIColor yellowColor]];
    constitutionTV.delegate=self;
    constitutionTV.dataSource=self;
    [self.view addSubview:constitutionTV];
    
    //Basic Title
    M13Checkbox *basicTitle = [[M13Checkbox alloc] initWithTitle:@"Basic Titles"];
    basicTitle.frame = CGRectMake(0, 50 + 8, 130, basicTitle.frame.size.height-40);
    [leftView addSubview:basicTitle];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)checkChangedValue:(id)sender
{
    NSLog(@"Changed Value");
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    cell.backgroundColor=[UIColor yellowColor];
        cell.textLabel.text=[NSString stringWithFormat:@"Row %i",indexPath.row];
    
    return cell;
   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 10;
    
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
