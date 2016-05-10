//
//  STMXOGame.h
//  STMBTDataTransfer
//
//  Created by Maxim Grigoriev on 07/05/16.
//  Copyright © 2016 Sistemium UAB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STMXOGame : NSObject

+ (STMXOGame *)sharedGame;

- (void)index:(NSInteger)index wasPlayedByMe:(BOOL)byMe;
- (void)flushGame;


@end
