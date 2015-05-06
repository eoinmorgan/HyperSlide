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

static const uint32_t crosshairsCategory =  0x1 << 0;
static const uint32_t targetCategory =  0x1 << 1;
static const uint32_t wallCategory =  0x1 << 2;

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */

    [super didMoveToView:view];
    
    // Physics setup
    self.gravityConst=9.8;
    self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
    SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody = borderBody;
    self.physicsBody.friction = 0.4f;
    self.physicsWorld.contactDelegate = self;
    
    // Graphics setup
    self.backgroundColor = [SKColor lightGrayColor];
    SKSpriteNode* crosshairs = [SKSpriteNode spriteNodeWithImageNamed:@"crosshairs.jpg"];
    crosshairs.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    crosshairs.xScale = .4;
    crosshairs.yScale = .4;
    
    crosshairs.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:1];
    crosshairs.physicsBody.dynamic = NO;
    crosshairs.physicsBody.categoryBitMask = crosshairsCategory;
    
    [self addChild:crosshairs];
    
    self.score = 0;
    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed: @"Arial"];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.score];
    self.scoreLabel.position = CGPointMake(75, 25);
    [self addChild:self.scoreLabel];
    
    // Gyro setup
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.gyroUpdateInterval = 0.2f;
    [self.motionManager startDeviceMotionUpdates];
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *target;
    
    if (contact.bodyA.categoryBitMask == targetCategory && contact.bodyB.categoryBitMask == crosshairsCategory) {
        target = contact.bodyA;
    } else if (contact.bodyA.categoryBitMask == crosshairsCategory && contact.bodyB.categoryBitMask == targetCategory) {
        target = contact.bodyB;
    }
    
    if (target) {
        self.score++;
        SKSpriteNode* targetNode = (SKSpriteNode*)target.node;
        targetNode.texture = [SKTexture textureWithImageNamed:@"target_green"];
        target.contactTestBitMask = wallCategory | targetCategory;
        target.collisionBitMask = wallCategory | targetCategory;
        
        SKAction *remove = [SKAction sequence: @[[SKAction fadeAlphaTo:0 duration:1.0],
                                               [SKAction removeFromParent]]];
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.score];
        [targetNode runAction:remove];
    }
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
    sprite.physicsBody.categoryBitMask = targetCategory;
    sprite.physicsBody.contactTestBitMask = crosshairsCategory | wallCategory | targetCategory;
    sprite.physicsBody.collisionBitMask = wallCategory | targetCategory;
    return sprite;
}

@end
