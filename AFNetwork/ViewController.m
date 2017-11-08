//
//  ViewController.m
//  AFNetwork
//
//  Created by zh dk on 2017/8/31.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "AFNetworkReachabilityManager.h"
#import "BookModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //创建一个线程对象
    NSThread *newT = [[NSThread alloc] initWithTarget:self selector:@selector(actNew:) object:nil];
    //启动线程
    [newT start];
   
    
    tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
   
    
    
}
-(void) actNew:(NSThread*)thread
{
    [self AFNetMonitor];
    [self AFGetData];

}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayData.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strID = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strID];
    }
    
    BookModel *book = [arrayData objectAtIndex:indexPath.row];
    cell.textLabel.text = book.bookName;
    cell.detailTextLabel.text = book.bookPrice;
    return cell;
    
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

-(void) AFGetData
{
    //创建http连接管理对象
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //get方法获取服务器数据
    //p1:参数传入一个url对象
    //p2:通过制定的结构传入参数
    //p3:指定下载的进度条ui
    //P4:下载成功后数据返回
    //p5：下载失败后调用
    [session GET:@"http://api.douban.com/book/subjects?q=ios&alt=json&apikey=01987f93c544bbfb04c97ebb4fce33f1" parameters:nil
        progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"下载成功");
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSLog(@"res = %@",responseObject);
                
                    arrayData = [[NSMutableArray alloc] init];
                    NSArray *arrayEntry = [responseObject objectForKey:@"entry"];
                    for (int i=0; i<arrayEntry.count; i++) {
                        BookModel *book = [[BookModel alloc]init];
                        NSDictionary *dicBook = [arrayEntry objectAtIndex:i];
                        NSArray *arrayAuthor = [dicBook objectForKey:@"author"];
                        for (int j=0; j<arrayAuthor.count; j++) {
                            NSDictionary *dicAuthor = [arrayAuthor objectAtIndex:j];
                            NSDictionary *dicName = [dicAuthor objectForKey:@"name"];
                            NSString *strAuthor = [dicName objectForKey:@"$t"];
                            book.author = strAuthor;
                        }
                        
                        NSDictionary *dicTitle = [dicBook objectForKey:@"title"];
                        NSString *strTitle = [dicTitle objectForKey:@"$t"];
                        book.bookName = strTitle;
                        
                        NSArray *arrayAttr = [dicBook objectForKey:@"db:attribute"];
                        for (int i =0; i<arrayAttr.count; i++) {
                            NSDictionary *dicAttr = [arrayAttr objectAtIndex:i];
                            
                            NSString *strName = [dicAttr objectForKey:@"@name"];
                            if ([strName isEqualToString:@"price"]) {
                                NSString *strPrice = [dicAttr objectForKey:@"$t"];
                                book.bookPrice = strPrice;
                            }
                            else if ([strName isEqualToString:@"publisher"]){
                                NSString *strPub = [dicAttr objectForKey:@"$t"];
                                book.bookPublisher = strPub;
                            }
                        }
                        
                        [arrayData addObject:book];

                    }
            }
            
            [tableView reloadData];

    }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"下载失败");
    }];
}

-(void) AFNetMonitor
{
    //检查网络连接的状态，网络连接检测管理类
    //开启网络连接监控器
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    //获取网络连接的判断结果
    [[AFNetworkReachabilityManager sharedManager]
     setReachabilityStatusChangeBlock:^
     (AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"无网络连接");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"通过wifi连接");
            break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"通过移动网络连接");
            break;
                
            default:
                break;
        }
     }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
