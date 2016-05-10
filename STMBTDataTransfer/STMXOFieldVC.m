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


@interface STMXOFieldVC() <UIAlertViewDelegate>

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

- (void)winNotification:(NSNotification *)notification {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WIN!"
                                                    message:@"Win!"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [alert show];
    }];
    
}

- (void)loseNotification:(NSNotification *)notification {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"LOSE!"
                                                    message:@"Lose!"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [alert show];
    }];

}

- (void)indexWasPlayed:(NSNotification *)notification {
    
    NSInteger index = [notification.userInfo[@"index"] integerValue];
    BOOL byMe = [notification.userInfo[@"byMe"] boolValue];
    
    STMXOCellView *cellView = [self.view viewWithTag:index];
    
    NSString *imageName = (byMe) ? @"XOX.png" : @"XOO.png";
    UIImage *image = [UIImage imageNamed:imageName];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cellView.bounds];
    imageView.image = image;
    
    [cellView addSubview:imageView];
    
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - view lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.game = [STMXOGame sharedGame];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameCellWasTapped:)
                                                 name:@"gameCellWasTapped"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(indexWasPlayed:)
                                                 name:@"indexWasPlayed"
                                               object:self.game];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(winNotification:)
                                                 name:@"WIN!"
                                               object:self.game];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loseNotification:)
                                                 name:@"LOSE!"
                                               object:self.game];

}

- (void)viewWillDisappear:(BOOL)animated {
    [self.game flushGame];
}


@end
