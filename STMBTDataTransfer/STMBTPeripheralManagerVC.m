//
//  STMBTPeripheralManagerVC.m
//  STMBTDataTransfer
//
//  Created by Maxim Grigoriev on 05/05/16.
//  Copyright © 2016 Sistemium UAB. All rights reserved.
//

#import "STMBTPeripheralManagerVC.h"

#import "STMBTPeripheralManager.h"


@implementation STMBTPeripheralManagerVC

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [STMBTPeripheralManager startAdvertisingServiceWithUUID:SERVICE_UUID];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if ([self isMovingFromParentViewController]) {
        [STMBTPeripheralManager stopAdvertising];
    }
    
}

@end
