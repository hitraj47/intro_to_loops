//
//  Level.h
//  forloops
//
//  Created by Rajesh Ramsaroop on 10/20/13.
//  Copyright (c) 2013 leo Hernandez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Level : NSObject

@property int levelNumber;
@property (strong, nonatomic) NSString *levelInstructions;

@property (strong, nonatomic) NSString *loopInitialization;
@property (strong, nonatomic) NSString *terminatingCondition;
@property (strong, nonatomic) NSString *increment;
@property (strong, nonatomic) NSString *loopBody;

@property (strong, nonatomic) NSMutableSet *possibleAnswers;

@property (strong, nonatomic) NSMutableSet *correctAnswerCombinations;

@property (strong, nonatomic) NSMutableArray *levelHints;

-(id) initWithLevel: (int)level withInstructions: (NSString *)instructions;

@end
