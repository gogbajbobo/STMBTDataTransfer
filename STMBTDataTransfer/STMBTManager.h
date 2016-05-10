//
//  STMBTManager.h
//  STMBTDataTransfer
//
//  Created by Maxim Grigoriev on 10/05/16.
//  Copyright © 2016 Sistemium UAB. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STMBTCentralManager.h"
#import "STMBTPeripheralManager.h"


@interface STMBTManager : NSObject

@property (nonatomic, strong) STMBTCentralManager *centralManager;
@property (nonatomic, strong) STMBTPeripheralManager *peripheralManager;

+ (STMBTManager *)sharedController;


@end
