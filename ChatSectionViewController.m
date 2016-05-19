//
//  TableSectionViewController.m
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Copyright (c) 2014 AppPartner. All rights reserved.
//


#import "ChatSectionViewController.h"
#import "MainMenuViewController.h"
#import "ChatCell.h"
#import "AppDelegate.h"

#define jsonQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

#define TABLE_CELL_HEIGHT 90.0f

@interface ChatSectionViewController ()
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *loadedChatData;
@end

@implementation ChatSectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Chat";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.loadedChatData = [[NSMutableArray alloc] init];
    [self loadJSONData];
    self.navigationController.navigationBar.topItem.title=@"";

 
}

- (void)loadJSONData
{
    dispatch_async(jsonQueue, ^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"chatData" ofType:@"json"];
        NSError *error = nil;
        NSData *rawData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];

        id JSONData = [NSJSONSerialization JSONObjectWithData:rawData options:NSJSONReadingAllowFragments error:&error];

        [self.loadedChatData removeAllObjects];
        if ([JSONData isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *jsonDict = (NSDictionary *)JSONData;
            NSArray *loadedArray = [jsonDict objectForKey:@"data"];
            if ([loadedArray isKindOfClass:[NSArray class]])
            {
                for (NSDictionary *chatDict in loadedArray)
                {
                    ChatData *chatData = [[ChatData alloc] init];
                    [chatData loadWithDictionary:chatDict];
                    [self.loadedChatData addObject:chatData];
                }
            }
        };
        
        //update tableview on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ChatCell";
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];//forIndexPath:indexPath

    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = (ChatCell *)[nib objectAtIndex:0];
    }

    ChatData *chatData = [self.loadedChatData objectAtIndex:[indexPath row]];
    [cell loadWithData:chatData];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.loadedChatData.count;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatData *chatData = [self.loadedChatData objectAtIndex:[indexPath row]];
    NSString *textMessage = chatData.message;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    //Make roundrect around the image icon
    CGRect textMsgRect = [textMessage boundingRectWithSize:CGSizeMake(self.tableView.frame.size.width-94.0f, 1000.0f)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSParagraphStyleAttributeName: paragraphStyle.copy}
                                         context:nil];
    
    return TABLE_CELL_HEIGHT+textMsgRect.size.height;
    return TABLE_CELL_HEIGHT;
}
@end
