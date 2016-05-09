//
//  STMXOFieldVC.m
//  STMBTDataTransfer
//
//  Created by Maxim Grigoriev on 07/05/16.
//  Copyright © 2016 Sistemium UAB. All rights reserved.
//

#import "STMXOFieldVC.h"

#import "STMXOCellView.h"
#import "STMXOGame.h"


@interface STMXOFieldVC()

@property (nonatomic, strong) STMXOGame *game;


@end


@implementation STMXOFieldVC

- (void)gameCellWasTapped:(NSNotification *)notification {
    
    if ([notification.object isKindOfClass:[STMXOCellView class]]) {
        
        STMXOCellView *cellView = (STMXOCellView *)notification.object;
        
        NSInteger index = cellView.tag;
        
        [self.game index:index wasPlayedByMe:YES];
        
    }
    
}

- (void)indexWasPlayed:(NSNotification *)notification {
    
    NSInteger index = [notification.userInfo[@"index"] integerValue];
    BOOL byMe = [notification.userInfo[@"index"] boolValue];
    
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
    
    self.game = [[STMXOGame alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameCellWasTapped:)
                                                 name:@"gameCellWasTapped"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(indexWasPlayed:)
                                                 name:@"indexWasPlayed"
                                               object:self.game];

}


@end
