![GitHub repo size](https://img.shields.io/github/repo-size/elkan1788/elkan1788.github.io)
![GitHub language count](https://img.shields.io/github/languages/count/elkan1788/elkan1788.github.io)
![GitHub branch checks state](https://img.shields.io/github/checks-status/elkan1788/elkan1788.github.io/main)
[![Build Status](https://api.travis-ci.com/elkan1788/elkan1788.github.io.svg?branch=hugo)](https://travis-ci.com/elkan1788/elkan1788.github.io)
![GitHub deployments](https://img.shields.io/github/deployments/elkan1788/elkan1788.github.io/github-pages)
![GitHub](https://img.shields.io/github/license/elkan1788/elkan1788.github.io)

[中文](README.zh.md) | [English](README.md)

![my-hugo-blog](http://siteimgs.cn-sh2.ufileos.com/hugo-logo.png)

# 使用Hugo引擎重建个人博客

关于我也算是个极客吧，喜欢尝试一些比较新的好技术。但这应该也是最后一次切换个人博客的引擎啦，Hugo引擎的极速与简单，深深地吸引着我，相信当你遇见它后，也会和我一样喜欢上它的。

# 预览：

![my-hugo-blog](http://siteimgs.cn-sh2.ufileos.com/my-hugo-blog.png)


# 使用七牛云存储

下载工具包：[qshell](https://developer.qiniu.com/sdk#official-tool)

关于`qshell`的使用步骤:
```
# 1. 设置你的账号
qshell account ak sk

# 2. 创建目录存放上传的图片
mkdir -p tools/qiniu

# 3. 修改文件名，并修改相关的属性，如你的空间名称，本地路径等
mv tools/_qoniu.json.sample tools/_qiniu.json
vi tools/_qiniu.json 

# 4. 执行上传脚本
qupload.sh

```

图片上传成功日志：

![my-hexo-blog2](http://siteimgs.cn-sh2.ufileos.com/my-hexo-blog2.png)

> 建议可以使用官方最新推出的图形化工具 [Kodo Browser](https://developer.qiniu.com/kodo/5972/kodo-browser)，它操作非常的简单，可以很方便的管理你的资源。


## 许可证
[MIT License](LICENSE).