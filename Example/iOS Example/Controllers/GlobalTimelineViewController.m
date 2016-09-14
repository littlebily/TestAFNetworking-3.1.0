// GlobalTimelineViewController.m
//
// Copyright (c) 2011–2016 Alamofire Software Foundation ( http://alamofire.org/ )
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "GlobalTimelineViewController.h"

#import "Post.h"

#import "PostTableViewCell.h"

#import <AFNetworking/AFHTTPSessionManager.h>
@import AFNetworking;

#define kImageUrl0 @"http://img2.pconline.com.cn/pconline/0706/19/1038447_34.jpg"
#define kImageUrl1 @"http://m2.quanjing.com/2m/fod_liv002/fo-11171537.jpg"
#define kImageUrl2 @"http://pic42.nipic.com/20140616/11284670_145335292000_2.jpg"
#define kImageUrl3 @"http://pic41.nipic.com/20140509/18696269_121755386187_2.png"
#define kImageUrl4 @"http://scimg.jb51.net/allimg/160813/103-160Q3143110P5.jpg"

@interface GlobalTimelineViewController ()
@property (readwrite, nonatomic, strong) NSArray *posts;
@end


@implementation GlobalTimelineViewController

- (void)reload:(__unused id)sender {
    self.navigationItem.rightBarButtonItem.enabled = NO;

    NSURLSessionTask *task = [Post globalTimelinePostsWithBlock:^(NSArray *posts, NSError *error) {
        if (!error) {
            self.posts = posts;
            [self.tableView reloadData];
        }
    }];

    [self.refreshControl setRefreshingWithStateOfTask:task];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = NSLocalizedString(@"AFNetworking", nil);
//
//    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 100.0f)];
//    [self.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
//    [self.tableView.tableHeaderView addSubview:self.refreshControl];
//
//    self.tableView.rowHeight = 70.0f;
//    
//    [self reload:nil];
    
    //以下是自己写的demo代码
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    NSString *url = @"https://xxxxx";
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"value", @"key",                                                                    nil];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager POST:url parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"success---dict---%@",dict);
//
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"fail");
//    }];
    
    NSArray *array = [NSArray arrayWithObjects:kImageUrl0,kImageUrl1,kImageUrl2,kImageUrl3,kImageUrl4, nil];
    
    for (int i = 0; i < 5; i ++) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[array objectAtIndex:i]]];

        NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            // 设置下载路径,通过沙盒获取缓存地址,最后返回NSURL对象
            NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:[self getDocumentsPath]];
            //[[response URL] lastPathComponent]为下载的文件名
            NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:[[response URL] lastPathComponent]];
            NSLog(@"设置的下载地址--%@",fileURL);
            
            // 设置文件存放在本地沙盒路径
            return fileURL;
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                //已经是在主线程了
//            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:filePath]]];
                imageView.frame = CGRectMake(0, i * 150, 100, 100);
                [self.view addSubview:imageView];
//            });

        }];
        [task resume];
    }
    
//    [self downLoadWithUrlString:kImageUrl];
}

- (void)downLoadWithUrlString:(NSString *)urlString
{
    // 1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 2.设置请求的URL地址
    NSURL *url = [NSURL URLWithString:urlString];
    // 3.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 4.下载任务
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        // 下载进度
        NSLog(@"当前下载进度为:%lf", 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        // 默认下载地址
        NSLog(@"默认下载地址--%@",targetPath);
        
        // 设置下载路径,通过沙盒获取缓存地址,最后返回NSURL对象
        NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:[self getDocumentsPath]];
        //[[response URL] lastPathComponent]为下载的文件名
        NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:[[response URL] lastPathComponent]];
        NSLog(@"设置的下载地址--%@",fileURL);
        
        // 设置文件存放在本地沙盒路径
        return fileURL;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        // 下载完成调用的方法
        NSLog(@"%@—%@", response, filePath);
    }];
    // 5.启动下载任务
    [task resume];
}

/* 获取Documents文件夹的路径 */
- (NSString *)getDocumentsPath
{
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = documents[0];
    return documentsPath;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(__unused UITableView *)tableView
 numberOfRowsInSection:(__unused NSInteger)section
{
    return (NSInteger)[self.posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PostTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.post = self.posts[(NSUInteger)indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(__unused UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PostTableViewCell heightForCellWithPost:self.posts[(NSUInteger)indexPath.row]];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
