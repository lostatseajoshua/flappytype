//
//  TextComparison.h
//  Flappy Typing Test
//
//  Created by Joshua Alvarado on 4/22/14.
//  Copyright (c) 2014 Joshua Alvarado. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
@interface TextComparison : NSObject

@property (strong, nonatomic, readonly) NSMutableArray *letterToType;
@property (strong, nonatomic, readonly) NSMutableArray *wordsToType;
@property (strong, nonatomic, readonly) NSMutableArray *phraseToType;


@property (readonly) int score;
@property (readonly) int error;
@property (readonly) int numberForArray;

-(BOOL)compareLetters:(NSString *)text;
-(BOOL)compareWords:(NSString *)text;
-(BOOL)comparePhrase:(NSString *)text;
-(int)numberRandomizer;
@end
