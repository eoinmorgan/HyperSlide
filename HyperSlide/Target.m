//
//  Target.m
//  HyperSlide
//
//  Created by Eoin Morgan on 5/4/15.
//  Copyright (c) 2015 Morgan. All rights reserved.
//

#import "Target.h"

@implementation Target

-(id)initWithMass:(double)mass {
    self = [SKSpriteNode spriteNodeWithImageNamed:@"target_red"];
    if(!self) {
        self.mass = mass;
        
        
        return self;
    } else {
        return nil;
    }
    
}

CGPoint location = [touch locationInNode:self];

SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"target_red"];

sprite.xScale = .25;
sprite.yScale = .25;
sprite.position = location;

@end
