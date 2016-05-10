//
//  STMBTManager.m
//  STMBTDataTransfer
//
//  Created by Maxim Grigoriev on 10/05/16.
//  Copyright © 2016 Sistemium UAB. All rights reserved.
//

#import "STMBTManager.h"

#import "STMXOGame.h"


@implementation STMBTManager

+ (STMBTManager *)sharedController {
    
    static dispatch_once_t pred = 0;
    __strong static id _sharedController = nil;
    
    dispatch_once(&pred, ^{
        _sharedController = [[self alloc] init];
    });
    
    return _sharedController;
    
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        [self addObservers];
    }
    
    return self;
    
}

- (void)addObservers {

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(indexWasPlayed:)
                                                 name:@"indexWasPlayed"
                                               object:nil];
    
}

- (void)indexWasPlayed:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    
    NSInteger index = [userInfo[@"index"] integerValue];
    BOOL byMe = [userInfo[@"byMe"] boolValue];
    
    if (byMe) {
        
        NSDictionary *value = @{@"index": @(index)};
        
        NSData *newValue = [NSJSONSerialization dataWithJSONObject:value options:0 error:nil];
        
        if (self.centralManager) [STMBTCentralManager updateValue:newValue];
        if (self.peripheralManager) [STMBTPeripheralManager updateValue:newValue];

    } else {
        
        if (![notification.object isEqual:[STMXOGame sharedGame]]) {
            [[STMXOGame sharedGame] index:index wasPlayedByMe:byMe];
        }
        
    }
    
}


@end
