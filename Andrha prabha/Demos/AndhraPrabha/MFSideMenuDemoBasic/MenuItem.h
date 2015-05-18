//
//  MasterDetails.h
//  MFSideMenuDemoBasic
//
//  Created by admin on 4/11/15.
//  Copyright (c) 2015 University of Wisconsin - Madison. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItem : NSObject


@property (nonatomic,retain) NSString * linkTitle;
@property BOOL has_children;
@property NSString * plid;
@property NSString * mlid;
@property NSString * tid;
@property NSString * vid;
@property (nonatomic,retain) NSString * type;
@property (nonatomic,retain) NSString * url;
@property (nonatomic,strong) NSMutableArray * children;

@end
