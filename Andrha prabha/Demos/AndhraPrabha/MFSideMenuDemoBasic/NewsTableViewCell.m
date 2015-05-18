//
//  NewsTableViewCell.m
//  MFSideMenuDemoBasic
//
//  Created by admin on 4/10/15.
//  Copyright (c) 2015 University of Wisconsin - Madison. All rights reserved.
//

#import "NewsTableViewCell.h"

@implementation NewsTableViewCell
@synthesize imageView,bodyTextView,headingLbl;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
