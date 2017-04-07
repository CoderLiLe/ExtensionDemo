//
//  Action.js
//  ActionNoUserInterfaceExtension
//
//  Created by LiLe on 2017/3/29.
//  Copyright © 2017年 LiLe. All rights reserved.
//  实现和处理浏览器中请求的逻辑

var Action = function() {};

Action.prototype = {
    
    run: function(arguments) {
        // Here, you can run code that modifies the document and/or prepares
        // things to pass to your action's native code.
        
        // We will not modify anything, but will pass the body's background
        // style to the native code.
        
        arguments.completionFunction({ "currentBackgroundColor" : document.body.style.backgroundColor })
        
        
        // 在这个方法里，你可以通过documnet操作HTML中的元素，或者可以将HTML中的内容传给ActionRequestHandle文件的代码
        // 在本文的例子中，我们不做任何更新，只是将HTML中选中的内容穿给ActionRequestHandler文件的代码。
//        var selected = "No Text Selected";
//        if (window.getSelection) {
//            selected = window.getSelection().getRangeAt(0).toString();
//        } else {
//            selected = document.getSelection().getRangeAt(0).toString();
//        }
//        arguments.completionFunction({"args" : selected});
    },
    
    finalize: function(arguments) {
        // This method is run after the native code completes.
        
        // We'll see if the native code has passed us a new background style,
        // and set it on the body.
        
        //*
        var newBackgroundColor = arguments["newBackgroundColor"]
        if (newBackgroundColor) {
            // We'll set document.body.style.background, to override any
            // existing background.
            document.body.style.background = newBackgroundColor
        } else {
            // If nothing's been returned to us, we'll set the background to
            // blue.
            document.body.style.background= "blue"
        }
         //*/
        
        // 当ActionRequestHandler文件中的itemLoadCompletedWithPreprocessingResults方法执行完之后会调用该方法。
        // 如果ActionRequestHandler文件向HTML返回了信息，我们可以通过arguments["message"]来查看，并且可以根据该信息操作HTML中的元素。
        //alert(arguments["message"]);
    }
    
};
    
var ExtensionPreprocessingJS = new Action
