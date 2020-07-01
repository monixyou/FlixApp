//
//  DetailsViewController.h
//  FlixApp
//
//  Created by Monica Bui on 6/24/20.
//  Copyright © 2020 fbu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

/// public property for movie to display
@property (nonatomic, strong) Movie *movie;

@end

NS_ASSUME_NONNULL_END
