//
//  View2ViewController.m
//  Stock Portfolio
//
//  Created by Juno Chen Kwan Lok on 20/07/2022.
//

#import "View2ViewController.h"
#import "V2TableViewCell.h"
#import "Constants.h"
#define headerHeight 50
@interface View2ViewController ()<UITableViewDelegate , UITableViewDataSource>
{
    NSMutableArray<V2TBData *> *list;
    NSString *companyName, *companySymbol;
}
@end

@implementation View2ViewController
-(instancetype)initWithCoperateName:(NSString *)name Symbol:(NSString *)symbol{
    self = [super init];
    if (self) {
        companyName = name;
        companySymbol = symbol;
        self.title = name;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationItem setLargeTitleDisplayMode:UINavigationItemLargeTitleDisplayModeNever];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [self.navigationItem.backBarButtonItem setTitle:@""];
    [self.navigationController.navigationBar setTitleTextAttributes:
       @{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;

    // This fixes the issue
    // Do any additional setup after loading the view.
}

-(void)rearrangeData:(NSDictionary *)model{
    list = [NSMutableArray new];
    
    NSArray *keys = [[model[@"annualReports"] firstObject] allKeys];
    NSDictionary *currentYearDic, *previousYearDic;
    currentYearDic = [model[@"annualReports"] firstObject];

    if ([model[@"annualReports"] objectAtIndex:1]) {
        previousYearDic = [model[@"annualReports"] objectAtIndex:1];
    }
    
    
    self.year1Lbl.text = [self getYearFromDate:[currentYearDic objectForKey:@"fiscalDateEnding"]];
    self.year2Lbl.text = previousYearDic ? [self getYearFromDate:[previousYearDic objectForKey:@"fiscalDateEnding"]] : @"Non";
    
    for (int i = 0 ; i < [keys count]; i ++) {
        NSString *key = [keys objectAtIndex:i];
        NSString *title = [self convertStringToReadableTitleFrom:key];
        [list addObject:[self createV2TBDataWithTitle:title year1Data:[currentYearDic objectForKey:key] year2Data:previousYearDic ? [previousYearDic objectForKey:key] : @"-"]];
    }

    
    [self.tableView reloadData];
}

-(NSString *)convertStringToReadableTitleFrom:(NSString *)string{
    NSRegularExpression *regexp = [NSRegularExpression
        regularExpressionWithPattern:@"([a-z])([A-Z])"
        options:0
        error:NULL];
    NSString *newString = [regexp
        stringByReplacingMatchesInString:string
        options:0
        range:NSMakeRange(0, string.length)
        withTemplate:@"$1 $2"];
    NSLog(@"Changed '%@' -> '%@'", string, newString);
    
    return newString;
}

-(NSString *)getYearFromDate:(NSString *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* selectedDate = [dateFormatter dateFromString:date];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *convertedDate = [dateFormatter stringFromDate:selectedDate];
    return convertedDate;
}

-(V2TBData *)createV2TBDataWithTitle:(NSString *)title year1Data:(NSString *)year1 year2Data:(NSString *)year2{
    V2TBData *obj = [V2TBData new];
    obj.title = title;
    obj.year1 = year1;
    obj.year2 = year2;
    
    return obj;
}

- (void)viewDidAppear:(BOOL)animated{
    [self fetchResultAPI:^(NSDictionary *dic, NSError *error) {
        NSLog(@"dic = %@",dic);
        if (!error) {

            if ([[dic allKeys] count] == 0) {
                [self openAlertWithTitle:@"No data found" message:[NSString stringWithFormat:@"This company '%@' currently have no any report. ",self->companyName]];
            }else{
                [self rearrangeData:dic];
            }
        }else
            NSLog(@"error = %@",error);
        
    }];
}

-(void)openAlertWithTitle:(NSString *)title message:(NSString *)message{
    UIAlertController * alertvc = [UIAlertController alertControllerWithTitle: title
                                                                      message:message preferredStyle: UIAlertControllerStyleAlert ];
    
    UIAlertAction * action2 = [UIAlertAction actionWithTitle: @"OK"
                                                       style: UIAlertActionStyleCancel handler: ^ (UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
       
    }];
    
    [alertvc addAction: action2];
    [self presentViewController: alertvc animated: YES completion: nil];

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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return [self headerWithTitle];
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    V2TableViewCell *cell =   [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([V2TableViewCell class])];
    if (!cell)
        cell = NSbunleloadNibName(NSStringFromClass([V2TableViewCell class]));
    [cell setCellData:[list objectAtIndex:indexPath.row]];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
   
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
    
    [viewBG addSubview:self.year1Lbl];
    [viewBG addSubview:self.year2Lbl];
    [self.year2Lbl.rightAnchor constraintEqualToAnchor:viewBG.rightAnchor constant:-8].active = YES;
    [self.year1Lbl.rightAnchor constraintEqualToAnchor:self.year2Lbl.leftAnchor constant:-8].active = YES;
    [self.year2Lbl.topAnchor constraintEqualToAnchor:viewBG.topAnchor constant:0].active = YES;
    [self.year1Lbl.topAnchor constraintEqualToAnchor:viewBG.topAnchor constant:0].active = YES;

    return viewBG;
    
}

- (UILabel *)year1Lbl{
    if (!_year1Lbl) {
        
        _year1Lbl = [[UILabel alloc] init];
        [_year1Lbl setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_year1Lbl.widthAnchor constraintEqualToConstant:80].active = YES;
        [_year1Lbl.heightAnchor constraintEqualToConstant:headerHeight].active = YES;
        [_year1Lbl setTextColor:[UIColor blackColor]];
    }
    return _year1Lbl;
}


- (UILabel *)year2Lbl{
    if (!_year2Lbl) {
        
        _year2Lbl = [[UILabel alloc] init];
        [_year2Lbl setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_year2Lbl.widthAnchor constraintEqualToConstant:80].active = YES;
        [_year2Lbl.heightAnchor constraintEqualToConstant:headerHeight].active = YES;
        [_year2Lbl setTextColor:[UIColor blackColor]];
    }
    return _year2Lbl;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return YES;
}


-(void)fetchResultAPI:(void(^)(NSDictionary * dic, NSError * error))complete{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.alphavantage.co/query?function=INCOME_STATEMENT&symbol=%@&interval=5min&apikey=AGLW9PZPDDCOXIWW", companySymbol]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];

    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];


    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (complete)
                    complete(nil, error);
            });
        }else{
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            if ([httpResponse statusCode] == 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (complete)
                        complete(dict, error);
                });
            }
            else{
                NSError *err = [[NSError alloc] initWithDomain:httpResponse.URL.absoluteString code:[httpResponse statusCode] userInfo:dict];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (complete)
                        complete(dict,err);
                });
            }
        }
    }];
            
    [dataTask resume];
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
