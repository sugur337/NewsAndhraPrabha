//
//  InnerBody.h
//  MFSideMenuDemoBasic
//
//  Created by admin on 4/13/15.
//  Copyright (c) 2015 University of Wisconsin - Madison. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InnerBody : NSObject

@property (nonatomic,strong) NSString * mainString;
@property (nonatomic,strong) NSString * innerString;
@property (nonatomic,strong) NSString * imageString;
@property (nonatomic,strong) NSMutableArray * mainArray;
@property (nonatomic,strong) NSMutableArray * innerArray;
@property (nonatomic,strong) NSMutableArray * imageArray;

-(id)initWithURL:(NSURL*)callURL
    headingArray:(NSMutableArray*)headingArray
       bodyArray:(NSMutableArray*)bodyArray
    pictureArray:(NSMutableArray*)pictureArray;

@end
