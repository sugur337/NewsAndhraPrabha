//
//  SideMenuViewController.h
//  MFSideMenuDemo
//
//  Created by Michael Frederick on 3/19/12.

#import <UIKit/UIKit.h>

@interface SideMenuViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray * districtArray;
@property (nonatomic,strong) NSMutableArray * apJillaArrays;
@property (nonatomic,strong) NSMutableArray * apUniversities;
@property (nonatomic,strong) NSMutableArray * tsUniversities;
@property (nonatomic,strong) NSMutableArray * allTitlesArray;
@property (nonatomic,strong) NSMutableArray * tsJillaArrays;
@property (nonatomic,strong) NSDictionary   * dictionary;
@property (nonatomic,strong) NSMutableArray * jsjillaMlidArrays;
@property (nonatomic,strong) NSMutableArray * apjillaMlidArrays;


@property (nonatomic,strong) NSString   * linkData;
@property (nonatomic,strong) NSString   * tidData;
@property int selectedCell;
@property NSMutableIndexSet *expandedSections;
@property int tidNews;
@property (retain) NSIndexPath * selectedCellIndexPath;
@end