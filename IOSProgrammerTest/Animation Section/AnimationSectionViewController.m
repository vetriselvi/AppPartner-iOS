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

@end

@implementation AnimationSectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"Animation";
    self.navigationController.navigationBar.backItem.title=@"";
    self.navigationController.navigationBar.topItem.title=@"";

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

@end
