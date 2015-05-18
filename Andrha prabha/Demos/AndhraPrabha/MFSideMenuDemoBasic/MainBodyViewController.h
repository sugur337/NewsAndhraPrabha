//
//  MainBodyViewController.h
//  MFSideMenuDemoBasic
//
//  Created by admin on 4/14/15.
//  Copyright (c) 2015 University of Wisconsin - Madison. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface MainBodyViewController : UIViewController

@property (nonatomic,retain) MainBodyViewController * mainbodyView;


@property (strong,nonatomic) UILabel *  mainLbl;
@property (strong,nonatomic) UIImageView * imageForNews;
@property (strong,nonatomic) UITextView  * bodyHeading;

-(id)initWithString:(NSString*)temp
         bodyString:(NSString*)bodyS
          mainImage:(UIImage*)image;
@end