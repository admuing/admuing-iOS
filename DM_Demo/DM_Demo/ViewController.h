//
//  ViewController.h
//  DM_Demo
//
//  Created by 陈祖发 on 2017/9/5.
//  Copyright © 2017年 Copyright (c) 2017 1tu1shu. All rights reserved. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic , strong)IBOutlet UITableView *tableView;

@end

