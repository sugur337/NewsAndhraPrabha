//
//  DemoViewController.h
//  MFSideMenuDemo
//
//  Created by Michael Frederick on 3/19/12.
//

#import <UIKit/UIKit.h>
#import "MainBodyViewController.h"
#import "InnerBody.h"

@interface DemoViewController : UIViewController<NSURLConnectionDataDelegate,UITableViewDelegate,UITableViewDataSource,NSURLConnectionDelegate,UITextFieldDelegate>

@property (atomic,retain)       NSMutableArray  * titleArray;
@property (atomic,retain)       NSMutableArray  * urisArray;
@property (atomic,retain)       NSMutableArray  * bodyArray;
@property (strong,nonatomic)    NSString        * titleStrin;
@property (strong,nonatomic)    NSString        * bodyString;
@property (strong,retain)       NSString        * titleS;
@property (atomic,retain)       NSMutableArray  * subJillaArrays;
@property (atomic,retain)       NSMutableArray  * allTitlesTidArrays;



@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong) NSMutableArray *myList;

@property int myTid;
@property NSString * cellID;

@property NSInteger sectionID;
@property NSInteger rowID;
@property (nonatomic,strong) NSString   * linkData;
@property (nonatomic,strong) NSString   * tidData;

@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) UITextField *jillaTextField;
@property (nonatomic,strong) UIView * jillaView;
@property (nonatomic,strong) UIScrollView * jillaScrollView;
@property (nonatomic,strong) UIButton * jillaListBtn;
@property (nonatomic,strong) UIButton * rightPadding;

@property (strong,nonatomic)    UITableView * jillaTV;

@property (strong,nonatomic)IBOutlet UITableView * newsTableView;

@property (nonatomic, strong) NSOperationQueue *imageDownloadingQueue;
@property (nonatomic, strong) NSCache *imageCache;

@property (strong,nonatomic)    MainBodyViewController * mainBody;
- (void)loadFromServer:(int)tid;

@end
