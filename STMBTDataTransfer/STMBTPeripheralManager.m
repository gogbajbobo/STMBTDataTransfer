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
@property (nonatomic, strong) CBUUID *characteristicUUID;
@property (nonatomic, strong) CBMutableCharacteristic *characteristic;


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

- (void)startServiceWithUUID:(CBUUID *)serviceUUID andCharacteristicUUID:(CBUUID *)characteristicUUID {
    
    if (self.peripheralManager.state == CBPeripheralManagerStatePoweredOn) {
        
        CBCharacteristicProperties chProperties = CBCharacteristicPropertyRead | CBCharacteristicPropertyWrite | CBCharacteristicPropertyNotify;
        CBAttributePermissions chPermission = CBAttributePermissionsReadable | CBAttributePermissionsWriteable;
        
        self.characteristic = [[CBMutableCharacteristic alloc] initWithType:characteristicUUID
                                                                 properties:chProperties
                                                                      value:nil
                                                                permissions:chPermission];
        
        CBMutableService *service = [[CBMutableService alloc] initWithType:self.serviceUUID
                                                                   primary:YES];
        
        service.characteristics = @[self.characteristic];
        
        [self.peripheralManager addService:service];
        
        [self.peripheralManager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey: @[self.serviceUUID]}];
        
    }

}

- (void)stopService {
    
    [self.peripheralManager stopAdvertising];
    [self.peripheralManager removeAllServices];
    
    self.serviceUUID = nil;
    self.characteristicUUID = nil;

}


#pragma mark - setters & getters



#pragma mark - class methods

+ (void)startServiceWithUUID:(NSString *)serviceUUID andCharacteristicUUID:(NSString *)characteristicUUID {

    STMBTPeripheralManager *sc = [self sharedController];

    sc.serviceUUID = [CBUUID UUIDWithString:serviceUUID];
    sc.characteristicUUID = [CBUUID UUIDWithString:characteristicUUID];
    
    [[self sharedController] startServiceWithUUID:sc.serviceUUID andCharacteristicUUID:sc.characteristicUUID];
    
}

+ (void)stopService {
    [[self sharedController] stopService];
}

+ (void)updateValue:(NSData *)newValue {
    
//    NSDictionary *value = @{@"result"   : @"ok",
//                            @"timestamp": [NSString stringWithFormat:@"%@", [NSDate date]]};
//    
//    newValue = [NSJSONSerialization dataWithJSONObject:value options:0 error:nil];
    
//    [self sharedController].characteristic.value = newValue;

    [[self sharedController].peripheralManager updateValue:newValue forCharacteristic:[self sharedController].characteristic onSubscribedCentrals:nil];
    
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
            
            if (self.serviceUUID && self.characteristicUUID) {
                [self startServiceWithUUID:self.serviceUUID andCharacteristicUUID:self.characteristicUUID];
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

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {
    
    NSLog(@"peripheral didSubscribeToCharacteristic");
    
    [self.delegate successfullyConnected];
    
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request {
    
    NSLog(@"peripheral didReceiveReadRequest %@", request);
    
    if ([self.characteristicUUID isEqual:request.characteristic.UUID]) {
        
//        [[self class] updateValue:nil];
        
        request.value = self.characteristic.value;
        
        [self.peripheralManager respondToRequest:request withResult:CBATTErrorSuccess];
        
    }
    
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray<CBATTRequest *> *)requests {
    
    NSLog(@"peripheral didReceiveWriteRequests %@", requests);
    
    for (CBATTRequest *request in requests) {
        
        if ([self.characteristicUUID isEqual:request.characteristic.UUID]) {

            [self.peripheralManager updateValue:request.value forCharacteristic:self.characteristic onSubscribedCentrals:nil];

            id value = [NSJSONSerialization JSONObjectWithData:request.value options:NSJSONReadingMutableContainers error:nil];

            NSInteger index = [[value valueForKey:@"index"] integerValue];
            
            NSDictionary *newValue = @{@"index" : @(index),
                                       @"byMe"  : @(NO)};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"indexWasPlayed"
                                                                object:self
                                                              userInfo:newValue];

            [self.peripheralManager respondToRequest:request withResult:CBATTErrorSuccess];
            
        }

    }
    
}


@end
