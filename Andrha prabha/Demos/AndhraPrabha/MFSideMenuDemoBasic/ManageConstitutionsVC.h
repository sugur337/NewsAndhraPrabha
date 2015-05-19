//
//  ManageConstitutionsVC.h
//  AndhraPrabha
//
//  Created by admin on 5/18/15.
//  Copyright (c) 2015 University of Wisconsin - Madison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManageConstitutionsVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView * constitutionTV;
@property (nonatomic,strong) NSMutableArray *constitutionArrays;
@end
