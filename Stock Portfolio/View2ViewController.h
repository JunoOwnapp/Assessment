//
//  View2ViewController.h
//  Stock Portfolio
//
//  Created by Juno Chen Kwan Lok on 20/07/2022.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class V2TBData;
@interface View2ViewController : UIViewController
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel *year1Lbl;
@property (strong, nonatomic) UILabel *year2Lbl;

@property (strong, nonatomic) UIActivityIndicatorView *indicator;

-(instancetype)initWithCoperateName:(NSString *)name Symbol:(NSString *)symbol;
@end


NS_ASSUME_NONNULL_END
