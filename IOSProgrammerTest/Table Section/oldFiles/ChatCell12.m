//
//  TableSectionTableViewCell.m
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

#import "ChatCell.h"
#import <QuartzCore/QuartzCore.h>

@interface ChatCell ()
@property (nonatomic, strong) IBOutlet UILabel *usernameLabel;
@property (nonatomic, strong) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@end

@implementation ChatCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)loadWithData:(ChatData *)chatData
{
    
    self.usernameLabel.text = chatData.username;
    [self.usernameLabel sizeToFit];
    self.messageTextView.text = chatData.message;
    [self.messageTextView sizeToFit];
    
//     self.userImage.layer.cornerRadius =  self.userImage.frame.size.height /2;
//     self.userImage.layer.masksToBounds = YES;
//     self.userImage.layer.borderWidth = 0;
    
    //UITextView's size changes to fit the content
    CGSize sizeThatShouldFitTheContent = [self.messageTextView  sizeThatFits:self.messageTextView.frame.size];
    
    //set new height for NSLayoutAttributeHeight
    for (NSLayoutConstraint *constraint in self.messageTextView.constraints) {
        if ([constraint firstAttribute] == NSLayoutAttributeHeight) {
            [constraint setConstant:sizeThatShouldFitTheContent.height];
        }
    }
    self.messageTextView.textContainerInset = UIEdgeInsetsZero;
    
    if (!chatData.avatar_image) {
        NSURL *url = [NSURL URLWithString:chatData.avatar_url];
        
        [self downloadImageFromURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                [ChatCell circlifyImage:self.userImage];
                self.userImage.image = image;
                // local storage
                chatData.avatar_image = image;
            }
        }];
    }
    else {
        [ChatCell circlifyImage:self.userImage];
        self.userImage.image = chatData.avatar_image;
    }


}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
}


#pragma marks - Helper methods
- (void)downloadImageFromURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ( !error )
         {
             UIImage *image = [[UIImage alloc] initWithData:data];
             completionBlock(YES,image);
         } else{
             completionBlock(NO,nil);
         }
     }];
}


+ (void) circlifyImage:(UIImageView*) imageView
{
    CALayer *imageLayer = imageView.layer;
    [imageLayer setCornerRadius:imageView.frame.size.width/2];
    [imageLayer setBorderWidth:0];
    [imageLayer setMasksToBounds:YES];
}

@end
