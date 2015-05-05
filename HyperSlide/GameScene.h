//
//  GameScene.h
//  HyperSlide
//

//  Copyright (c) 2015 Morgan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>

@interface GameScene : SKScene

@property CMMotionManager* motionManager;
@property double gravityConst;

+(SKSpriteNode*)makeTarget;

-(void)adjustGravity;

@end
