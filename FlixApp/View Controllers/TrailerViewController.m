//
//  TrailerViewController.m
//  FlixApp
//
//  Created by Monica Bui on 6/26/20.
//  Copyright © 2020 fbu. All rights reserved.
//

#import "TrailerViewController.h"
#import <WebKit/WebKit.h>
#import "UIImageView+AFNetworking.h"
#import "SVProgressHUD.h"

@interface TrailerViewController ()

@property (weak, nonatomic) IBOutlet WKWebView *webkitView;
@property (nonatomic, strong) NSString *videoID;

@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self fetchVideo];
}

- (void)fetchVideo {
    
    __weak __typeof(self) weakSelf = self;
    __strong __typeof(self) strongSelf = weakSelf;
    
    // Tells control when to stop refreshing -> both when error and when no error
    [SVProgressHUD showWithStatus:@"Finding video..."];
    
    NSString* apiURL = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US", self.movieID];
    
    NSURL *url = [NSURL URLWithString:apiURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               
               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies"
                      message:@"The internet connection appears to be offline."
               preferredStyle:(UIAlertControllerStyleAlert)];
               UIAlertAction *tryAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * _Nonnull action) {
                                                                    [strongSelf fetchVideo];
                                                                }];
               [alert addAction:tryAction];
               [strongSelf presentViewController:alert animated:YES completion:^{}];
           }
           else {
               
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               self.videoID = dataDictionary[@"results"][0][@"key"];
               [self requestVideoURL];
           }
        
        [SVProgressHUD dismiss];
        
       }];
    [task resume];
}

- (void)requestVideoURL {
    NSString *baseURLString = @"https://www.youtube.com/watch?v=";
    
    NSString *fullVideoURLString = [baseURLString stringByAppendingString:self.videoID];
    
    // Convert the url String to a NSURL object.
    NSURL *url = [NSURL URLWithString:fullVideoURLString];

    // Place the URL in a URL Request.
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:10.0];
    // Load Request into WebView.
    [self.webkitView loadRequest:request];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
