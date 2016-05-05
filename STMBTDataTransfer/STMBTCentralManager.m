//
//  STMBTCentralManager.m
//  STMBTDataTransfer
//
//  Created by Maxim Grigoriev on 05/05/16.
//  Copyright © 2016 Sistemium UAB. All rights reserved.
//

#import "STMBTCentralManager.h"


@interface STMBTCentralManager() <CBCentralManagerDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBUUID *serviceUUID;


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


#pragma mark - class methods

+ (void)startScanForServiceWithUUID:(NSString *)serviceUUID {
    
    STMBTCentralManager *sc = [self sharedController];

    sc.serviceUUID = [CBUUID UUIDWithString:serviceUUID];
    
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
    
    STMBTCentralManager *sc = [self sharedController];

    return [sc.centralManager retrieveConnectedPeripheralsWithServices:@[sc.serviceUUID]];
    
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
    
    [self.delegate didConnectPeripheral:peripheral];

}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    NSLog(@"Fail to connect %@ with UUID %@", peripheral.name, peripheral.identifier);
    
    [self.delegate didFailToConnectPeripheral:peripheral];

}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    NSLog(@"Disconnect %@ with UUID %@", peripheral.name, peripheral.identifier);
    
    [self.delegate didDisconnectPeripheral:peripheral];
    
}


@end
