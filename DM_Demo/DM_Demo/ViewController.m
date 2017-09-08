//
//  ViewController.m
//  DM_Demo
//
//  Created by 陈祖发 on 2017/9/5.
//  Copyright © 2017年 Copyright (c) 2017 1tu1shu. All rights reserved. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    NSArray *_items;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"admuing";
    _items = @[@"unity",@"vungle"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idetifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idetifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idetifier];
    }
    cell.textLabel.text = [_items objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"UnityVideo" sender:self];
    }else if (indexPath.row == 1){
        [self performSegueWithIdentifier:@"VungleVideo" sender:self];
    }
}

#pragma mark -- Delegate


@end
