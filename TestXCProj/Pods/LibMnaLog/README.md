# IosAppFactory

## 前言

回顾十年开发历程，MnaTeam陆陆续续做过DAU上千、上万、上百万和上亿级SDK调用和APP开发，然多数时间忙于功能实现，归纳总结性技术方案、解决问题思路、通用性代码等做的很少，通过技术平台github、掘金、和简书等平台分享也很少。代码是协作和开放的，才能更好的掌握。Show me code！基于统一的开发规范及实施规范，通过多人共建维护一套方便MnaTeam团队使用的基本库。基本库包括安卓平台AndroidAppFactory、IOS平台IosAppFactory和CppAppFactory等。本工程是搭建基本的IOS开发库，如日志保存、文件处理、路由、网络等基本功能库，并将库进行基本的集合和归并，快速建立开发工程或快速演练。

## 框架介绍
IAF总体架构图：
![](https://raw.githubusercontent.com/MnaTeam/IosAppFactory/main/images/iaf_architecture.png)
整个IAF框架共有四层：

* 基础组件：基础组件 Router* 是路由相关的基础组件，Lib* 是自己沉淀或者统一对比以后选择的第三方技术栈，与业务无关，可通用。

* 公共组件：基础框架 Framework 负责通用资源、公共声明、页面路由以及对于底层第三方库的二次封装，所有业务通用的基础通用功能。Common* 则是聚焦一个具体的业务无关的功能，例如反馈、内置浏览器等，这部分功能也与业务无关，可通用。

* 业务组件：基础框架 Application 包含与业务相关的一些公共资源定义，基础功能封装等。Base* 则是聚焦一个具体的业务功能，例如页面卡片、广告等。

* 应用组件：应用组件是可以独立运行的最小单元，而且他们基本只是一个Android Application 的空壳加一些配置文件，所有的业务逻辑都在业务组件层实现。其中里面比较特别的是APPTest，他既是底层业务组件开发中的临时入口，同时也是一些基础功能 和 所有 Pub的测试入口。

## 版本说明
*  podspec版本规则

> Given a version number MAJOR.MINOR.PATCH, increment the:
> 
> MAJOR version when you make incompatible API changes
> 
> MINOR version when you add functionality in a backwards compatible manner
> 
> PATCH version when you make backwards compatible bug fixes
> 

`三段式：MAJOR版本号.MINOR版本号.PATCH版本号
`

*  IosAppFactory模块版本分布规则

> MAJOR版本号根据添加模块的先后，依次分配递增的正整数，例如：
> 
> LibMnaLog ：1
> 
> LibMnaFile ：2



