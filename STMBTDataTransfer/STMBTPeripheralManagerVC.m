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


- (IBAction)updateButtonPressed:(id)sender {
    [STMBTPeripheralManager updateValue:nil];
}


#pragma mark - view lifecycle

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [STMBTPeripheralManager startServiceWithUUID:SERVICE_UUID andCharacteristicUUID:CHARACTERISTIC_UUID];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if ([self isMovingFromParentViewController]) {
        [STMBTPeripheralManager stopService];
    }
    
}

@end
