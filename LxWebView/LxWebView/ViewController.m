//
//  ViewController.m
//  LxWebView
//
//  Created by mumuhou on 15/7/9.
//  Copyright (c) 2015年 mumuhou. All rights reserved.
//

#import "ViewController.h"


@interface ViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UIButton *loadUrlButton;

@property (nonatomic, strong) UIButton *loadLocalButton;

@property (nonatomic, strong) UIButton *executeJSButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self buildWebView];
//    [self buildButtons];
//    [self loadLocalFile:@"api"];
    [self loadUrl:@"http://m.5milesapp.com/app/api"];
    
    
}

- (void)buildButtons
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5, 80, 100, 40)];
    button.backgroundColor = [UIColor lightGrayColor];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(onLoadUrl) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"load url" forState:UIControlStateNormal];
    self.loadUrlButton = button;
    
    button = [[UIButton alloc] initWithFrame:CGRectMake(5, 130, 100, 40)];
    button.backgroundColor = [UIColor lightGrayColor];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(onLoadLocal) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"load local" forState:UIControlStateNormal];
    self.loadLocalButton = button;
    
    button = [[UIButton alloc] initWithFrame:CGRectMake(5, 180, 100, 40)];
    button.backgroundColor = [UIColor lightGrayColor];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(onLoadLocal) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"executeJS" forState:UIControlStateNormal];
    self.loadLocalButton = button;
}

- (void)onLoadUrl
{
    [self loadUrl:@"http://www.baidu.com"];
}

- (void)onLoadLocal
{
    [self loadLocalFile:@"http://www.baidu.com"];
}

- (void)onExecuteJavascript
{
    NSString *str = @"wr_browser_image();";
    [self executeJavascript:str];
}

- (void)loadUrl:(NSString *)url
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}

- (void)loadLocalFile:(NSString *)file
{
    NSString *htmlFilePath = [[NSBundle mainBundle] pathForResource:file ofType:@"html"];
    NSLog(@"%@", file);
    NSError *error = nil;
    NSString *htmlString = [NSString stringWithContentsOfFile:htmlFilePath encoding:NSUTF8StringEncoding error:&error];
    if (!error) {
        NSLog(@"加载本地文件失败");
    }

    [self.webView loadHTMLString:htmlString baseURL:nil];
}

- (void)executeJavascript:(NSString *)string
{
    [self.webView stringByEvaluatingJavaScriptFromString:string];
}

- (void)buildWebView
{
    if (!self.webView) {
        self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.webView.delegate = self;
        [self.view addSubview:self.webView];
    }
    
//    JSContext context = JSContext()
//    context.evaluateScript("var num = 5 + 5")
//    context.evaluateScript("var names = ['Grace', 'Ada', 'Margaret']")
//    context.evaluateScript("var triple = function(value) { return value * 3 }")
//    let tripleNum: JSValue = context.evaluateScript("triple(num)")
}

#pragma mark- UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // 处理JS发来的协议
   
    NSString *requestString = request.URL.absoluteString;
     NSLog(@"%@", requestString);
    if ([requestString hasPrefix:@"http"] || [requestString hasPrefix:@"file"]) {
        return YES;
    } else if ([requestString hasPrefix:@"itms-app"]) {
        [self.navigationController popViewControllerAnimated:NO];
        return YES;
    }
    
    NSLog(@"%@", requestString);
    
    return NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    NSLog(@"%@", @"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    NSLog(@"%@", @"webViewDidFinishLoad");
    NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title = title;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    NSLog(@"%@", @"didFailLoadWithError");
}

@end
