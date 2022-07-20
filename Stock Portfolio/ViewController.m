//
//  ViewController.m
//  Stock Portfolio
//
//  Created by Juno Chen Kwan Lok on 20/07/2022.
//

#import "ViewController.h"
#import "View2ViewController.h"


#define headerHeight 60
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSMutableArray *names, *symbols;
    NSMutableArray *filteredNames;
//

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"My Portfolio";
    NSLog(@"opened view controller");
    [self.view addSubview:self.tableView];
    
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    // Do any additional setup after loading the view.
    [self readCSVFile];
}


-(void)readCSVFile{
    names = [NSMutableArray array];
    symbols = [NSMutableArray array];

    NSError *err;
    NSString* fileContents = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://www.alphavantage.co/query?function=LISTING_STATUS&apikey=AGLW9PZPDDCOXIWW"] encoding:NSASCIIStringEncoding error:&err];
    NSArray* rows = [fileContents componentsSeparatedByString:@"\n"];
    
    for (NSString *row in rows){
         NSArray* columns = [row componentsSeparatedByString:@","];
        if (([columns count] > 1 ) && ![columns[0] isEqualToString:@"name"] && ![columns[0] isEqualToString:@"symbol"] ) {
            [symbols addObject:columns[0]];
            [names addObject:columns[1]];
        }
    }
    
    filteredNames = [[NSMutableArray alloc] initWithArray:[names copy]];

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
    return [filteredNames count];
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
    cell.label.text = [filteredNames objectAtIndex:indexPath.row];
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
    if ([textField.text length] == 0)
        filteredNames = names;
    else
        filteredNames = [[names filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString *  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            NSString *originalTxt = [evaluatedObject uppercaseString];
            NSString *filterText = [textField.text uppercaseString];
            return [originalTxt containsString:filterText];
        }]] mutableCopy];
    
    
    
    [self.tableView reloadData];
    return YES;
}

@end
