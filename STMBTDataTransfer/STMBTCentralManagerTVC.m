//
//  STMBTCentralManagerTVC.m
//  STMBTDataTransfer
//
//  Created by Maxim Grigoriev on 05/05/16.
//  Copyright © 2016 Sistemium UAB. All rights reserved.
//

#import "STMBTCentralManagerTVC.h"

#import "STMBTCentralManager.h"


@interface STMBTCentralManagerTVC ()

@property (nonatomic, strong) NSMutableArray *tableData;


@end


@implementation STMBTCentralManagerTVC

- (NSString *)cellIdentifier {
    return @"STMBTCentralManagerTVCell";
}

- (NSMutableArray *)tableData {
    
    if (!_tableData) {
        _tableData = @[].mutableCopy;
    }
    return _tableData;
    
}

- (void)didDiscoverPeripheral:(NSNotification *)notification {
    
    [self.tableData addObject:notification.userInfo];
    [self.tableView reloadData];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifier] forIndexPath:indexPath];

    if (self.tableData.count > indexPath.row) {
        
        NSDictionary *cellData = self.tableData[indexPath.row];
        
        cell.textLabel.text = cellData[@"name"];

    }
    
    return cell;
    
}


#pragma mark - view lifecycle

- (void)addObservers {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didDiscoverPeripheral:)
                                                 name:PERIPHERAL_DISCOVER_NOTIFICATION
                                               object:[STMBTCentralManager sharedController]];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[self cellIdentifier]];
    
    [self addObservers];
    [STMBTCentralManager startScanForServiceWithUUID:SERVICE_UUID];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
