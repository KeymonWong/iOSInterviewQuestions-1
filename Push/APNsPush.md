
发展历程：

## 2014年6月  

WWDC-iOS8及以上系统的iOS设备，能够接收的最大playload大小提升到2KB；
低于iOS8的设备以及OS X设备维持256字节。
https://developer.apple.com/videos/wwdc2014

## 2015年6月

WWDC-宣布将在不久的将来发布 “基于 HTTP/2 的全新 APNs 协议”，并在大会上发布了仅仅支持测试证书的版本.
https://developer.apple.com/videos/wwdc2015

## 2015年12月17日

2015年12月17日起，发布 “基于 HTTP/2 的全新 APNs 协议”,iOS 系统以及 OS X 系统，统一将最大 playload 大小提升到4KB。
https://developer.apple.com/news/?id=12172015b


## 来看下新版的 APNs 的新特性：

Request 和 Response 支持JSON网络协议
APNs支持状态码和返回 error 信息
APNs推送成功时 Response 将返回状态码200，远程通知是否发送成功再也不用靠猜了！
APNs推送失败时，Response 将返回 JSON 格式的 Error 信息。
最大推送长度提升到4096字节（4Kb）
可以通过 “HTTP/2 PING ” 心跳包功能检测当前 APNs 连接是否可用，并能维持当前长连接。
支持为不同的推送类型定义 “topic” 主题
不同推送类型，只需要一种推送证书 Universal Push Notification Client SSL 证书。

之前的缺点是：

发送成功与否不知道，只有失败了才知道。
连接断了之后发送出去肯定没有响应，所以APNs接受与否未知
解决方法：发送错误包(invalid token)

# HTTP/2
HTTP/2 是 HTTP 协议发布后的首个更新，于2015年2月17日被批准。它采用了一系列优化技术来整体提升 HTTP 协议的传输性能，如异步连接复用、头压缩等等，可谓是当前互联网应用开发中，网络层次架构优化的首选方案之一。

2015年6月召开的WWDC 2015大会中，向全球开发者宣布，iOS 9 开始支持HTTP/2。

## Universal Push Notification Client SSL 证书
在开发中，往往一条内容，需要向多个终端进行推送，终端有：iOS、tvOS、 and OS X devices, 和借助iOS来实现推送的 Apple Watch。在以往的开发中，不同的推送，需要配置不同的推送证书：我们需要配置：dev证书、prod证书、VOIP证书、等等。而从2015年12月17日起，只使用一种证书就可以了，不再需要那么多证书，这种证书就叫做Universal Push Notification Client SSL 证书（下文统一简称：Universal推送证书）

## 需要吐槽的地方
当 APNs 向你发送了多条推送，但是你的设备网络状况不好，在 APNs 那里下线了，这时 APNs 到你的手机的链路上有多条任务堆积，APNs 的处理方式是，只保留最后一条消息推送给你，然后告知你推送数。那么其他三条消息呢？会被APNs丢弃。

## APNs在推送的链路上堆积，只保留最后一条，iPhone 上线后并不会上传接受情况
有一些 App 的 IM 功能没有维持长连接，是完全通过推送来实现到，通常情况下，这些 App 也已经考虑到了这种丢推送的情况，这些 App 的做法都是，每次收到推送之后，然后向自己的服务器查询当前用户的未读消息。但是APNs也同样无法保证这多条推送能至少有一条到达你的 App。很遗憾的告诉这些App，这次的更新对你们所遭受对这些坑，没有改善。

为什么这么设计？APNs的存储-转发能力太弱，大量的消息存储和转发将消耗Apple服务器的资源，可能是出于存储成本考虑，也可能是因为 Apple 转发能力太弱。总之结果就是 APNs 从来不保证消息的达到率。并且设备上线之后也不会向服务器上传信息。
