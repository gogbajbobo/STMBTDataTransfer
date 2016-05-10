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
#import "STMBTPeripheralManagerDelegate.h"


@interface STMBTPeripheralManager : NSObject

@property (nonatomic, strong) id <STMBTPeripheralManagerDelegate> delegate;

+ (STMBTPeripheralManager *)sharedController;

+ (void)startServiceWithUUID:(NSString *)serviceUUID andCharacteristicUUID:(NSString *)characteristicUUID;
+ (void)stopService;

+ (void)updateValue:(NSData *)newValue;


@end
