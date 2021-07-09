//
//  PostCell.h
//  Instagram
//
//  Created by Luke Arney on 7/8/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *postPicture;
@property (weak, nonatomic) IBOutlet UILabel *postDescription;
@property (strong, nonatomic) Post *post;

@end

NS_ASSUME_NONNULL_END
