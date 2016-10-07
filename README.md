# SLMultiDownLoadManager
异步多任务有限制下载数量的下载框架
![效果图](https://github.com/SLPowerCoder/SLMultiDownLoadManager/blob/master/SLMultiDownLoad.gif)

### 已经解决的问题
- [X] 限制同时下载任务的最大数量
- [X] 断点续传
- [X] 后台下载
- [X] 处理了人为杀死APP的时候数据的缓存问题
- [X] 屏蔽掉了无效的缓存，避免了断点续传失效的问题
- [X] 增加网络监听功能，并给与提示

### 待解决的问题
- [] 暂时没发现😊

### 使用
该框架工具分为两部分：
* UI部分（只是一个参考）：<br/>
UI的主体是一个ViewController
* 下载逻辑部分（可以拿出来单独使用）：<br/>
DownloadManager
下载队列管理类，创建该对象要使用downLoadQueue单利方法，具体用法如下
```
//初始化一个下载model
SLDownLoadModel *model = [[SLDownLoadModel alloc]init];
model.resourceID = [[[NSUUID UUID] UUIDString] stringByAppendingString:[NSString stringWithFormat:@"-%f",[[NSDate date] timeIntervalSince1970]]];
model.title = @"阿斯顿发送到阿斯顿发送到阿斯顿发送到阿斯顿发送到";
model.downLoadUrlStr = @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
//将待下载任务的model添加到下载队列中即可
[[SLDownLoadQueue downLoadQueue] addDownTaskWithDownLoadModel:model];
```
