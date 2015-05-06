//
//  GameScene.h
//  HyperSlide
//

//  Copyright (c) 2015 Morgan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>


@interface GameScene : SKScene <SKPhysicsContactDelegate>

@property CMMotionManager* motionManager;
@property double gravityConst;
@property int score;
@property SKLabelNode* scoreLabel;

+(SKSpriteNode*)makeTarget;

-(void)adjustGravity;

@end
