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

+ (void)startAdvertisingServiceWithUUID:(NSString *)serviceUUID;
+ (void)stopAdvertising;


@end
