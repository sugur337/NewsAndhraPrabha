//
//  DemoViewController.m
//  MFSideMenuDemo
//
//  Created by Michael Frederick on 3/19/12.
//

#import "DemoViewController.h"
#import "MFSideMenu.h"
#import "SVProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "AFNetworking.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "NewsTableViewCell.h"
#import "SideMenuViewController.h"
#import "MainBodyViewController.h"
#import "BuildMenuTree.h"
#import "MenuItem.h"

static int initialPage = 0; // paging start from 1, depends on your api
@interface DemoViewController ()

@end

@implementation DemoViewController
@synthesize newsTableView,titleArray,urisArray,bodyArray,mainBody,sectionID,rowID,textView,linkData,tidData;
@synthesize currentPage,myList,jillaTV,jillaTextField;
@synthesize myTid,subJillaArrays,allTitlesTidArrays,rightPadding;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}
#pragma mark - VIEWLOAD

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIViewContent];
    [self subjillaCallingMethods];
    
    linkData=@"link_title";
    tidData=@"tid";
    
    [jillaTV setHidden:YES];
    self.navigationItem.rightBarButtonItem=nil;
   
if ((sectionID==2 && rowID)||(sectionID==3 && rowID)) {
        
        rightPadding = [UIButton buttonWithType:UIButtonTypeCustom];
        rightPadding.frame=CGRectMake(0, 0, 20, 20);
        [rightPadding addTarget:self action:@selector(ddMenuShow:) forControlEvents:UIControlEventTouchUpInside];
        [rightPadding setTitle:@"▼" forState:UIControlStateNormal];
        [rightPadding setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        jillaTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
        jillaTextField.borderStyle=UITextBorderStyleRoundedRect;
        jillaTextField.rightView = rightPadding;
        jillaTextField.text=@"జిల్లా";
        jillaTextField.rightViewMode = UITextFieldViewModeAlways;
        UIBarButtonItem *compassButtonItem = [[UIBarButtonItem alloc] initWithCustomView:jillaTextField];
        compassButtonItem.enabled = YES;
        self.navigationItem.rightBarButtonItem = compassButtonItem;
    }
    
    if(!self.title) self.title = @"ముఖ్యాంశాలు";
    if (myTid==0) {
        [self loadFromServer:98];
        [newsTableView addInfiniteScrollingWithActionHandler:^{
            [self loadFromServer:98];
        }];
    }
    newsTableView.delegate=self;
    newsTableView.dataSource=self;
    jillaTextField.delegate=self;
    jillaTV.delegate=self;
    jillaTV.dataSource=self;
    currentPage = initialPage;
    [self setupMenuBarButtonItems];
    self.imageDownloadingQueue = [[NSOperationQueue alloc] init];
    self.imageDownloadingQueue.maxConcurrentOperationCount = 10;
    
    self.imageCache = [[NSCache alloc] init];
    
    [newsTableView registerNib:[UINib nibWithNibName:@"NewsTableViewCell"
                                              bundle:[NSBundle mainBundle]]
        forCellReuseIdentifier:@"Cell"];
    
    
    BuildMenuTree * bMT=[[BuildMenuTree alloc]init];
    
    NSArray * jillaArrays = [bMT buildTreeFromJson];
    allTitlesTidArrays=[[NSMutableArray alloc]init];
    for (MenuItem * menu in jillaArrays) {
        
            NSString * subJillaTitle =menu.linkTitle;
        NSString * subJillaTid =menu.tid;
        
        NSDictionary * allTitleAndTidDict=[[NSDictionary alloc]initWithObjectsAndKeys:subJillaTitle,linkData,subJillaTid,tidData, nil];
        [allTitlesTidArrays addObject:allTitleAndTidDict];
        }
    
    titleArray =   [[NSMutableArray alloc]init];
    urisArray  =   [[NSMutableArray alloc]init];
    bodyArray  =   [[NSMutableArray alloc]init];
    //    subJillaArrays=[[NSMutableArray alloc]init];
    myList =[[NSMutableArray alloc]init];
    
    mainBody=[[MainBodyViewController alloc]init];
    
    __weak typeof(self) weakSelf = self;
    weakSelf.currentPage = initialPage; // reset the page
    [weakSelf.titleArray removeAllObjects];
    [weakSelf.urisArray removeAllObjects];
    [weakSelf.bodyArray removeAllObjects];// remove all data
    [weakSelf.newsTableView reloadData]; // before load new content, clear the existing table list
    
    [weakSelf loadFromServer:myTid]; // load new data
    
    // once refresh, allow the infinite scroll again
    weakSelf.newsTableView.showsInfiniteScrolling = YES;
    
    // load more content when scroll to the bottom most
    [newsTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadFromServer:myTid];
    }];
    
    
}
#pragma mark - SUBJILLA CALLING METHODS
-(void)subjillaCallingMethods
{
    BuildMenuTree * bMT=[[BuildMenuTree alloc]init];
    
    NSArray * jillaArrays = [bMT buildTreeFromJson];
    subJillaArrays=[[NSMutableArray alloc]init];
    
    for (MenuItem * menu in jillaArrays) {
        
        if ([self.cellID isEqualToString:menu.plid]) {
            NSString * subJillaTitle =menu.linkTitle;
            [subJillaArrays addObject:subJillaTitle];
            NSLog(@"title check:%@",menu.linkTitle);
        }
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
    return YES;
}
#pragma mark - LOADING DATA FROM SERVER.

- (void)loadFromServer:(int)tid
{
    [self startActivity:@"Loading..."];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"http://www.prabhanews.com/webservices?type=inner&tid=%i&pagination=%i",tid, currentPage] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [newsTableView reloadData];
        NSDictionary * dataValue =[responseObject objectForKey:@"data"];
        
        for (NSDictionary * dcit in dataValue) {
            NSString * titleString =[dcit objectForKey:@"title"];
            [titleArray addObject:titleString];
            if ([NSNull null]!=[dcit objectForKey:@"body_value"]){
                NSString * bodystring=[dcit objectForKey:@"body_value"];
                NSString * stripValue =  [self stripTags:bodystring];
                [bodyArray addObject:stripValue];
            }
            else
            {
                NSString * replaceString=@"NULL";
                [self.bodyArray addObject:replaceString];
            }
            if ([NSNull null]!=[dcit objectForKey:@"uri"]){
                NSString * image =[dcit objectForKey:@"uri"];
                NSString * baseUrl =@"http://www.prabhanews.com/";
                NSString * imageStr=[baseUrl stringByAppendingString:image];
                [urisArray addObject:imageStr];
            }
            else
            {
                NSString * replaceString=@"http://www.prabhanews.com/sites/default/files/styles/categoryimg3_174x124/public/default_images/no-prev_0.jpg";
                [urisArray addObject:replaceString];
            }
            
        }
        currentPage++; // increase the page number
        int currentRow = [myList count]; // keep the the index of last row before add new items into the list
        
        // store the items into the existing list
        for (id obj in [responseObject valueForKey:@"data"]) {
            [myList addObject:obj];
        }
        [self reloadTableView:currentRow];
        [self stopActivity];
        
        // clear the pull to refresh & infinite scroll, this 2 lines very important
        [newsTableView.pullToRefreshView stopAnimating];
        [newsTableView.infiniteScrollingView stopAnimating];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        newsTableView.showsInfiniteScrolling = NO;
        NSLog(@"error %@", error);
    }];
}
- (NSString *)stripTags:(NSString *)str
{
    NSMutableString *html = [NSMutableString stringWithCapacity:[str length]];
    
    NSScanner *scanner = [NSScanner scannerWithString:str];
    scanner.charactersToBeSkipped = NULL;
    NSString *tempText = nil;
    
    while (![scanner isAtEnd])
    {
        [scanner scanUpToString:@"<" intoString:&tempText];
        
        if (tempText != nil)
            [html appendString:tempText];
        
        [scanner scanUpToString:@">" intoString:NULL];
        
        if (![scanner isAtEnd])
            [scanner setScanLocation:[scanner scanLocation] + 1];
        
        tempText = nil;
    }
    
    return html;
}

