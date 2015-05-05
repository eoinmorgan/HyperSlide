//
//  GameScene.m
//  HyperSlide
//
//  Created by Eoin Morgan on 4/29/15.
//  Copyright (c) 2015 Morgan. All rights reserved.
//

#import "GameScene.h"
#import <CoreMotion/CoreMotion.h>

@implementation GameScene



-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */

    [super didMoveToView:view];
    
    self.gravityConst=9.8;
    
    // Physics setup
    self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
    SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody = borderBody;
    self.physicsBody.friction = 0.4f;
    
    // Gyro setup
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.gyroUpdateInterval = 0.2f;
    [self.motionManager startDeviceMotionUpdates];
}

- (void)update:(NSTimeInterval)currentTime {
    [self adjustGravity];
}

-(void)adjustGravity {
    CGFloat newXGravity, newYGravity;
    CMDeviceMotion* motion = self.motionManager.deviceMotion;
    newXGravity = sin(motion.attitude.roll)*self.gravityConst;
    newYGravity = (-1)*sin(motion.attitude.pitch)*self.gravityConst;
    self.physicsWorld.gravity = CGVectorMake(newXGravity, newYGravity);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [GameScene makeTarget];
        
        sprite.xScale = .25;
        sprite.yScale = .25;
        sprite.position = location;
        
        [self addChild:sprite];
    }
}

+(SKSpriteNode*)makeTarget {
    SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithImageNamed:@"target_red"];
    sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:200];
    sprite.physicsBody.mass = 1;
    sprite.physicsBody.friction = 1;
    return sprite;
}

@end
