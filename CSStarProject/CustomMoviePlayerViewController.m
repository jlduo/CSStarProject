//
//  CustomMoviePlayerViewController.m
//  CSStarProject
//
//  Created by jialiduo on 14-9-9.
//  Copyright (c) 2014年 jialiduo. All rights reserved.
//

#import "CustomMoviePlayerViewController.h"

@implementation CustomMoviePlayerViewController

@synthesize movieURL;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    loadingAni = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(140, 70, 32, 32)];
    loadingAni.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.view addSubview:loadingAni];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(130, 120, 80, 40)];
    label.text = @"加载中...";
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    
    [[self view] setBackgroundColor:[UIColor blackColor]];
    
    [loadingAni startAnimating];
    [self.view addSubview:label];
}


- (void) moviePlayerLoadStateChanged:(NSNotification*)notification
{
    [loadingAni stopAnimating];
    [label removeFromSuperview];
    
    // Unless state is unknown, start playback
    if ([mp loadState] != MPMovieLoadStateUnknown)
    {
        // Remove observer
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerLoadStateDidChangeNotification
                                                      object:nil];
        
        // When tapping movie, status bar will appear, it shows up
        // in portrait mode by default. Set orientation to landscape
        //设置横屏
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
        // Rotate the view for landscape playback
        [[self view] setBounds:CGRectMake(0, 0, 480, 320)];
        [[self view] setCenter:CGPointMake(160, 240)];
        //选中当前view
        [[self view] setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
        
        // Set frame of movieplayer
        [[mp view] setFrame:CGRectMake(0, 0, 480, 320)];
        
        // Add movie player as subview
        [[self view] addSubview:[mp view]];
        
        // Play the movie
        [mp play];
    }
}


- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
    //还原状态栏为默认状态
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    // Remove observer
    [[NSNotificationCenter     defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:nil];
    
    [self dismissModalViewControllerAnimated:NO];
}


- (void) readyPlayer
{
    mp =  [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    
    if ([mp respondsToSelector:@selector(loadState)])
    {
        // Set movie player layout
        [mp setControlStyle:MPMovieControlStyleFullscreen];
        //满屏
        [mp setFullscreen:YES];
        // 有助于减少延迟
        [mp prepareToPlay];
        
        // Register that the load state changed (movie is ready)
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayerLoadStateChanged:)
                                                     name:MPMoviePlayerLoadStateDidChangeNotification
                                                   object:nil];
    }
    else
    {
        // Play the movie For 3.1.x devices
        [mp play];
    }
    
    // Register to receive a notification when the movie has finished playing.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
}

@end
