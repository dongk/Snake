//
//  SnakeIOS.h
//  Snake
//
//  Created by dongk on 29/6/13.
//
//

#import <UIKit/UIKit.h>

@interface SnakeIOS : UIViewController

@property UIView *head;
@property UIView *target;

@property int direction;
@property NSTimer * timer;
@property NSMutableArray *tailArray;

-move;
-addTail;
-isHitTarget;
-isHitSelf;
-isBeyondBoundary;


@end
