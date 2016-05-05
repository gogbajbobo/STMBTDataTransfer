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
@property (nonatomic, strong) NSString *serviceUUID;


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


#pragma mark - setters & getters


#pragma mark - class methods

+ (void)startAdvertisingServiceWithUUID:(NSString *)serviceUUID {
    
    STMBTPeripheralManager *sc = [self sharedController];
    
    sc.serviceUUID = serviceUUID;
    
    if (sc.peripheralManager.state == CBPeripheralManagerStatePoweredOn) {
        [sc.peripheralManager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey: @[[CBUUID UUIDWithString:sc.serviceUUID]]}];
    }
    
}

+ (void)stopAdvertising {
    [[self sharedController].peripheralManager stopAdvertising];
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
            
            if (self.serviceUUID) {
                [self.peripheralManager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey: @[[CBUUID UUIDWithString:self.serviceUUID]]}];
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
