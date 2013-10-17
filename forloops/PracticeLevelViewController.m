//
//  PracticeLevelViewController.m
//  forloops
//
//  Created by Rajesh Ramsaroop on 10/13/13.
//  Copyright (c) 2013 leo Hernandez. All rights reserved.
//

#import "PracticeLevelViewController.h"
#import "QuartzCore/QuartzCore.h"   // required to change label borders

@interface PracticeLevelViewController ()

@end

@implementation PracticeLevelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Set the level
    self.level = 1;
    
    // level instructions
    self.levelInstructions = @"Drag and drop the correct test condition from the answers section to make the loop run exactly 10 times.";
    
    // update navigation bar
    self.navigationItem.title = [NSString stringWithFormat:@"Level %i",self.level];
    
    // create and display instructions label
    CGRect instructionsLabelFrame = CGRectMake(20, 65, self.view.frame.size.width-20, 0);
    self.instructionsLabel = [[UILabel alloc] initWithFrame:instructionsLabelFrame];
    [self.instructionsLabel setText:self.levelInstructions];
    [self.instructionsLabel setNumberOfLines:0];    // unlimited lines
    [self.instructionsLabel sizeToFit]; // to make sure text is aligned at top left
    [self.view addSubview:self.instructionsLabel];
    
    // create the loop structure
    UIFont *loopBodyFont = [UIFont fontWithName:@"Courier New" size:25];
    UIFont *answerLabelFont = [UIFont fontWithName:@"Courier New" size:20];
    
    CGRect structureForLineFrame = CGRectMake(20, 160, self.view.frame.size.width-20, 20);
    UILabel *structureForLine = [[UILabel alloc] initWithFrame:structureForLineFrame];
    structureForLine.font = loopBodyFont;
    structureForLine.text = @"for (          ;          ;          )";
    [structureForLine sizeToFit];
    [self.view addSubview:structureForLine];
    
    CGRect openingParenFrame = CGRectMake(20, 190, 10, 10);
    UILabel *openingParen = [[UILabel alloc] initWithFrame:openingParenFrame];
    openingParen.font = loopBodyFont;
    openingParen.text = @"{";
    [openingParen sizeToFit];
    [self.view addSubview:openingParen];
    
    // loop body
    CGRect loopBodyFrame = CGRectMake(80, 210, 10, 10);
    UILabel *loopBody = [[UILabel alloc] initWithFrame:loopBodyFrame];
    loopBody.font = loopBodyFont;
    loopBody.text = @"print(\"Hello world!\");";
    [loopBody sizeToFit];
    [self.view addSubview:loopBody];
    
    CGFloat closingParensY = loopBody.frame.origin.y + loopBody.frame.size.height;
    CGRect closingParensFrame = CGRectMake(20, closingParensY, 10, 10);
    UILabel *closingParens = [[UILabel alloc] initWithFrame:closingParensFrame];
    closingParens.font = loopBodyFont;
    closingParens.text = @"}";
    [closingParens sizeToFit];
    [self.view addSubview:closingParens];
    
    // label for loop components
    CGFloat answerLabelWidth = 140;
    CGFloat answerLabelHeight = 25;
    UIColor *answerLabelColor = [[UIColor alloc] initWithRed:.5 green:.5 blue:.5 alpha:.2];
    
    // init variable
    CGRect initContainerLabelFrame = CGRectMake(100, 163, answerLabelWidth, answerLabelHeight);
    UILabel *initContainerLabel = [[UILabel alloc] initWithFrame:initContainerLabelFrame];
    initContainerLabel.font = answerLabelFont;
    [initContainerLabel setTextAlignment:NSTextAlignmentCenter];
    initContainerLabel.text = @"int i = 0";
    initContainerLabel.backgroundColor = answerLabelColor;
    initContainerLabel.layer.borderColor = [UIColor blackColor].CGColor;
    initContainerLabel.layer.borderWidth = 1;
    [self.view addSubview:initContainerLabel];
    
    // test condition
    CGRect testConditionContainerFrame = CGRectMake(265, 163, answerLabelWidth, answerLabelHeight);
    _testConditionContainerLabel = [[UILabel alloc] initWithFrame:testConditionContainerFrame];
    _testConditionContainerLabel.font = answerLabelFont;
    [_testConditionContainerLabel setTextAlignment:NSTextAlignmentCenter];
    _testConditionContainerLabel.text = @"";
    _testConditionContainerLabel.backgroundColor = answerLabelColor;
    _testConditionContainerLabel.layer.borderColor = [UIColor blackColor].CGColor;
    _testConditionContainerLabel.layer.borderWidth = 1;
    [self.view addSubview:_testConditionContainerLabel];
    
    // increment statement
    CGRect incrementContainerFrame = CGRectMake(430, 163, answerLabelWidth, answerLabelHeight);
    _incrementContainerLabel = [[UILabel alloc] initWithFrame:incrementContainerFrame];
    _incrementContainerLabel.font = answerLabelFont;
    [_incrementContainerLabel setTextAlignment:NSTextAlignmentCenter];
    _incrementContainerLabel.text = @"i++";
    _incrementContainerLabel.backgroundColor = answerLabelColor;
    _incrementContainerLabel.layer.borderColor = [UIColor blackColor].CGColor;
    _incrementContainerLabel.layer.borderWidth = 1;
    [self.view addSubview:_incrementContainerLabel];
    
    // create answer label
    _answerLabelFrame = CGRectMake(20, 760, answerLabelWidth, answerLabelHeight);
    UILabel *answerLabel = [[UILabel alloc] initWithFrame:_answerLabelFrame];
    answerLabel.text = @"i < 10";
    answerLabel.userInteractionEnabled = YES;
    answerLabel.font = answerLabelFont;
    [answerLabel setTextAlignment:NSTextAlignmentCenter];
    answerLabel.backgroundColor = answerLabelColor;
    answerLabel.layer.borderColor = [UIColor blackColor].CGColor;
    answerLabel.layer.borderWidth = 1;
    [self.view addSubview:answerLabel];
    
    // add answer labels to NSMutableSet
    NSMutableSet *answerLabels = [[NSMutableSet alloc] init];
    [answerLabels addObject:answerLabel];
    
    // for loop to make pan gesture for all answer labels
    for (UILabel *label in answerLabels)
    {
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
        [label addGestureRecognizer:panGesture];
    }
    
}

