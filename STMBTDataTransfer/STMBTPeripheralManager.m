//
//  STMBTPeripheralManager.m
//  STMBTDataTransfer
//
//  Created by Maxim Grigoriev on 05/05/16.
//  Copyright © 2016 Sistemium UAB. All rights reserved.
//

#import "STMBTPeripheralManager.h"

@interface STMBTPeripheralManager() <CBPeripheralManagerDelegate>

@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
@property (nonatomic, strong) CBUUID *serviceUUID;
@property (nonatomic, strong) NSArray <CBUUID *> *characteristicUUIDs;


@end


@implementation STMBTPeripheralManager


+ (STMBTPeripheralManager *)sharedController {
    
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
        
        self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                         queue:nil
                                                                       options:@{CBPeripheralManagerOptionShowPowerAlertKey: @(YES)}];
        
    }
    
    return self;
    
}

- (void)startServiceWithUUID:(CBUUID *)serviceUUID andCharacteristicUUIDs:(NSArray <CBUUID *> *)characteristicUUIDs {
    
    if (self.peripheralManager.state == CBPeripheralManagerStatePoweredOn) {
        
        NSMutableArray *chars = @[].mutableCopy;
        
        for (CBUUID *uuid in self.characteristicUUIDs) {
            
            CBMutableCharacteristic *characteristic = [[CBMutableCharacteristic alloc] initWithType:uuid
                                                                                         properties:CBCharacteristicPropertyNotify
                                                                                              value:nil
                                                                                        permissions:CBAttributePermissionsReadable];
            
            [chars addObject:characteristic];
            
        }
        
        CBMutableService *service = [[CBMutableService alloc] initWithType:self.serviceUUID
                                                                   primary:YES];
        
        service.characteristics = chars;
        
        [self.peripheralManager addService:service];
        
        [self.peripheralManager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey: @[self.serviceUUID]}];
        
    }

}

- (void)stopService {
    
    [self.peripheralManager stopAdvertising];
    [self.peripheralManager removeAllServices];
    
    self.serviceUUID = nil;
    self.characteristicUUIDs = nil;

}


#pragma mark - setters & getters


#pragma mark - class methods

+ (void)startServiceWithUUID:(NSString *)serviceUUID andCharacteristicUUIDs:(NSArray <NSString *> *)characteristicUUIDs {

    STMBTPeripheralManager *sc = [self sharedController];

    sc.serviceUUID = [CBUUID UUIDWithString:serviceUUID];
    
    NSMutableArray *charUUIDs = @[].mutableCopy;
    
    for (NSString *uuid in characteristicUUIDs) {
        [charUUIDs addObject:[CBUUID UUIDWithString:uuid]];
    }
    
    sc.characteristicUUIDs =  charUUIDs;

    [[self sharedController] startServiceWithUUID:sc.serviceUUID andCharacteristicUUIDs:sc.characteristicUUIDs];
    
}

+ (void)stopService {
    [[self sharedController] stopService];
}


#pragma mark - CBPeripheralManagerDelegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    
    switch (peripheral.state) {
        case CBPeripheralManagerStateUnknown: {
            
            break;
        }
        case CBPeripheralManagerStateResetting: {
            
            break;
        }
        case CBPeripheralManagerStateUnsupported: {
            
            break;
        }
        case CBPeripheralManagerStateUnauthorized: {
            
            break;
        }
        case CBPeripheralManagerStatePoweredOff: {
            
            break;
        }
        case CBPeripheralManagerStatePoweredOn: {
            
            if (self.serviceUUID && self.characteristicUUIDs) {
                [self startServiceWithUUID:self.serviceUUID andCharacteristicUUIDs:self.characteristicUUIDs];
            }
            
            break;
        }
    }
    
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    
    if (error) {
        NSLog(@"peripheralManagerDidStartAdvertising error: %@", error.localizedDescription);
    }
    
}


@end
