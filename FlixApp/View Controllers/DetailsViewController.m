//
//  DetailsViewController.m
//  FlixApp
//
//  Created by Monica Bui on 6/24/20.
//  Copyright © 2020 fbu. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TrailerViewController.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIButton *playTrailer;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.playTrailer.layer.cornerRadius = 5;
    self.playTrailer.clipsToBounds = YES;
        
    self.posterView.image = nil;
    [self.posterView setImageWithURL:self.movie.posterURL];
    
    self.backdropView.image = nil;
    [self.backdropView setImageWithURL:self.movie.backdropURL];
    
    self.titleLabel.text = self.movie.title;
    self.synopsisLabel.text = self.movie.synopsis;
    
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    TrailerViewController *trailerViewController = [segue destinationViewController];
    trailerViewController.movieID = self.movie.movieID;
}


@end
