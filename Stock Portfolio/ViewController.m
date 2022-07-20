//
//  ViewController.m
//  Stock Portfolio
//
//  Created by Juno Chen Kwan Lok on 20/07/2022.
//

#import "ViewController.h"
#import "View2ViewController.h"

#define listOfCompany @[@"IBM", @"TSLA"]

#define headerHeight 60
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSArray *list ;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"My Portfolio";
    NSLog(@"opened view controller");
    list = [listOfCompany copy];
    [self.view addSubview:self.tableView];
    
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor tintColor]];

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
    return [list count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return [self headerWithTitle];
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    View1TableViewCell *cell =   [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([View1TableViewCell class])];
    if (!cell)
        cell = NSbunleloadNibName(NSStringFromClass([View1TableViewCell class]));
    cell.label.text = [list objectAtIndex:indexPath.row];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    View2ViewController *vc = [[View2ViewController alloc] init];
    vc.title = [list objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
        return CGFLOAT_MIN;
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}


-(UIView *)headerWithTitle{
    UIView *viewBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 20, headerHeight)];
    [viewBG setBackgroundColor:self.view.backgroundColor];
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth - 20, headerHeight - 10)];
    [tf setPlaceholder:@"Search for a Company"];
    [tf setBackgroundColor:[UIColor systemGray5Color]];
    tf.layer.cornerRadius = 5;
    tf.delegate = self;
    [viewBG addSubview:tf];

    return viewBG;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return YES;
}

@end
