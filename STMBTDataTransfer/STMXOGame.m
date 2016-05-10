//
//  STMXOGame.m
//  STMBTDataTransfer
//
//  Created by Maxim Grigoriev on 07/05/16.
//  Copyright © 2016 Sistemium UAB. All rights reserved.
//

#import "STMXOGame.h"

@interface STMXOGame()

@property (nonatomic, strong) NSMutableArray *occupiedCells;


@end


@implementation STMXOGame

+ (STMXOGame *)sharedGame {
    
    static dispatch_once_t pred = 0;
    __strong static id _sharedGame = nil;
    
    dispatch_once(&pred, ^{
        _sharedGame = [[self alloc] init];
    });
    
    return _sharedGame;
    
}

- (void)flushGame {
    self.occupiedCells = nil;
}

- (NSMutableArray *)occupiedCells {
    
    if (!_occupiedCells) {
        _occupiedCells = @[].mutableCopy;
    }
    return _occupiedCells;
    
}

- (NSArray *)availableIndexes {
    return @[@(11),@(12),@(13),@(21),@(22),@(23),@(31),@(32),@(33)];
}

- (void)index:(NSInteger)index wasPlayedByMe:(BOOL)byMe {
    
    if ([[self availableIndexes] containsObject:@(index)]) {
        
        if (![self.occupiedCells containsObject:@(index)]) {
            
            [self.occupiedCells addObject:@(index)];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"indexWasPlayed"
                                                                object:self
                                                              userInfo:@{@"index": @(index), @"byMe": @(byMe)}];
            
        }
        
    }
    
}


@end
