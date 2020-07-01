//
//  MoviesViewController.m
//  FlixApp
//
//  Created by Monica Bui on 6/24/20.
//  Copyright © 2020 fbu. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"
#import "SVProgressHUD.h"
#import "Movie.h"

// Step 2: Configure controller to implement two interfaces the table view expects (data source and delegate)
@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

// Store the movies in a property to use elsewhere
@property (nonatomic, strong) NSMutableArray *movies;
// Step 1: Create outlet for table view to refer
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *filteredData;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Step 3: Set view controller to be the data source and delegate
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    
    self.movies = [[NSMutableArray alloc] init];
        
    [self fetchMovies];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)fetchMovies {
    
    __weak __typeof(self) weakSelf = self;
    __strong __typeof(self) strongSelf = weakSelf;
    
    // Tells control when to stop refreshing -> both when error and when no error
    [self.refreshControl endRefreshing];
    [SVProgressHUD showWithStatus:@"Finding movies..."];
    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
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
                                                                    [strongSelf fetchMovies];
                                                                }];
               [alert addAction:tryAction];
               [strongSelf presentViewController:alert animated:YES completion:^{}];
           }
           else {
               
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               NSArray *dictionaries = dataDictionary[@"results"];
               
               for (NSDictionary *dictionary in dictionaries) {
                   Movie *movie = [[Movie alloc] initWithDictionary:dictionary];
                   [self.movies addObject:movie];
               }
               self.filteredData = self.movies;
               
               // Step 6: Reload your table view data
               [self.tableView reloadData];
           }
        
        [SVProgressHUD dismiss];
        
       }];
    [task resume];
}

// Step 4: Method for how many rows you have
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredData.count;
}

// Step 5: Method to create and configure a cell based on a different index path
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    Movie *movie = self.filteredData[indexPath.row];
    cell.titleLabel.text = movie.title;
    cell.synopsisLabel.text = movie.synopsis;

    cell.posterView.image = nil;
    [cell.posterView setImageWithURL:movie.posterURL];
    
    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            return [[evaluatedObject[@"title"] lowercaseString] containsString:[searchText lowercaseString]];
        }];
        self.filteredData = [NSMutableArray arrayWithArray:[self.movies filteredArrayUsingPredicate:predicate]];
    }
    else {
        self.filteredData = self.movies;
    }

    [self.tableView reloadData];

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.text = @"";
    self.searchBar.showsCancelButton = false;
    [self.view endEditing:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 // Do some stuff when the row is selected
 [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    Movie *movie = self.filteredData[indexPath.row];
    
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
}


@end
