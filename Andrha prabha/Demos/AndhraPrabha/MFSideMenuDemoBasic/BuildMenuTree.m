//
//  InnerBody.m
//  MFSideMenuDemoBasic
//
//  Created by admin on 4/13/15.
//  Copyright (c) 2015 University of Wisconsin - Madison. All rights reserved.
//

#import "BuildMenuTree.h"
#import "MenuItem.h"

@implementation BuildMenuTree
@synthesize dataValue;

-(NSDictionary*)getJsonDataFromUrl:(NSURL*)URL
{
    
    NSData * data=[NSData dataWithContentsOfURL:URL];
    
    NSError * error;
    
    //Get json data in Dictionary
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &error];
    NSDictionary * returnValue =[json objectForKey:@"data"];
    return returnValue;
}

-(NSMutableArray*)buildMenuItem:(NSDictionary*)dict
{
    
    self.storedArray=[[NSMutableArray alloc]init];
    
    
    for (NSDictionary *d in dict) {
        MenuItem * menuItem =[[MenuItem alloc]init];
        menuItem.url=d[@"url"];
        menuItem.linkTitle=d[@"link_title"];
        menuItem.tid=d[@"tid"];
        menuItem.mlid=d[@"mlid"];
        menuItem.plid=d[@"plid"];
        menuItem.vid=d[@"vid"];
        menuItem.type=d[@"type"];
        menuItem.has_children=(BOOL)d[@"has_children"];
        [self.storedArray addObject:menuItem];
        
    }
    return self.storedArray;
    
}

-(NSArray *)arrangeMenuItems:(NSArray *)menuItems
{
    NSMutableArray * arrangedMenuItem =[[NSMutableArray alloc]init];
    
    for (MenuItem * menu in menuItems) {
        if (menu.has_children) {
            NSString * mlid =menu.mlid;
            
            menu.children= [self getMenuItemFromPlid:mlid menuItems:menuItems];
            
            [arrangedMenuItem addObject:menu];
        }
        
        
    }
    return arrangedMenuItem;
    
    
}

-(NSMutableArray*)getMenuItemFromPlid:(NSString*)plid  menuItems:(NSArray*)menuItems
{
    NSMutableArray * childrensArray =[[NSMutableArray alloc]init];
    for (MenuItem * menu in menuItems) {
        if (menu.plid==plid) {
            [childrensArray addObject:menu];
        }
    }
    
    return childrensArray;
}


-(NSArray*)buildTreeFromJson
{
    NSURL * urlString =[NSURL URLWithString:@"http://www.prabhanews.com/webservices?type=menu"];
    NSDictionary * fromJson= [self getJsonDataFromUrl:urlString];
    NSArray * list= [self buildMenuItem:fromJson];
    return  [self arrangeMenuItems:list];
    
    
}

@end