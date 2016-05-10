//
//  STMXOGame.m
//  STMBTDataTransfer
//
//  Created by Maxim Grigoriev on 07/05/16.
//  Copyright © 2016 Sistemium UAB. All rights reserved.
//

#import "STMXOGame.h"

@interface STMXOGame()

@property (nonatomic, strong) NSMutableDictionary *occupiedCells;
@property (nonatomic) BOOL lastMoveByMe;

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

- (NSMutableDictionary *)occupiedCells {
    
    if (!_occupiedCells) {
        _occupiedCells = @{}.mutableCopy;
    }
    return _occupiedCells;
    
}

- (NSArray *)availableIndexes {
    return @[@(11),@(12),@(13),@(21),@(22),@(23),@(31),@(32),@(33)];
}

- (NSArray *)winningIndexes {
    
    return @[@[@(11), @(12), @(13)],
             @[@(21), @(22), @(23)],
             @[@(31), @(32), @(33)],
             @[@(11), @(21), @(31)],
             @[@(12), @(22), @(32)],
             @[@(13), @(23), @(33)],
             @[@(11), @(22), @(33)],
             @[@(13), @(22), @(31)]];
    
}

- (void)index:(NSInteger)index wasPlayedByMe:(BOOL)byMe {
    
    if (self.lastMoveByMe != byMe || self.occupiedCells.allKeys.count == 0) {

        if ([[self availableIndexes] containsObject:@(index)]) {
            
            if (![self.occupiedCells.allKeys containsObject:@(index)]) {
                
                self.occupiedCells[@(index)] = @(byMe);
                
                self.lastMoveByMe = byMe;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"indexWasPlayed"
                                                                    object:self
                                                                  userInfo:@{@"index": @(index), @"byMe": @(byMe)}];
                
                [self analyzeField];
                
            }
            
        }
        
    }

}

- (void)analyzeField {
    
    if (self.occupiedCells.allKeys.count > 4) {
        
        NSSet *myFields = [self.occupiedCells keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
            return [obj boolValue];
        }];

        NSSet *oppFields = [self.occupiedCells keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
            return ![obj boolValue];
        }];

        for (NSArray *winIndexes in [self winningIndexes]) {
            
            NSSet *winSet = [NSSet setWithArray:winIndexes];
            
            if ([winSet isSubsetOfSet:myFields]) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WIN!"
                                                                    object:self];

            }

            if ([winSet isSubsetOfSet:oppFields]) {

                [[NSNotificationCenter defaultCenter] postNotificationName:@"LOSE!"
                                                                    object:self];

            }

        }
        
    }
    
}


@end
