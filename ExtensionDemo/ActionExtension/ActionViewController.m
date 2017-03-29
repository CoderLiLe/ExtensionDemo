//
//  ActionViewController.m
//  ActionExtension
//
//  Created by LiLe on 2017/3/27.
//  Copyright © 2017年 LiLe. All rights reserved.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

@interface ActionViewController ()

@property(strong,nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self SpeechSynthesizer];
}

- (void)setImage {
    // Get the item[s] we're handling from the extension context.
    
    // For example, look for an image and place it into an image view.
    // Replace this with something appropriate for the type[s] your extension supports.
    BOOL imageFound = NO;
    for (NSExtensionItem *item in self.extensionContext.inputItems) {
        for (NSItemProvider *itemProvider in item.attachments) {
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeImage]) {
                // This is an image. We'll load it, then place it in our image view.
                __weak UIImageView *imageView = self.imageView;
                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeImage options:nil completionHandler:^(UIImage *image, NSError *error) {
                    if(image) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            [imageView setImage:image];
                        }];
                    }
                }];
                
                imageFound = YES;
                break;
            }
        }
        
        if (imageFound) {
            // We only handle one image, so stop looking for more.
            break;
        }
    }
}

- (void)SpeechSynthesizer
{
    // 从扩展背景信息中获取我们打算处理的项目。
    // 在我们的Action extension当中, 我们只需要一个输入项目（即文本），因此我们使用数组中的第一个项目。
    NSExtensionItem *item = self.extensionContext.inputItems[0];
    NSItemProvider *itemProvider = item.attachments[0];
    
    if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypePlainText]) {
        
        // 这是一段纯文本！
        __weak UITextView *textView = self.textView;
        
        [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypePlainText options:nil completionHandler:^(NSString *item, NSError *error) {
            
            if (item) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    [textView setText:item];
                    
                    // 设置语音合成并加以启动
                    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
                    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:textView.text];
                    [utterance setRate:0.1];
                    [synthesizer speakUtterance:utterance];
                }];
            }
        }];
    }
}

- (IBAction)done {
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
    [self.extensionContext completeRequestReturningItems:self.extensionContext.inputItems completionHandler:nil];
}
- (IBAction)actionButtonPressed:(UIBarButtonItem *)sender {
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[self.textView.text]
                                                                             applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

@end
