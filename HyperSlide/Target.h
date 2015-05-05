//
//  Target.h
//  HyperSlide
//
//  Created by Eoin Morgan on 5/4/15.
//  Copyright (c) 2015 Morgan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Target : SKSpriteNode

@property double mass;
@property SKPhysicsBody* physicsBody;
@property BOOL hit;

@end
