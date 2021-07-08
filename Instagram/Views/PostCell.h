//
//  PostCell.h
//  Instagram
//
//  Created by Luke Arney on 7/8/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *postPicture;
@property (weak, nonatomic) IBOutlet UILabel *postDescription;

@end

NS_ASSUME_NONNULL_END
