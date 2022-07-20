//
//  V2TableViewCell.h
//  Stock Portfolio
//
//  Created by Juno Chen Kwan Lok on 20/07/2022.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class V2TBData;
@interface V2TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *currentYearLbl;
@property (weak, nonatomic) IBOutlet UILabel *previousYearLbl;
-(void)setCellData:(V2TBData *)data;
@end


@interface V2TBData : NSObject
@property (nonatomic,retain) NSString * title;
@property (nonatomic,retain) id year1;
@property (nonatomic,retain) id year2;
@end
NS_ASSUME_NONNULL_END
