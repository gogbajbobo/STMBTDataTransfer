//
//  STMBTCentralManagerDelegate.h
//  STMBTDataTransfer
//
//  Created by Maxim Grigoriev on 05/05/16.
//  Copyright © 2016 Sistemium UAB. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreBluetooth/CoreBluetooth.h>


@protocol STMBTCentralManagerDelegate <NSObject>

- (void)didDiscoverPeripheral:(CBPeripheral *)peripheral;

- (void)didConnectPeripheral:(CBPeripheral *)peripheral;
- (void)didFailToConnectPeripheral:(CBPeripheral *)peripheral;
- (void)didDisconnectPeripheral:(CBPeripheral *)peripheral;


@end
