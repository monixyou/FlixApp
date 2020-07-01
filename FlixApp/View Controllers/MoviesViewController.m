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
#import "MovieApiManager.h"

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
            
    [self fetchMovies];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)fetchMovies {
    
    __weak __typeof(self) weakSelf = self;
    __strong __typeof(self) strongSelf = weakSelf;
    
    [self.refreshControl endRefreshing];
    [SVProgressHUD showWithStatus:@"Finding movies..."];
    
    MovieApiManager *manager = [MovieApiManager new];
    [manager fetchNowPlaying:^(NSArray *movies, NSError *error) {
        if (movies) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            
            self.movies = [NSMutableArray arrayWithArray:movies];
            self.filteredData = self.movies;
            
            [self.tableView reloadData];
            
        } else {
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
        [SVProgressHUD dismiss];
    }];
    
    [self.refreshControl endRefreshing];
}

// Step 4: Method for how many rows you have
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredData.count;
}

// Step 5: Method to create and configure a cell based on a different index path
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    cell.movie = self.filteredData[indexPath.row];
    
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
