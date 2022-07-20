//
//  MyFavViewController.m
//  Stock Portfolio
//
//  Created by Juno Chen Kwan Lok on 21/07/2022.
//

#import "MyFavViewController.h"
#import "View1TableViewCell.h"
#import "View2ViewController.h"
#import "Constants.h"

@interface MyFavViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *names, *symbols;
    NSMutableArray *filteredNames;

}
@end

@implementation MyFavViewController
-(instancetype)initWithCustom{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor tintColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:
       @{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self readFromMyList];

}

- (void)viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
    [self.indicator stopAnimating];
    [self.indicator removeFromSuperview];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"My Fav";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationItem setLargeTitleDisplayMode:UINavigationItemLargeTitleDisplayModeNever];

    [self.view addSubview:self.tableView];
    [self.view addSubview:self.indicator];
    
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    // Do any additional setup after loading the view.

}


-(void)readFromMyList{
    names = [NSMutableArray array];
    symbols = [NSMutableArray array];

    NSMutableDictionary * myFavList = [[NSUserDefaults standardUserDefaults] objectForKey:kMYFavListKey];
    names = [NSMutableArray arrayWithArray:[myFavList allKeys]];
    symbols = [NSMutableArray arrayWithArray:[myFavList allValues]];
    
    filteredNames = [[NSMutableArray alloc] initWithArray:[names copy]];
    [self.tableView reloadData];
}


#pragma mark - Table View
-(UITableView *)tableView{
    
    if (!_tableView) {
        CGRect frame = self.view.frame;
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_tableView.widthAnchor constraintEqualToConstant:kScreenWidth].active = YES;
        [_tableView setContentInset:UIEdgeInsetsZero];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setShowsVerticalScrollIndicator:NO];
        [_tableView setShowsHorizontalScrollIndicator:NO];
        
        UIRefreshControl* refreshController = [[UIRefreshControl alloc] init];
        [refreshController addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
        [_tableView setRefreshControl:refreshController];
        
    }
    
    return _tableView;
}


-(void)handleRefresh : (UIRefreshControl *)sender
{
    [sender endRefreshing];
    NSLog(@"reload");
}


#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [filteredNames count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return [UIView new];
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    View1TableViewCell *cell =   [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([View1TableViewCell class])];
    if (!cell)
        cell = NSbunleloadNibName(NSStringFromClass([View1TableViewCell class]));
    cell.label.text = [filteredNames objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.bgView.layer setShadowOffset:CGSizeMake(0, 2)];
    [cell.bgView.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [cell.bgView.layer setShadowOpacity:0.2];

    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *companyName = [filteredNames objectAtIndex:indexPath.row];
    NSInteger index = [names indexOfObject:companyName];
    NSString *symbol = [symbols objectAtIndex:index];
    View2ViewController *vc = [[View2ViewController alloc] initWithCoperateName:companyName Symbol:symbol];

    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
        return CGFLOAT_MIN;
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}



- (UIActivityIndicatorView *)indicator{
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
        _indicator.center = self.view.center;
        [_indicator startAnimating];
    }
    return _indicator;
}



@end
