//
//  STMBTCentralManagerTVC.m
//  STMBTDataTransfer
//
//  Created by Maxim Grigoriev on 05/05/16.
//  Copyright © 2016 Sistemium UAB. All rights reserved.
//

#import "STMBTCentralManagerTVC.h"


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


#pragma mark - STMBTCentralManagerDelegate

- (void)didDiscoverPeripheral:(CBPeripheral *)peripheral {
    
    [self.tableData addObject:peripheral];
    [self.tableView reloadData];
    
}

- (void)didConnectPeripheral:(CBPeripheral *)peripheral {
    [self reloadCellWithPeripheral:peripheral];
}

- (void)didFailToConnectPeripheral:(CBPeripheral *)peripheral {
    [self reloadCellWithPeripheral:peripheral];
}

- (void)didDisconnectPeripheral:(CBPeripheral *)peripheral {
    [self reloadCellWithPeripheral:peripheral];
}

- (void)reloadCellWithPeripheral:(CBPeripheral *)peripheral {

    NSUInteger peripheralIndex = [self.tableData indexOfObject:peripheral];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:peripheralIndex inSection:0];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
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
        
        CBPeripheral *peripheral = self.tableData[indexPath.row];
        
        cell.textLabel.text = peripheral.name;
        
        cell.accessoryType = ([[STMBTCentralManager connectedPeripherals] containsObject:peripheral]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.tableData.count > indexPath.row) {
        
        CBPeripheral *peripheral = self.tableData[indexPath.row];
        [STMBTCentralManager connectPeripheral:peripheral];
        
    }
    
}


#pragma mark - view lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[self cellIdentifier]];
    
    [STMBTCentralManager sharedController].delegate = self;
    [STMBTCentralManager startScanForServiceWithUUID:SERVICE_UUID];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if ([self isMovingFromParentViewController]) {
        [STMBTCentralManager stopScan];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
