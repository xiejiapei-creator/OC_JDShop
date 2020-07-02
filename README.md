# ucareshop

>这个项目是IOS刚入门的时候写的，但写的颇为认真，仿京东商城的很多功能点也都实现了。页面和隔壁的Flutter仿京东商城项目很类似，而且由于时间较久了，后端接口失效了，所以不方便展示界面。但是下载下来后，可以自己写一些假数据，看看效果。这个项目适合和我当时一样的初学者学习，因为相较于那些高深的仿XX项目，我们水平相同，我写的你一定能够看得懂，而且这个项目里面很多东西也涉及到了，比如自己封装网络接口，本地数据缓存，各种常用框架`AFNetworking`,`MJRefresh`,`SDWebImage`也都有用到，而且还有很多设计思路和走过的坑，我都有详细的代码注释，保证你一定会有所收获的。


>Github上阅读效果不好，欢迎来我的[简书](https://www.jianshu.com/u/1ceb4a330607)做客，我写的每篇文章都很认真和仔细，对你一定会有所帮助的。








##这里说明下项目中自己封装网络接口部分的代码
#拼接URL进行网络请求
整个流程分为`计算签名-->拼接URL-->再进行网络请求`三部分，将其封装在一个请求方法中，传入参数和相对路径的`URL`即可拿到返回数据，其中返回数据的方式是通过`block`属性来进行的。
```
// 网络请求方法
- (void)startRequest:(NSDictionary *_Nullable)parameters pathUrl:(NSString *)pathUrl {
}
```
##1、计算签名
**为什么要有计算签名这个步骤的原因解释：**网络传输并非绝对安全可靠。以微信支付举例，一旦支付请求被中间人拦截并恶意篡改(如利用DNS欺骗)，就会画风突变。这种场景下就需要信息摘要技术了。信息摘要把明文内容按某种规则生成一段哈希值，即使明文消息只改动了一点点，生成的结果也会完全不同。`MD5 (Message -digest algorithm 5)`就是信息摘要的一种实现，它可以从任意长度的明文字符串生成128位的哈希值。
![网络传输并非绝对安全可靠](https://upload-images.jianshu.io/upload_images/9570900-7c71d3d54c209e0a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**摘要哈希生成的正确姿势是什么样呢？分三步：**
1. 收集相关业务参数，这里以金额和目标账户举例。
2. 按照规则，把参数名和参数值拼接成一个字符串，同时把给定的密钥也拼接起来。之所以需要密钥，是因为攻击者也可能获知拼接规则。
3. 利用 MD5 算法，从原文生成哈希值。MD5 生成的哈希值是 128 位的二进制数，也就是 32 位的十六进制数。

**其中MD5算法生成签名需要的东西：**服务商一般会给你一个`appid`，`appkey`；同时这两个参数服务商也会保存，这两个形成了你的唯一标识。`appid`通过网络传输，而`appkey`是不在网络上进行传输的，只在生成签名时使用，所以安全性还是比较高的。

**MD5算法生成签名的流程：**
1、除去加密数组中的空值和签名参数
2、对数组排序
3、把数组所有元素，按照“参数=参数值”的模式用“&”字符拼接成字符串
4、加上`appkey`值，对形成的数据进行MD5加密，生成签名

![利用 MD5 算法，从原文生成哈希值](https://upload-images.jianshu.io/upload_images/9570900-d3c2cdd89bfa5ce1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**第三方支付平台如何验证请求的签名？同样分三步：**
1. 发送方和请求方约定相同的字符串拼接规则，约定相同的密钥。 
2. 第三方平台接到支付请求，按规则拼接业务参数和密钥，利用 MD5 算法生成` Sign`。 
3. 用第三方平台自己生成的` Sign `和请求发送过来的 `Sign `做对比，如果两个` Sign `值一模一样，则签名无误，如果两个` Sign` 值不同，则信息做了篡改。这个过程叫做验签。

**使用MD5算法以后，发起支付请求的画风会变成什么样呢? 我们来看一看：**
![使用MD5算法以后，发起支付请求的画风](https://upload-images.jianshu.io/upload_images/9570900-bb64b30d84844ed5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**计算签名的具体代码实现如下：**
a、创建一个可变字典，用来容纳用于计算签名的各种参数，首先放入`cid`，注意`cid`可以先写死，但是要带入计算部分。
```
NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//可以先写死，但是要带入计算部分
dict[@"cid"] = @"000001";
```
b、接着放入用户标识`uid`，`uid`从沙盒中获取，第一次登陆后存储`uid`到本地沙盒，并且保存登录状态，其中保存的方法如下：
```
// content为网络请求返回的内容
NSString *uid = content[@"uid"];
NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
NSString *filePath = [path stringByAppendingPathComponent:@"uid.plist"];
NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] init];
[plistDict setValue:uid forKey:@"uid"];// 存储uid到本地沙盒
[plistDict setValue:@(1) forKey:@"statusCode"]; // 保存登录状态，防止跳转界面时重复登录
[plistDict writeToFile:filePath atomically:YES];
```
从沙盒中获取`uid`放入用于计算签名的字典：
```
//uid用户标识
NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
NSString *filePath = [path stringByAppendingPathComponent:@"uid.plist"];
NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
dict[@"uid"] = plistDict[@"uid"];
```
c、将请求参数放入用于计算签名的字典中。首先需要将请求参数进行序列化为`JSON`数据，接着将`NSData`数据以`utf-8`解码为字符串，但是注意如果`NSData`数据受损，则会返回`nil`，最后字符串放入用于计算签名的字典中。
```
    //将请求参数放入用于计算签名的字典中
    if (parameters.count > 0) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
        NSString *qValue = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        dict[@"q"] = qValue;
    }
```
d、前面的准备工作都是为了这一步的计算签名。首先我们要根据用于计算签名的字典中元素个数创建个可变数组，用于放入用`“=”`拼接字典的`key`和`value`后字符串。
```
    NSMutableArray *dictArray = [NSMutableArray arrayWithCapacity:dict.count];
    for (NSString *key in dict.allKeys) {
        NSString *string = [NSString stringWithFormat:@"%@=%@", key, dict[key]];
        [dictArray addObject:string];
    }
```
接着对放入数组中的字符串进行排序，将排好序的字符串用`";"`进行拼接成为一个完整的字符串。
```
    NSArray *array = [dictArray sortedArrayUsingSelector:@selector(compare:)];
    NSString *signStr = [array componentsJoinedByString:@";"];
```
最后在这个字符串中放入我们的签名密钥。
```
// 密钥可以写在这
signStr = [NSString stringWithFormat:@"%@%@", signStr, @"mUwmfk6viCFCWydSogtH"];
```
大功告成！将这个计算后的签名字符串加密后放入之前我们创建的用于容纳计算签名的各种元素的字典中，作为其中一个元素存在。
```
dict[@"sign"] = [self doMD5String:signStr];
```
注意到，这里使用了MD5进行加密，先引入MD5加密所需的框架：
```
#import <CommonCrypto/CommonCrypto.h>
```
辅助常量：
```
@property (nullable, readonly) const char *UTF8String NS_RETURNS_INNER_POINTER;
typedef uint32_t CC_LONG;       /* 32 bit unsigned integer */
extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md);
#define CC_MD5_DIGEST_LENGTH    16          /* digest length in bytes */
```
核心算法：
```
- (NSString *)doMD5String:(NSString *)string {
    //1: 将字符串转换成C语言的字符串(因为:MD5加密是基于C的)
    const char *cStr = [string UTF8String];
    //2: 初始化一个字符串数组,用来存放MD5加密后的数据
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    //3: 计算MD5的值
    //参数一: 表示要加密的字符串
    //参数二: 表示要加密字符串的长度
    //参数三: 表示接受结果的数组
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    // 从保存结果的数组中，取出值进行加密
    int first = abs([self bytesToInt:result offset:0]);
    int second = abs([self bytesToInt:result offset:4]);
    int third = abs([self bytesToInt:result offset:8]);
    int fourth = abs([self bytesToInt:result offset:12]);
    
    // 将加密后的值拼接后赋值给字符串
    NSString *stirng = [NSString stringWithFormat:@"%d%d%d%d", first, second, third, fourth];
    // 返回加密结果
    return stirng;
}
```
其中用到的`bytesToInt `方法如下：这个设计到MD5 算法底层原理，比较复杂略过。
```
// 从保存结果的数组中，取出值进行加密
- (int)bytesToInt:(Byte[])src offset:(int)offset {
    int value;
    value = (int)(((src[offset] & 0xFF) << 24) | ((src[offset + 1] & 0xFF) << 16) | ((src[offset + 2] & 0xFF) << 8) |
                  (src[offset + 3] & 0xFF));
    return value;
}
```
##2、拼接请求参数的URL
a、首先还是先生成请求参数字符串，第一个放入的还是我们的`cid`。
```
//cid 只拼接了一次，上次是用于计算签名
NSString *parametersURL = @"cid=000001";
```
b、接着放入我们网络请求方法中传入的参数，这是我们的主体部分。
```
if (dict[@"q"]) { 
    parametersURL = [parametersURL stringByAppendingFormat:@"&q=%@",[dict[@"q"]  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]; 
}
```
此处存在一个小问题，因为网络请求会拼接中文参数，用户名登陆等很多地方会用到中文，所以需要针对中文进行编码和解码，举两个比较清晰的例子：
```
编码:
NSString* hStr =@"你好啊";
NSString* hString = [hStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
NSLog(@"hString === %@",hString); // hString === %E4%BD%A0%E5%A5%BD%E5%95%8A
```
```
解码：
NSString*str3 =@"\u5982\u4f55\u8054\u7cfb\u5ba2\u670d\u4eba\u5458\uff1f";
NSString*str5 = [str3 stringByRemovingPercentEncoding];
NSLog(@"str5 ==== %@",str5);// str5 ==== 如何联系客服人员？
```
c、然后放入我们的`uid`，注意`uid`当我们第一次登录的时候是不存在的，第一次登录后才保存到了沙盒中。
```
if (dict[@"uid"]) {
    parametersURL = [parametersURL stringByAppendingFormat:@"&uid=%@",dict[@"uid"]];
}
```
d、最后放入我们千辛万苦得来的签名。
```
parametersURL = [parametersURL stringByAppendingFormat:@"&sign=%@", dict[@"sign"]];
```
e、完美，万事俱备，只欠东风。
```
NSString *strURL = [NSString stringWithFormat:@"https://apiproxytest.ucarinc.com/ucarincapiproxy/action/th/api%@?%@",pathUrl,parametersURL];
NSLog(@"%@",strURL);
```
将请求URL的共同部分提取出来作为baseURL即这里的`https://apiproxytest.ucarinc.com/ucarincapiproxy/action/th/api`，然后将我们本次请求方法中传入的具体`url`拼接到`baseURL`后面，最后再放入我们历经九九八十一难得到的无上至宝——`parametersURL`，注意到这里使用的是`GET`的请求方法。
f、将请求`URL`字符串转变为`NSURL`类型，打完收工。
```
NSURL *url = [NSURL URLWithString:strURL];
```
##3、进行网络请求
这里使用系统的`NSURLSession`来实现简单的`GET`请求。
```
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *resDict;
        NSLog(@"请求完成...");
        if (!error) {// 请求成功
            // 此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理，解析服务器返回的数据
            resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            // 网络请求数据在其他线程，拿到数据后需要返回主线程更新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                // block属性，用于回传数据
                self.transDataBlock(resDict);
            });
        } else {// 请求失败
            NSLog(@"error: %@", error.localizedDescription);
        }
    }];
    [task resume];
```
其中的`block`属性如下：
```
typedef void (^TransDataBlock)(NSDictionary *  content);

@property (copy, nonatomic) TransDataBlock transDataBlock;
```
##4、调用网络请求方法
既然我们实现了刚才的网络请求方法，那么在实际的业务场景中我们应该怎么去调用它呢？
a、首先创建我们的请求参数，例如：
```
NSArray *keysArr = [[NSArray alloc] initWithObjects:@"telephone",@"password",nil];
NSArray *valuesArr = [[NSArray alloc] initWithObjects:self.phoneNumber,self.password,nil];
NSDictionary *dict = [NSDictionary dictionaryWithObjects:valuesArr forKeys:keysArr];
```
b、接着通过`URLRequest` 传入请求参数和相对地址发起网络请求，再使用`block`的方式拿到请求结果处理业务逻辑，注意避免循环引用，要是用`__weak`修饰符。
```
self.urlRequest = [[URLRequest alloc] init];
__weak LoginViewController *weakSelf = self;
self.urlRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
}
[self.urlRequest startRequest:dict pathUrl:@"/home/login"]；
```
c、处理业务逻辑之前，首先需要先判断响应结果的状态码是否正常，这里的测试接口比较特殊判断了两次，一般一次就OK了。
```
NSInteger errorStatusCode = [content[@"code"] integerValue];
if (errorStatusCode == 1) {
     NSDictionary *dict = [NSDictionary dictionaryWithDictionary:content [@"content"]];
     weakSelf.statusCode = [dict[@"code"] integerValue];
      if (self.statusCode == 1) {
      } else {
        NSLog(@"%@",content[@"msg"]);
      } 
}
```
d、为了完整，把业务逻辑也列举出来下。
```
//获取接口数据
NSDictionary *memberRe = [NSDictionary dictionaryWithDictionary:dict[@"re"]];

//保存登录状态，获取uid.....

//通过接口刷新Tab的badgeValue的值.....
delegate.shoppingCartNavigationController.tabBarItem.badgeValue = num;

//刷新页面
[weakSelf.tableView reloadData];
```

