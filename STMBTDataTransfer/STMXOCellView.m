//
//  STMXOCellView.m
//  STMBTDataTransfer
//
//  Created by Maxim Grigoriev on 07/05/16.
//  Copyright © 2016 Sistemium UAB. All rights reserved.
//

#import "STMXOCellView.h"


@implementation STMXOCellView

- (instancetype)initWithCoder:(NSCoder *)decoder {
    
    self = [super initWithCoder:decoder];
    
    if (self) {
        [self addTapGesture];
    }
    
    return self;
    
}

- (void)addTapGesture {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewWasTapped)];
    [self addGestureRecognizer:tap];
    
}

- (void)viewWasTapped {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gameCellWasTapped" object:self];
}


@end
