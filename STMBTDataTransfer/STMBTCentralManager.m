//
//  STMBTCentralManager.m
//  STMBTDataTransfer
//
//  Created by Maxim Grigoriev on 05/05/16.
//  Copyright © 2016 Sistemium UAB. All rights reserved.
//

#import "STMBTCentralManager.h"


@interface STMBTCentralManager() <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBUUID *serviceUUID;
@property (nonatomic, strong) NSArray <CBUUID *> *characteristicUUIDs;
@property (nonatomic, strong) NSMutableArray *connectedPeripherals;


@end


@implementation STMBTCentralManager


+ (STMBTCentralManager *)sharedController {
    
    static dispatch_once_t pred = 0;
    __strong static id _sharedController = nil;
    
    dispatch_once(&pred, ^{
        _sharedController = [[self alloc] init];
    });
    
    return _sharedController;
    
}


#pragma mark - instance methods

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self
                                                                   queue:nil
                                                                 options:@{CBCentralManagerOptionShowPowerAlertKey: @(YES)}];
        
    }
    
    return self;
    
}


#pragma mark - setters & getters

- (NSMutableArray *)connectedPeripherals {
    
    if (!_connectedPeripherals) {
        _connectedPeripherals = @[].mutableCopy;
    }
    return _connectedPeripherals;
    
}

#pragma mark - class methods

+ (void)startScanForServiceWithUUID:(NSString *)serviceUUID withCharacteristicUUIDs:(NSArray <NSString *> *)characteristicUUIDs {
    
    STMBTCentralManager *sc = [self sharedController];

    sc.serviceUUID = [CBUUID UUIDWithString:serviceUUID];
    
    NSMutableArray *charUUIDs = @[].mutableCopy;
    
    for (NSString *uuid in characteristicUUIDs) {
        [charUUIDs addObject:[CBUUID UUIDWithString:uuid]];
    }
    
    sc.characteristicUUIDs =  charUUIDs;

    if (sc.centralManager.state == CBCentralManagerStatePoweredOn) {
        
        [sc.centralManager scanForPeripheralsWithServices:@[sc.serviceUUID] options:nil];
        
    }
    
}

+ (void)stopScan {
    [[self sharedController].centralManager stopScan];
}

+ (void)connectPeripheral:(CBPeripheral *)peripheral {
    
    STMBTCentralManager *sc = [self sharedController];

    if (sc.centralManager.state == CBCentralManagerStatePoweredOn) {
        [sc.centralManager connectPeripheral:peripheral options:nil];
    }
    
}

+ (NSArray *)connectedPeripherals {
    return [self sharedController].connectedPeripherals.copy;
}


#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    switch (central.state) {
        case CBCentralManagerStateUnknown: {
            
            break;
        }
        case CBCentralManagerStateResetting: {
            
            break;
        }
        case CBCentralManagerStateUnsupported: {
            
            break;
        }
        case CBCentralManagerStateUnauthorized: {
            
            break;
        }
        case CBCentralManagerStatePoweredOff: {
            
            break;
        }
        case CBCentralManagerStatePoweredOn: {
            
            if (self.serviceUUID) {
                [self.centralManager scanForPeripheralsWithServices:@[self.serviceUUID] options:nil];
            }
            
            break;
        }
    }
    
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSLog(@"Discovered %@ with UUID %@ at %@", peripheral.name, peripheral.identifier, RSSI);
    
    [self.delegate didDiscoverPeripheral:peripheral];

}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    NSLog(@"Connect %@ with UUID %@", peripheral.name, peripheral.identifier);
    
    peripheral.delegate = self;
    
    [peripheral discoverServices:@[self.serviceUUID]];
    
    [self.delegate didConnectPeripheral:peripheral];

}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    NSLog(@"Fail to connect %@ with UUID %@", peripheral.name, peripheral.identifier);
    
    [self.delegate didFailToConnectPeripheral:peripheral];

}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    NSLog(@"Disconnect %@ with UUID %@", peripheral.name, peripheral.identifier);
    
    peripheral.delegate = nil;
#warning should remove notification subscription
    
    [self.connectedPeripherals removeObject:peripheral];
    [self.delegate didDisconnectPeripheral:peripheral];
    
}


#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    
    if (error) {
        
        NSLog(@"peripheral didDiscoverServices error: %@", error.localizedDescription);
        return;
        
    }
    
    for (CBService *service in peripheral.services) {
        
        NSLog(@"Discovered service %@", service);
        
        if ([service.UUID isEqual:self.serviceUUID]) {
            
            [peripheral discoverCharacteristics:self.characteristicUUIDs forService:service];
            
        }
        
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    
    if (error) {
        
        NSLog(@"peripheral didDiscoverCharacteristicsForService error: %@", error.localizedDescription);
        return;
        
    }

    if ([service.UUID isEqual:self.serviceUUID]) {
        
        for (CBCharacteristic *characteristic in service.characteristics) {
            
            NSLog(@"Discovered characteristic %@", characteristic);
            
            if ([self.characteristicUUIDs containsObject:characteristic.UUID]) {
                
                if (characteristic.properties & CBCharacteristicPropertyNotify) {
                    
                    [self.connectedPeripherals addObject:peripheral];
                    
                    [peripheral readValueForCharacteristic:characteristic];

                }
                
            }
            
        }

    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error {
    
    if (error) {
        
        NSLog(@"peripheral didUpdateValueForCharacteristic error: %@", error.localizedDescription);
        return;

    }
    
    if ([self.connectedPeripherals containsObject:peripheral]) {
        
        NSLog(@"characteristic.value %@ for peripheral %@", characteristic.value, peripheral.name);
        
        if (!characteristic.isNotifying) {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
        
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if (error) {
        
        NSLog(@"peripheral didUpdateNotificationStateForCharacteristic error: %@", error.localizedDescription);
        return;
        
    }

    
    if ([self.connectedPeripherals containsObject:peripheral]) {
        
        NSLog(@"characteristic isNotifying %@ for peripheral %@", @(characteristic.isNotifying), peripheral.name);
        
    }
    
}


@end
