//
//  InnerBody.m
//  MFSideMenuDemoBasic
//
//  Created by admin on 4/13/15.
//  Copyright (c) 2015 University of Wisconsin - Madison. All rights reserved.
//

#import "InnerBody.h"

@implementation InnerBody
@synthesize mainArray,mainString,innerArray,innerString,imageArray,imageString;
-(id)initWithURL:(NSURL*)callURL
    headingArray:(NSMutableArray*)headingArray
       bodyArray:(NSMutableArray*)bodyArray
     pictureArray:(NSMutableArray*)pictureArray
{
    self=[super init];
    if (self) {
        headingArray=headingArray;
        bodyArray=bodyArray;
        pictureArray=pictureArray;
        
        mainArray=headingArray;
        innerArray=bodyArray;
        imageArray=pictureArray;
       
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:callURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
        
  [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
         
completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   
    NSLog(@"Finished with status code: %li", (long)[(NSHTTPURLResponse *)response statusCode]);
NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSDictionary * dataValue =[jsonObject objectForKey:@"data"];
                                   
    for (NSDictionary * dcit in dataValue) {
    mainString=[dcit objectForKey:@"title"];
    [mainArray addObject:mainString];
    if ([NSNull null]!=[dcit objectForKey:@"body_value"]){
innerString=[dcit objectForKey:@"body_value"];
    [innerArray addObject:innerString];
    }
    else
    {
        NSString * replaceString=@"NULL";
    [innerArray addObject:replaceString];
    }
    if ([NSNull null]!=[dcit objectForKey:@"uri"]){
    NSString * image =[dcit objectForKey:@"uri"];
    NSString * baseUrl =@"http://www.prabhanews.com/";
    imageString=[baseUrl stringByAppendingString:image];
    [imageArray addObject:imageString];
        }
        else
    {
NSString * replaceString=@"http://www.prabhanews.com/sites/default/files/styles/categoryimg3_174x124/public/default_images/no-prev_0.jpg";
[imageArray addObject:replaceString];
        }
    }
}];

    }
   

    return self;
}
@end