-(BOOL)isThisView:(UIView *)firstView nearTo:(UIView *)secondView withBuffer:(CGFloat)buffer
{
    buffer = (buffer >= 0) ? buffer : 0;
    CGFloat firstViewX = firstView.frame.origin.x;
    CGFloat firstViewY = firstView.frame.origin.y;
    CGFloat secondViewX = secondView.frame.origin.x;
    CGFloat secondViewY = secondView.frame.origin.y;
    
    if( firstViewX >= secondViewX-buffer
       && firstViewX <= secondViewX+buffer
       && firstViewY >= secondViewY-buffer
       && firstViewY <= secondViewY+buffer )
    {
        return YES;
    } else {
        return NO;
    }
}

-(void)panDetected:(UIPanGestureRecognizer *)sender
{
    UIView *label = sender.view;
    CGPoint amtOftranslation = [sender translationInView:self.view];
    CGPoint labelPosition = label.center;
    labelPosition.x = labelPosition.x + amtOftranslation.x;
    labelPosition.y = labelPosition.y + amtOftranslation.y;
    label.center = labelPosition;
    [sender setTranslation:CGPointZero inView:self.view];
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        BOOL viewsClose = [self isThisView:label nearTo:self.testConditionContainerLabel withBuffer:50];
        if (viewsClose == YES)
        {
            label.center = self.testConditionContainerLabel.center;
        } else {
            [label setFrame:_answerLabelFrame];
        }
    }
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end