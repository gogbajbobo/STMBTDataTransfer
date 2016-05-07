//
//  STMXOFieldVC.m
//  STMBTDataTransfer
//
//  Created by Maxim Grigoriev on 07/05/16.
//  Copyright © 2016 Sistemium UAB. All rights reserved.
//

#import "STMXOFieldVC.h"

#import "STMXOCellView.h"


@implementation STMXOFieldVC

- (void)gameCellWasTapped:(NSNotification *)notification {
    
    if ([notification.object isKindOfClass:[STMXOCellView class]]) {
        
        STMXOCellView *cellView = (STMXOCellView *)notification.object;
        
        NSInteger index = cellView.tag;
        
        [self index:index wasOccupiedByMe:YES];
        
    }
    
}

- (void)index:(NSInteger)index wasOccupiedByMe:(BOOL)byMe {
    
    STMXOCellView *cellView = [self.view viewWithTag:index];
    
    NSString *imageName = (byMe) ? @"XOX.png" : @"XOO.png";
    UIImage *image = [UIImage imageNamed:imageName];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cellView.bounds];
    imageView.image = image;
    
    [cellView addSubview:imageView];
    
}


#pragma mark - view lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameCellWasTapped:)
                                                 name:@"gameCellWasTapped"
                                               object:nil];
    
}


@end