- (void)reloadTableView:(int)startingRow;
{
    // the last row after added new items
    int endingRow = [myList count];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (; startingRow < endingRow; startingRow++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:startingRow inSection:0]];
    }
    
    [newsTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}
#pragma mark -UIVIEW CONTENT
-(void)UIViewContent
{
    jillaTV =[[UITableView alloc]initWithFrame:CGRectMake(self.view.bounds.origin.x+190, self.view.bounds.origin.y+50, self.view.bounds.size.width+100, 400) style:UITableViewStylePlain];
    [jillaTV setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:jillaTV];
    
    textView =[[UITextView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+80, self.view.frame.size.width, self.view.bounds.size.height)];
    if (sectionID==9 && rowID==0) {
        textView.text=@"8-2-293/82/A/75, Plot No.75, Road No.9, Jubilee Hills, Hyderabad-500033.\nPhone : 040-23559940/41/42.\nEmail : feedback@apdaily.in";
        [textView setFont:[UIFont fontWithName:@"ArialMT" size:14]];
        
        [self.view addSubview:textView];
        
    }
    
    if (sectionID==8 && rowID==0) {
        textView.text=@"అక్షరాలే ఆయుధాలు...\n\n  సత్యనిష్ఠలో డెబ్బై ఏడు వసంతాలు\n\n\n\n\n\n\nఅభ్యుదయ పతాక ఆంధ్రప్రభ\nపరాయి పాలనలో మగ్గుతున్న భరతజాతికి అప్పటికి ఇంకా స్వరాజ్య భానూదయం కాలేదు. 1947 ఆగస్టు 15న కాని మన దేశం దాస్యశృంఖలాలు బదాబదలు కాలేదు. అయితే త్రివర్ణ పతాక రెపరెపలాడడానికి సరిగ్గా తొమ్మిదేళ్లకు ముందు 1938లో ఆగస్టు 15నాడే 'ఆంధ్రప్రభ' ఆవిర్భవించడం ఆశ్చర్యం కలిగించే ఒక యాదృచ్ఛిక ఘటనలా కనిపించినా భారతీయాత్మతో దానికి ఉన్న తాదాత్మ్యతకు ఇది తార్కాణం. అది మొదలు’ఆంధ్రప్రభ నిర్భీకతతో కూడిన  జర్నలిజానికి పర్యాయపదంగా నిలిచింది. ఎన్నో సంచలనాలకు వేదిక అయినా ఏనాడూ విలువలు కోల్పోలేదు. విశ్వసనీయతను వదలలేదు. 1947-48లో రజాకార్ల దురంతాలను నిరసిస్తూ వార్తలు వేసినందుకు నిజాం హయాంలో ఆంధ్రప్రభ నిషేధాన్ని సైతం ఎదుర్కోవలసి వచ్చింది. 1975-77 మధ్య దేశంలో ఎమర్జెన్సీ విధింపును వ్యతిరేకించినందుకు కూడా ఆంధ్రప్రభపై నాటి పాలకులు కత్తిగట్టారు. అయినా ఏనాడూ తలొంచింది లేదు. రాజ పడింది లేదు. ప్రజాగళం వినిపిస్తూ కాలం కత్తుల వంతెనపై సాగడం ఆంధ్రప్రభ నేటి వరకు నిర్వహిస్తూ వస్తున్న అసిధారావ్రతం. దశాబ్దాల వారసత్వాన్ని కొనసాగిస్తూనే ఆధునికతను సంతరించుకుంటూ యువతరాన్ని సైతం ఆకట్టుకోవడం ఆంధ్రప్రభ ప్రత్యేకత. ప్రసిద్ధ స్వాతంత్ర్య సమరయోధులు శ్రీ ఖాసా సుబ్బారావుగారు ఆంధ్రప్రభకు తొలి సంపాదకులు. అకళంక దేశభక్తులైన ఖాసావారు గాంధీజీని అనుసరించి జాతీయోద్యమంలో చురుకుగా పాల్గొన్నవారు. అలాంటి దిగ్గజాలు సారథ్యం వహించడం వల్లే ఆంధ్రప్రభ జాతీయభావవాహినిగా జర్నలిజాన్ని సుసంపన్నం చేసింది. అగ్రశ్రేణి దినపత్రికగా పాఠకులకు మరింత చేరువ కాగలిగింది. అసలు ఆంధ్రప్రభ అన్న పేరే బళ్లారికి చెందిన ఒక పాఠకుడు సూచించినది కావడం విశేషం. చక్కని పేరును సూచించినందుకుగాను ఆంధ్రప్రభను నిర్వహిస్తున్న నాటి ఇండియన్ ఎక్స్ ప్రెస్ యాజమాన్యం ఆ పాఠకుడికి రూ. 116 బహుమతి కూడా ఇచ్చింది. పాఠకులకు, ఆంధ్రప్రభకు మధ్య గల సంబంధానికి ఇది ఒక మచ్చుతునక.\n \n \n పాత్రికేయుల కులగురువు నార్ల వెంకటేశ్వర రావుగారు 1942 నుండి 1959 ‘ఆంధ్రప్రభ’ సంపాదకులుగా సారథ్యం వహించి తెలుగు జర్నలిజాన్ని వెలిగించారు. తుఫానులు, కరువులు వంటి ప్రాకృతిక విపత్తులు ఉప్పతిల్లినప్పుడు నార్లవారు ‘ఆంధ్రప్రభ’ ద్వారా విరాళాలు సేకరించి ఆపన్నులకు అందించారు. శ్రీయుతులు మహాకవి శ్రీశ్రీ, మల్లవరపు విశ్వేశ్వర రావు, న్యాపతి నారాయణ మూర్తి, నీలంరాజు వెంకట శేషయ్య, విద్వాన్ విశ్వం, పండితారాధ్యుల నాగేశ్వర రావు, కూచిమంచి సత్యసుబ్రహ్మణ్యం, జి కృష్ణ, వేటూరి, గొల్లపూడి మారుతీరావు, పొత్తూరి వెంకటేశ్వర రావు వంటి ఉద్ధండులెందరో ఆంధ్రప్రభ సంపాదక వర్గంలో పని చేశారు. తెలుగు జర్నలిజానికి ఒరవడి దిద్దిన ‘ఆంధ్రప్రభ’ చరిత్రలోని ప్రతి మలుపులోనూ తెలుగువారికి తోడుగా నిలిచింది. ఇప్పుడు ప్రచురితమౌతున్న తెలుగు దినపత్రికలలో నాటి నుండి నేటి దాకా ఎక్కడా అంతరాయం లేకుండా వెలువడుతూ వచ్చిన ఏకైక పత్రిక ఆంధ్రప్రభ మాత్రమే.\n \nతొల్దొలుత ఆంధ్రప్రభకు ఊపిరి పోసింది స్వర్గీయ రామ్ నాథ్ జీ గోయెంకా అయితే కొత్త జవసత్త్వాలను నింపింది మాజీ మంత్రి, ప్రస్తుత ప్రధాన సంపాదకులు శ్రీ ముత్తా గోపాలకృష్ణ . కొత్త సొబగులతో దానిని యువతరానికి చేరువ చేసేందుకు విద్యాధికులైన ‘ఆంధ్రప్రభ పబ్లికేషన్స్ లిమిటెడ్’ మేనేజింగ్ డైరెక్టర్ శ్రీ ముత్తా గౌతమ్ ఆధునిక సాంకేతిక పరిజ్ఞానాన్ని జోడిస్తున్నారు. ఇలా ప్రస్తుత యాజమాన్యం ఆధ్వర్యంలో ‘ఆంధ్రప్రభ’ ఉభయ రాష్ట్రాలలోని తెలుగువారి అభ్యుదయానికి పునరంకితం అవుతోంది.\n\nఅత్యుత్తమ ప్రమాణాలతో బహుళ జనాదరణ పొందిన వివిధ అనుబంధాలు:\n\n‘ఆంధ్రప్రభ’ ప్రధాన స్రవంతి వార్తలతో పాటు వివిధ వర్గాలకు సముచిత ప్రాధాన్యం ఇస్తూ వివిధ ప్రత్యేక అనుబంధాలను కూడా ప్రచురిస్తోంది. పాఠకాదరణ పొందిన విభిన్న సామాజిక కోణాల లైఫ్, మహిళా వేదిక ‘నాయిక’, ఆధ్యాత్మిక విశేషాల ‘చింతన’, సాంస్కృతిక అంశాలతో కూడిన ‘సంస్కృతి’, బాలల కోసం విజ్ఞానవినోదాలు పంచే ‘బాలప్రభ’, వైద్యఆరోగ్యాలపై విస్తృత సమాచారం అందించే ‘కులాసా’, వైవిధ్యంతో అలరారే ‘ఆదివారం ఆంధ్రప్రభ’, సినీవిశేషాల కదంబం ‘చిత్రప్రభ’, విద్యార్థుల, ఉద్యోగార్థుల కరదీపిక ‘విద్యాప్రభ’, విపణి తీరుతెన్నులను వివరించే ‘సిరిగమలు’ వంటివి ‘ఆంధ్రప్రభ’కు ప్రత్యేకాకర్షణలుగా నిలుస్తాయి. రోజూ ప్రచురించే సినీవార్తావిశేషాల ప్రత్యేక పేజీ ‘షో’, వ్యాపార, వాణిజ్య పరిణామాలను తెలిపే ‘బిజినెస్’ పేజీ వంటివి కూడా ‘ఆంధ్రప్రభ’కు అదనపు హంగులుగా సమకూరాయి.\n\n‘ఆంధ్రప్రభ’ హరివిల్లు :\n‘ఆంధ్రప్రభ’ వారంలోని అన్ని రోజుల్లోనూ వివిధ అంశాలపై ప్రత్యేక అనుబంధాలను ప్రచురిస్తోంది.\n\nఅవి :\n\n1.	‘లైఫ్’ – సమాజంలోని వివిధ కోణాలను సునిశిత అధ్యయనంతో పాఠకులకు అందించే అనుబంధం. వివిధ రంగాలకు చెందిన ప్రముఖుల ఇంటర్వ్యూలు, ఆసక్తిదాయకమైన వార్తావిశేషాలు ఇందులో ఉంటాయి. ఇది గురు, సోమవారాలు మినహా రోజూ రంగుల్లో వెలువడుతుంది. \n\n2.	చింతన : గురు, సోమవారాలు మినహా రోజూ వెలువడే ఈ ప్రత్యేకానుబంధం ఆధ్యాత్మిక, తాత్త్విక అంశాలను, పూజలు, దేవాలయాల వంటి భక్తి విశేషాలను అందిస్తుంది.  \n\n3.	సోమవారం : విద్యార్థి లోకానికి కరదీపికగా ఉండే ‘విద్యాప్రభ’ 12 పేజీలతో వెలువడుతుంది. ఉద్యోగ, ఉపాధి సమాచారం, వివిధ పోటీ పరీక్షలకు సన్నద్ధమయ్యేందుకు ఇది తోడ్పడుతుంది. సారస్వత ప్రత్యేకానుబంధంగా వెలువడే ‘సాహితీ గవాక్షం’ కూడా సోమవారం ప్రచురితమౌతుంది. కవులు, రచయితలకు, సాహితీవేత్తలకు వేదికగా నిలుస్తుంది. ఉత్తమ సాహిత్యానుబంధంగా ఇది పలు పురస్కారాలను సైతం గెలుచుకుంది. \n\n4.మంగళవారం : వైద్యఆరోగ్య అంశాలపై పాఠకులకు ఉపయుక్తమైన సమాచారాన్ని అందించే ‘కులాసా’ కూడా సోమవారం వెలువడుతుంది. హెల్త్ టిప్స్  తో పాటు ఆ వారం వైద్యరంగంలోని వార్తావిశేషాలను, వైద్యులు అందించే విలువైన వ్యాసాలను ఇది అందిస్తుంది. \n\n5.	బుధవారం : మహిళలకు సంబంధించిన ఉపయుక్త సమాచారాన్ని అందించే ‘నాయిక’ ప్రతి బుధవారం వెలువడుతుంది. మహిళల కెరీర్ కు ఉపకరించే అంశాలతో పాటు బ్యూటీ గైడ్, ఫ్యాషన్లు, కొత్త రుచుల వంటలు వంటివి ఇందులో ఉంటాయి.  \n\n6.	గురువారం : టాలివుడ్ విశేషాలతో వెలువడే ‘చిత్రప్రభ’ ప్రతి గురువారం 12 పేజీలతో ప్రచురితమౌతుంది. ఈ సినీ ప్రత్యేక అనుబంధానికి పాఠకాదరణతో పాటు సినీ ఇండస్ట్రీలో ప్రాచుర్యం ఉంది. ఇందులో హిందీ, తమిళ, కన్నడ, మలయాళ చిత్రసీమ విశేషాలూ ఉంటాయి. \n\n7.	శుక్రవారం : విపణి తీరుతెన్నులను విశ్లేషించే ప్రత్యేకానుబంధం ‘సిరిగమలు’ ప్రతి శుక్రవారం వెలువడుతుంది. ఆర్థిక రంగాన్ని విశ్లేషించే పలు విలువైన వ్యాసాలు ఇందులో ఉంటాయి. \n \n8.శనివారం : బాలలకు వినోదంతో పాటు విజ్ఞానాన్నిఅందించే ‘బాలప్రభ’ ప్రతి శుక్రవారం వెలువడుతుంది. \n\n9.	ఆదివారం : 32 పేజీలతో విభిన్న అంశాల సమాహారంగా వెలువడే ‘ఆదివారం ఆంధ్రప్రభ’కు పాఠకలోకంలో విశేష ఆదరణ ఉంది. విలక్షణతో కూడిన పఠనీయత దీని ప్రత్యేకత. వైవిధ్యంతో కూడిన భారతీయ సాంస్కృతిక వైభవానికి దర్పణంగా నిలిచే ‘సంస్కృతి’ కూడా ప్రతి ఆదివారం వెలువడుతుంది. \n\n10.	వివిధ జిల్లాలకు చెందిన టాబ్లాయిడ్స్ లో రోజూ ఆయా జిల్లాల స్థానికవార్తలు అందించడం జరుగుతుంది. స్థానిక సమస్యలపై ప్రత్యేక కథనాలు ఉంటాయి. \n \n11.	రాజకీయాలతో పాటు విద్యా, సాంస్కృతిక, సారస్వత, కళా, ఆధ్యాత్మిక రంగాలకు సమ ప్రాధాన్యం ఇవ్వడం ‘ఆంధ్రప్రభ’ విశిష్టత. సమాజంలో వ్యక్తిని ప్రభావితం చేసే అన్నిక్షేత్రాలకూ సముచిత స్థానం లభించాలన్నది ‘ఆంధ్రప్రభ’ అభిలాష. ఆంధ్రప్రభ పూర్తిగా పాఠకుల పత్రిక. వారి అభిరుచులకు వేదిక.";
        [textView setFont:[UIFont fontWithName:@"ArialMT" size:14]];
        
        [self.view addSubview:textView];
        
    }
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:73/230 green:92/60 blue:183/72 alpha:1.0];
    self.navigationController.navigationBar.translucent = YES;
    
}
- (void)ddMenuShow:(UIButton *)sender
{
    if (sender.tag == 0) {
        sender.tag = 1;
        jillaTV.hidden = NO;
        [sender setTitle:@"▼" forState:UIControlStateNormal];
    } else {
        sender.tag = 0;
        jillaTV.hidden = YES;
        [sender setTitle:@"▲" forState:UIControlStateNormal];
    }
}

