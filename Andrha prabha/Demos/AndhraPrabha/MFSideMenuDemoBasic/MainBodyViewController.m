//
//  MainBodyViewController.m
//  MFSideMenuDemoBasic
//
//  Created by admin on 4/14/15.
//  Copyright (c) 2015 University of Wisconsin - Madison. All rights reserved.
//

#import "MainBodyViewController.h"
#import "DemoViewController.h"

@interface MainBodyViewController ()

@end

@implementation MainBodyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //DemoViewController * demo =(DemoViewController*)
    self.mainbodyView=[[MainBodyViewController alloc]init];
    
    [self.view addSubview:self.mainLbl];
    [self.view addSubview:self.imageForNews];
    [self.view addSubview:self.bodyHeading];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(id)initWithString:(NSString*)temp
         bodyString:(NSString*)bodyS
          mainImage:(UIImage*)image
{
    self = [super init];
    if (self) {
        
        self.mainLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 60, 300, 60)];
        self.mainLbl.textColor=[UIColor blueColor];
        self.mainLbl.numberOfLines=3;
        self.mainLbl.text=temp;
        
        self.imageForNews=[[UIImageView alloc]initWithFrame:CGRectMake(0, 140, 320, 150)];
        self.imageForNews.image=image;
        
        self.bodyHeading=[[UITextView alloc]initWithFrame:CGRectMake(10, 300, 310, 250)];
        self.bodyHeading.editable=NO;
        self.bodyHeading.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        self.bodyHeading.text=bodyS;
        
        
    }
    return self;
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
