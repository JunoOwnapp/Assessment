//
//  MyFavViewController.h
//  Stock Portfolio
//
//  Created by Juno Chen Kwan Lok on 21/07/2022.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyFavViewController : UIViewController
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;

-(instancetype)initWithCustom;

@end

NS_ASSUME_NONNULL_END