- (void)startActivity:(NSString *)message {
    [SVProgressHUD showWithStatus:message maskType:SVProgressHUDMaskTypeGradient];
}

- (void)stopActivity {
    [SVProgressHUD dismiss];
}
#pragma mark -
#pragma mark - UIBarButtonItems

- (void)setupMenuBarButtonItems {
    if(self.menuContainerViewController.menuState == MFSideMenuStateClosed &&
       ![[self.navigationController.viewControllers objectAtIndex:0] isEqual:self]) {
        self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
    } else {
        self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
    }
}

- (UIBarButtonItem *)leftMenuBarButtonItem {
    
    return [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu-icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftSideMenuButtonPressed:)];
}
- (UIBarButtonItem *)backBarButtonItem {
    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-arrow"]
                                            style:UIBarButtonItemStylePlain target:self
                                           action:@selector(backButtonPressed:)];
}
#pragma mark -
#pragma mark - UIBarButtonItem Callbacks

- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftSideMenuButtonPressed:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        [self setupMenuBarButtonItems];
    }];
}


#pragma mark -
#pragma mark - tableViewDelegate and DataSource.
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[[UITableViewCell alloc]init];
    if (tableView==newsTableView) {
        NSString *CellIdentifier = @"Cell";
        
        NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.frame = CGRectMake(0, 0, newsTableView.frame.size.width-3, 70);
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.headingLbl.text =[titleArray objectAtIndex:indexPath.row];
        cell.bodyTextView.text=[bodyArray objectAtIndex:indexPath.row];
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:170.0f/255.0 green:170.0f/255.0 blue:170.0f/255.0 alpha:1.0f];
        [bgColorView.layer setBorderColor:[UIColor blackColor].CGColor];
        [bgColorView.layer setBorderWidth:1.0f];
        [cell setSelectedBackgroundView:bgColorView];
        
        NSString *imageUrlString = [urisArray objectAtIndex:indexPath.row];
        UIImage *cachedImage = [self.imageCache objectForKey:imageUrlString];
        if (cachedImage) {
            cell.imageView.image = cachedImage;
        } else {
            cell.imageView.image = [UIImage imageNamed:@"Andhra.jpg"];
            
            [self.imageDownloadingQueue addOperationWithBlock:^{
                
                NSURL *imageUrl   = [NSURL URLWithString:imageUrlString];
                NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
                UIImage *image    = nil;
                if (imageData)
                    image = [UIImage imageWithData:imageData];
                
                if (image) {
                    
                    [self.imageCache setObject:image forKey:imageUrlString];
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        
                        UITableViewCell *updateCell = [tableView cellForRowAtIndexPath:indexPath];
                        if (updateCell)
                            updateCell.imageView.image = image;
                    }];
                }
            }];
        }
        return cell;
        
    }
    
    
    if (tableView==jillaTV){
        NSString *CellIdentifier = @"Cell1";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
        cell.backgroundColor=[UIColor blackColor];

        UIFont *myFont = [ UIFont fontWithName: @"Arial" size: 18.0 ];
        cell.textLabel.font  = myFont;
        cell.textLabel.textColor=[UIColor colorWithRed:191/74 green:240/88 blue:28/94 alpha:1.0];
        cell.textLabel.text=[subJillaArrays objectAtIndex:indexPath.row];
        return cell;
    }
    else return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==newsTableView) {
        return titleArray.count;
    }
    if (tableView==jillaTV) {
        return subJillaArrays.count;
    }
    else return titleArray.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==newsTableView) {
        return 90;
    }
    if (tableView==jillaTV) {
        return 50;
    }
    else
        return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==newsTableView) {
        NSString * titleString=[titleArray objectAtIndex:indexPath.row];
        NSString * bodyString=[bodyArray objectAtIndex:indexPath.row];
        NSString * imageS=[urisArray objectAtIndex:indexPath.row];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageS]];
        if (tableView==jillaTV) {
            jillaTV.hidden=YES;
        }
        UIImage * string =[UIImage imageWithData:imageData];
        mainBody =[[MainBodyViewController alloc]initWithString:titleString bodyString:bodyString mainImage:string];
        [self.navigationController pushViewController:mainBody animated:YES];
        
    }

    if (tableView==jillaTV) {
        UITableViewCell * cell=[[UITableViewCell alloc]init];
        NSLog(@"subjilla Arrays are %@",[subJillaArrays objectAtIndex:indexPath.row]);
        cell.textLabel.text=[subJillaArrays objectAtIndex:indexPath.row];
        jillaTextField.text=cell.textLabel.text;
        self.title=cell.textLabel.text;
         NSLog(@"cell textlabel is given as %@",cell.textLabel.text);
        for (NSDictionary *item in allTitlesTidArrays) {
           
            if ([[item objectForKey:@"link_title"]isEqualToString:cell.textLabel.text]) {
        int tidValue = [[item objectForKey:@"tid"] intValue];
                NSLog(@" tid: %i",tidValue);
                myTid=tidValue;
                [self loadFromServer:myTid];
                jillaTV.hidden=YES;
                [rightPadding setTitle:@"▲" forState:UIControlStateNormal];
            }
        }
    
}
}



@end
