//
//  STMBTCentralManager.h
//  STMBTDataTransfer
//
//  Created by Maxim Grigoriev on 05/05/16.
//  Copyright © 2016 Sistemium UAB. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STMBTConstants.h"
#import "STMBTCentralManagerDelegate.h"


@interface STMBTCentralManager : NSObject

@property (nonatomic, strong) id <STMBTCentralManagerDelegate> delegate;

+ (STMBTCentralManager *)sharedController;

+ (void)startScanForServiceWithUUID:(NSString *)serviceUUID;
+ (void)stopScan;

+ (void)connectPeripheral:(CBPeripheral *)peripheral;

+ (NSArray *)connectedPeripherals;


@end
