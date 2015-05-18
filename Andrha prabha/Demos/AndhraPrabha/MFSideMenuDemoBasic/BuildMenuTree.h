//
//  BuildMenuTree.h
//  AndhraPrabha
//
//  Created by admin on 5/13/15.
//  Copyright (c) 2015 University of Wisconsin - Madison. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuildMenuTree : NSObject

-(NSDictionary*)getJsonDataFromUrl:(NSURL*)URL;
-(NSArray*)buildTreeFromJson;
-(NSArray*)buildMenuItem:(NSDictionary*)dict;
-(NSMutableArray*)getMenuItemFromPlid:(NSString*)plid  menuItems:(NSArray*)menuItems;
-(NSArray *)arrangeMenuItems:(NSArray *)menuItems;


@property (nonatomic,strong) NSDictionary * dataValue;
@property (nonatomic,strong) NSMutableArray * storedArray;

@property  NSInteger plid;



@end
