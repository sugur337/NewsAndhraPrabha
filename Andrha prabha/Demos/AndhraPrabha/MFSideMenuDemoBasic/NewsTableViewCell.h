//
//  NewsTableViewCell.h
//  MFSideMenuDemoBasic
//
//  Created by admin on 4/10/15.
//  Copyright (c) 2015 University of Wisconsin - Madison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell<UITextViewDelegate>

@property (nonatomic,retain)IBOutlet  UIImageView  * imageView;
@property (nonatomic,retain)IBOutlet  UILabel      * headingLbl;
@property (nonatomic,retain) IBOutlet UILabel      * bodyTextView;
@end
