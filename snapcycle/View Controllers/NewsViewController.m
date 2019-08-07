//
//  NewsViewController.m
//  snapcycle
//
//  Created by emilyabest on 8/6/19.
//  Copyright © 2019 Quirky Quokkas. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsArticleCell.h"
#import "UIImageView+AFNetworking.h"

@interface NewsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *articles;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self getJSONData];

//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.rowHeight = 300;
}

- (void)getJSONData {
    // TODO: update url daily with new date
    NSURL *url = [NSURL URLWithString:@"https://newsapi.org/v2/everything?q=landfill&from=2019-07-07&sortBy=publishedAt&apiKey=f1ea246abb09430faa9a42590f9fe5ae"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            // Fill movies array with data from dictionary
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            self.articles = jsonDict[@"articles"];
            
            //TODO: check if no articles today!
            
            // Reload table view
            [self.tableView reloadData];
        }
    }];
    
    [task resume];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NewsArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsArticleCell"];
    
    NSDictionary *article = self.articles[indexPath.row];
    cell.articleTitle.text = article[@"title"];
    cell.articleDescrip.text = article[@"description"];
    
    // TODO: include this check for all cell outlets
    if (!((article[@"author"] == (id)[NSNull null]) || ([article[@"author"] length] == 0))) {
        cell.articleAuthor.text = article[@"author"];
    }
    
    NSURL *url = [NSURL URLWithString:article[@"urlToImage"]];
    cell.articleImage.image = nil;
    [cell.articleImage setImageWithURL:url];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articles.count;
}

@end