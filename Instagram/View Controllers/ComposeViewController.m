//
//  ComposeViewController.m
//  Instagram
//
//  Created by Luke Arney on 7/8/21.
//

#import "ComposeViewController.h"
#import <Parse/Parse.h>
#import "SceneDelegate.h"
#import "Post.h"

@interface ComposeViewController ()

@property (weak, nonatomic) IBOutlet UITextView *photoDescription;
@property (weak, nonatomic) IBOutlet UIImageView *photoSelected;
@property (weak,nonatomic) UIImage *uiImageSelectedPost;
@property (weak, nonatomic) IBOutlet UIButton *photoSelectorButton;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)sharePressed:(id)sender {
    Post *post = [PFObject objectWithClassName:@"InstagramPosts"];
    //get photo caption
    post[@"description"] = self.photoDescription.text;
    NSLog(@"%@", post[@"description"]);
    //gets image and saves it
    NSData *imgData = UIImagePNGRepresentation(self.uiImageSelectedPost);
    post[@"photo"] = [PFFileObject fileObjectWithName:@"image.png" data:imgData contentType:@"image/png"];
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded){
            NSLog(@"Post was saved");
            [self.delegate didPost];
            [self dismissViewControllerAnimated:true completion:nil];
        }
        else {
            NSLog(@"Problem saving post: %@", error.localizedDescription);
        }
    }];
    //gets user
    post[@"author"] = PFUser.currentUser;
    
}


- (IBAction)imagePressed:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    //resizing image
    CGSize imgSize = CGSizeMake(150, 150);
    UIImage *imgResized = [self resizeImage:editedImage withSize:imgSize];
    
    // Do something with the images (based on your use case)
    self.photoSelected.image = imgResized;
    self.uiImageSelectedPost = imgResized;
    [self.photoSelected setImage:imgResized];
    [self.photoSelectorButton setTitle:@" " forState:UIControlStateNormal];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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
