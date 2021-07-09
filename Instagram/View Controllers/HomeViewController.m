//
//  HomeViewController.m
//  Instagram
//
//  Created by Luke Arney on 7/7/21.
//

#import "HomeViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "SceneDelegate.h"
#import "Post.h"
#import "PostCell.h"
#import "ComposeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "SceneDelegate.h"
#import "DetailsViewController.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate >
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@property (strong, nonatomic) NSMutableArray* arrayOfPosts;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    
    [self fetchPost];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)fetchPost {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"InstagramPosts"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query includeKey:@"photo"];
    [query includeKey:@"description"];
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.arrayOfPosts = (NSMutableArray *) posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

-(void)didPost {
    [self fetchPost];
}
#pragma mark - Table view data source

- (IBAction)logOutPushed:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)self.view.window.windowScene.delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"User log out failed: %@", error.localizedDescription);
        }
        else {
            NSLog(@"Logged out successfully");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    
    //configures rows
    Post *post = self.arrayOfPosts[indexPath.row];
    cell.postDescription.text = post[@"description"];
    
    //configure image display
    PFFileObject *image = post[@"photo"];
    NSURL *imageURL = [NSURL URLWithString:image.url];
    [cell.postPicture setImageWithURL:imageURL];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfPosts.count;
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {

        // Create NSURL and NSURLRequest
    
    PFQuery *request = [PFQuery queryWithClassName:@"InstagramPosts"];
    [request orderByDescending:@"createdAt"];
    [request includeKey:@"author"];
    [request includeKey:@"photo"];
    [request includeKey:@"description"];
    request.limit = 20;

    // fetch data asynchronously
    [request findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.arrayOfPosts = (NSMutableArray *) posts;
            [self.tableView reloadData];
            [refreshControl endRefreshing];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"%@", segue.identifier);
    if([segue.identifier isEqualToString:@"composePost"]){

        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"detailsView"]){
        //[segue.identifier isEqualToString:@"showDetailTweet"]
        //Get postcell to show in details page
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *post = self.arrayOfPosts[indexPath.row];
        
        NSLog(@"%@", post);
        UINavigationController *nav = [segue destinationViewController];
        DetailsViewController *detailsViewController = (DetailsViewController *)[nav topViewController];
        detailsViewController.post = post;
        NSLog(@"Tapping on a post!");
        
    }
    
}

@end
