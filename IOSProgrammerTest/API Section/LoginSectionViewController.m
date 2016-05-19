//
//  APISectionViewController.m
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

#import "LoginSectionViewController.h"
#import "MainMenuViewController.h"

@interface LoginSectionViewController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


@end

@implementation LoginSectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"Login";
    self.navigationController.navigationBar.backItem.title=@"";
    self.navigationController.navigationBar.topItem.title=@"";

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loginBtn:(id)sender
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    NSDictionary *parameters = @{@"username": self.username.text, @"password": self.password.text};
    NSURL *url = [NSURL URLWithString:@"http://dev.apppartner.com/AppPartnerProgrammerTest/scripts/login.php"];
    NSData *postData = [self dataFromDictionary:parameters];
    // Create the request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self postRequest:request];
    });
}

- (NSData*)dataFromDictionary:(NSDictionary*)dictionary {
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (NSString *key in dictionary) {
        NSString *encodedValue = [[dictionary objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject:part];
    }
    NSString *encodedDictionary = [parts componentsJoinedByString:@"&"];
    return [encodedDictionary dataUsingEncoding:NSUTF8StringEncoding];
}

- (void) postRequest:(NSMutableURLRequest*) request
{
    NSURLResponse *response;
    NSError *error = nil;
    NSDate *start=[NSDate date];
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&error];
    NSDate *end=[NSDate date];
    double ellapsedMilliSeconds= [end timeIntervalSinceDate:start]*1000;
    
    if (error) {
        NSLog(@"Error %@", error);
        return;
    }
    else {
        NSString *responeString = [[NSString alloc] initWithData:receivedData
                                                        encoding:NSUTF8StringEncoding];
        
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:[responeString dataUsingEncoding:NSUTF8StringEncoding]
                                                              options:0 error:NULL];
        NSString *code = [jsonObject valueForKey:@"code"];
        NSString *message = [jsonObject valueForKey:@"message"];
        NSString *messageWithTime = [NSString stringWithFormat:@"%@\n Post Request took %0.2f milliseconds.",message,ellapsedMilliSeconds];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self displayAlertView:code withMessage:messageWithTime];
        });
    }
    
}

#pragma mark - Alert View
- (void) displayAlertView:(NSString*)title withMessage:(NSString*)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [self.view endEditing:YES];
    // Do any additional setup after loading the view.
  

    [alert show];
    
    if([title isEqual:@"Success"])
    {

//        [self.view endEditing:YES];
        [self dismissModalViewControllerAnimated:YES];
        [(UINavigationController*)self.parentViewController popToRootViewControllerAnimated:YES];
        [self.view endEditing:YES];
        
    }
    
    
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
// 
//}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField*) textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - helper methods
-(void)dismissKeyboard {
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
    
    
}

@end
