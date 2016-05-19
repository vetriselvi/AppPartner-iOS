//
//  AnimationSectionViewController.m
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

#import "AnimationSectionViewController.h"
#import "MainMenuViewController.h"

@interface AnimationSectionViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIImageView *bg_ImageView;
@property (weak, nonatomic) IBOutlet UIButton *buttonImageView;
@property (weak, nonatomic) IBOutlet UIButton *rainImageView;

@end

@implementation AnimationSectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"Animation";
    self.navigationController.navigationBar.backItem.title=@"";
    self.navigationController.navigationBar.topItem.title=@"";
    [self addEntranceAnimationToLayer:self.iconImage.layer
                            withDelay:0.5];
    [self addEntranceAnimationToLayer:self.buttonImageView.layer
                            withDelay:0.7];
    [self addEntranceAnimationToLayer:self.rainImageView.layer
                            withDelay:0.9];
    
      CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    emitterLayer.emitterPosition = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.origin.y);
    emitterLayer.emitterZPosition = 10.0;
    emitterLayer.emitterSize = CGSizeMake(self.view.bounds.size.width, 0.0);
    emitterLayer.emitterShape = kCAEmitterLayerSphere;
    
    CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
    
    emitterCell.scale = 0.1;
    emitterCell.scaleRange = 0.3;
    
    emitterCell.emissionRange = (CGFloat)M_PI;
    
    emitterCell.lifetime = 10.0;
    emitterCell.birthRate = 10.0;
    emitterCell.velocity = 100.0;
    emitterCell.velocityRange = 100.0;
    emitterCell.yAcceleration = 300.0;
    
    emitterCell.contents = (id)[[UIImage imageNamed:@"Ball_blue.png"] CGImage];
    
    CAEmitterCell *emitterCell2 = [CAEmitterCell emitterCell];
    emitterCell2.scale = 0.1;
    emitterCell2.scaleRange = 0.3;
    emitterCell2.emissionRange = (CGFloat)M_PI;
    emitterCell2.lifetime = 10.0;
    emitterCell2.birthRate = 10.0;
    emitterCell2.velocity = 100.0;
    emitterCell2.velocityRange = 100.0;
    emitterCell2.yAcceleration = 300.0;
    emitterCell2.contents = (id)[[UIImage imageNamed:@"Ball_red.png"] CGImage];
    
    emitterLayer.emitterCells = @[emitterCell, emitterCell2];
        [self.view.layer addSublayer:emitterLayer];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)spinAction:(id)sender
{
    CABasicAnimation* rotateAction;
    rotateAction = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAction.toValue = [NSNumber numberWithFloat: M_PI * 2];
    rotateAction.duration = 1.0;
    rotateAction.repeatCount = 1;
    [self.iconImage.layer addAnimation:rotateAction forKey:@"rotationAnimation"];
}

#pragma mark - touch events
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if ([touch view] == self.iconImage)
    {
        CGPoint touchPosition = [touch locationInView:touch.window];
        CGRect oldFrame = self.iconImage.frame;
        //make a new rectframe from difference old frame and touch position
        CGRect newFrame = CGRectMake(touchPosition.x - oldFrame.size.width/2, touchPosition.y -oldFrame.size.height/2, oldFrame.size.width, oldFrame.size.height);
        self.iconImage.frame = newFrame;
    }
}


- (void) addEntranceAnimationToLayer:(CALayer *)aLayer withDelay:(CGFloat)aDelay {
    CAKeyframeAnimation *trans = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    
    NSArray *values = @[@(-300),@(30),@(0)];
    trans.values = values;
    
    NSArray *times = @[@(0.0),@(0.85),@(1)];
    trans.keyTimes = times;
    trans.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    trans.duration = 0.8;
    trans.removedOnCompletion = NO;
    trans.fillMode = kCAFillModeBackwards;
    trans.beginTime = CACurrentMediaTime()+aDelay;
    [aLayer addAnimation:trans forKey:@"entrance"];
    
}


@end
