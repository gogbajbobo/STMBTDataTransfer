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
@property (nonatomic, strong) NSString *serviceUUID;


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

- (NSMutableArray *)discoveredPeripherals {
    
    if (!_discoveredPeripherals) {
        _discoveredPeripherals = @[].mutableCopy;
    }
    return _discoveredPeripherals;
    
}


#pragma mark - class methods

+ (void)startScanForServiceWithUUID:(NSString *)serviceUUID {
    
    STMBTCentralManager *sc = [self sharedController];

    sc.serviceUUID = serviceUUID;
    
    if (sc.centralManager.state == CBCentralManagerStatePoweredOn) {
        
        [sc.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:sc.serviceUUID]] options:nil];
        
    }
    
}

+ (void)stopScan {
    [[self sharedController].centralManager stopScan];
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
                [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:self.serviceUUID]] options:nil];
            }
            
            break;
        }
    }
    
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSLog(@"Discovered %@ at %@", peripheral.name, RSSI);
    
    NSDictionary *userInfo = @{@"identifier"    : peripheral.identifier,
                               @"name"          : peripheral.name};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PERIPHERAL_DISCOVER_NOTIFICATION object:self userInfo:userInfo];
    
    [self.discoveredPeripherals addObject:peripheral];
    
}



@end
