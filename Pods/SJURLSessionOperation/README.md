# SJURLSessionOperation

[![Version Status](https://img.shields.io/cocoapods/v/SJURLSessionOperation.svg)](https://github.com/SoneeJohn/SJURLSessionOperation/releases)
[![Platform Status](https://img.shields.io/cocoapods/p/SJURLSessionOperation.svg)](http://cocoadocs.org/docsets/SJURLSessionOperation) 
[![License Status](https://img.shields.io/cocoapods/l/SJURLSessionOperation.svg)](https://github.com/SoneeJohn/SJURLSessionOperation/blob/master/LICENSE)
[![Docs Status](https://img.shields.io/cocoapods/metrics/doc-percent/SJURLSessionOperation.svg)](http://cocoadocs.org/docsets/SJURLSessionOperation)


`SJURLSessionOperation` creates and manages an `NSURLSessionDownloadTask` object based on a specified request and download location. `SJURLSessionOperation` is a subclass of `NSOperation` which then can be used with a NSOperationQueue. In addition, it uses `AFURLSessionManager` so, it requires AFNetworking.

### Purpose of Class

As of Xcode 7, the `NSURLConnection` API has been officially deprecated by Apple. While the API will continue to function, no new features will be added, and Apple has advised all network based functionality to leverage NSURLSession going forward. The main purpose of this class is to make migration to the newer NSURLSession API easier. The class is intend for those that have apps that heavily relied on the `NSOperation` aspects of `AFURLConnectionOperation`.

## Requirements
- [AFNetworking 3.0 and later](https://github.com/AFNetworking/AFNetworking)
- Runs on iOS 7.0 and later
- Runs on OS X 10.9 and later
- Xcode 7

# Usage

1. Import `SJURLSessionOperation`:

  ```objc
  #import "SJURLSessionOperation.h"
  ```
  
2. Instantiate `SJURLSessionOperation`

  ```objc
    
    NSURL *url = [NSURL URLWithString:@"https://www.example.com/bigfile1.zip"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    SJURLSessionOperation *operation = [[SJURLSessionOperation alloc]initWithRequest:request targetLocation:[NSURL fileURLWithPath:@"~/Desktop/bigfile1.zip"]];
  
  ```
  	**Tip**: You can use the resume data from a operation that previously failed. By setting the resume data the operation will start where the previous operation failed:
  	
  ```objc
 SJURLSessionOperation *operation = [[SJURLSessionOperation alloc]initWithRequest:request targetLocation:[NSURL fileURLWithPath:@"~/Desktop/bigfile1.zip"] resumeData:failedOperation.operationResumeData];
  ```

3. Start Operation
  ```objc
   [operation start];
    ```
#### Operation Control
```objc
//Pauses the execution of the operation.
//Pausing a finished, cancelled, or paused operation has no effect.
[operation pause];
```
```objc
/**
 *  Resumes the execution of the paused operation.
    Resuming a operation that is not paused has no effect.
 */
[operation resume];
```
#### Setting CallBacks
```objc
[operation setDownloadCompletionBlock:^(SJURLSessionOperation * _Nullable operation, NSError * _Nullable error, NSURL * _Nullable fileURL, NSURLResponse * _Nullable response) {
        
	if (error) {
	//Handler error
	}else{
	
	//Operation finished successfully
	}

    }];
    
	[operation setDownloadProgressBlock:^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {

       NSInteger percentage = (double)totalBytesWritten * 100 / (double)totalBytesExpectedToWrite;

	}];
```
# Example Usage Case

#### Limit the number of concurrent or simultaneous operations

```objc

NSURL *url = [NSURL URLWithString:@"https://www.example.com/bigfile1.zip"];
NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
SJURLSessionOperation *operation = [[SJURLSessionOperation alloc]initWithRequest:request targetLocation:[NSURL fileURLWithPath:@"~/Desktop/bigfile1.zip"]];
    
NSURL *url2 = [NSURL URLWithString:@"https://www.example.com/bigfile2.zip"];
NSURLRequest *request2 = [NSURLRequest requestWithURL:url2];
    
SJURLSessionOperation *operation2 = [[SJURLSessionOperation alloc]initWithRequest:request2 targetLocation:[NSURL fileURLWithPath:@"~/Desktop/bigfile2.zip"]];

NSOperationQueue *queue = [[NSOperationQueue alloc] init];
queue.maxConcurrentOperationCount = 1; //limit it to one operation at a time
    
//Add opertations
[queue addOperation:operation];
[queue addOperation:operation2];
    
```

## Acknowledgments

A lot of the source code in *SJURLSessionOperation* is inspired by the [AFNetworking ](https://github.com/AFNetworking/AFNetworking)

## Contact

Soneé John

- https://twitter.com/Sonee_John
- https://github.com/SoneeJohn

SJURLSessionOperation is available under the MIT license. See the [LICENSE](LICENSE) file for more information.

--------
###### Published in the hope that it will be useful
###### Please feel free to open a pull request
