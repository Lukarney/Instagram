//
//  DetailsViewController.m
//  Instagram
//
//  Created by Luke Arney on 7/9/21.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import <Parse/Parse.h>
#import "DateTools.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *postAuthor;
@property (weak, nonatomic) IBOutlet UILabel *postDate;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *postCaption;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PFFileObject *image = self.post[@"photo"];
    NSURL *imageURL = [NSURL URLWithString:image.url];
    [self.postImage setImageWithURL:imageURL];
    
    self.postCaption.text = self.post[@"description"];
    self.postDate.text = [self.post createdAt].shortTimeAgoSinceNow;
    PFUser *user = self.post[@"author"];
    self.postAuthor.text = user.username;
    
    NSLog(@"%@", self.post[@"author"]);
    NSLog(@"%@", self.postCaption.text);
    
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
