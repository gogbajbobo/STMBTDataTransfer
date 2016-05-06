//
//  STMBTPeripheralManager.h
//  STMBTDataTransfer
//
//  Created by Maxim Grigoriev on 05/05/16.
//  Copyright © 2016 Sistemium UAB. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreBluetooth/CoreBluetooth.h>
#import "STMBTConstants.h"


@interface STMBTPeripheralManager : NSObject

+ (STMBTPeripheralManager *)sharedController;

+ (void)startServiceWithUUID:(NSString *)serviceUUID andCharacteristicUUIDs:(NSArray <NSString *> *)characteristicUUIDs;
+ (void)stopService;

+ (void)updateValue:(NSData *)newValue forServiceUUID:(NSString *)serviceUUID withCharacteristicUUID:(NSString *)characteristicUUID;


@end
