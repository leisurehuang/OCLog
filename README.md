
# [OCLog](https://github.com/leisurehuang/OCLog) [![Build Status](https://travis-ci.org/leisurehuang/OCLog.svg?branch=master)](https://travis-ci.org/leisurehuang/OCLog)

a log system for iOS platform

We can easy to use this lib to print a log with more infos such as time, method name, lines and other detail.

We have 5 log level. VEND/DEBUG/INFO/WARNING/ERROR.

We can catch all the crash stack infos.

We can write all the log to a local file and then you can send it to the remote server.


How to use?

    [OCRichLog logInitial];  
    OCRichLogV(@"this is a debug log");
    OCRichLogD(@"this is a debug log");
    OCRichLogI(@"this is a info log");
    OCRichLogW(@"this is a warning log");
    OCRichLogE(@"this is a error log");

#Update:

2017/01/11:

add UIBlockCheckThread to the project, and now you can use the thread to check UI block issues.
How to use it?

```
  UIBlockCheckThread *checkThread = [[UIBlockCheckThread alloc] init];
  [checkThread start];
```

2017/08/08:

code refactor for log code and fix performance issues.


 Enjoy.  
 Lei
