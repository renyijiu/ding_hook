# DingHook

钉钉群机器人中自定义机器人的webhook封装版本，更方便在项目中的使用。[钉钉文档地址](https://open-doc.dingtalk.com/docs/doc.htm?treeId=257&articleId=105735&docType=1)
![robot.png](https://i.loli.net/2018/12/02/5c03c363974b1.png)
## 安装

如果需要在项目中使用，把下面代码增加到你的Gemfile中：

```ruby
gem 'ding_hook'
```

然后执行下列命令：

    $ bundle

或者是直接安装对应的gem包使用：

    $ gem install ding_hook

## 配置
### 文件配置
1. 在 Rails 项目中使用时，默认会读取`config`目录下的`dinghook.yml`文件
2. 非 Rails 项目中，默认读取当前目录中`config`目录下的`dinghook.yml`文件；若不存在，则读取当前用户主目录下的`.ding_hook.yml`文件

配置格式：
```yaml
default: access_token                # 默认机器人
dev: dev_group_access_token          # example, 不同分组机器人
alarm: alarm_group_access_token      # example, 不同分组机器人
```

### 代码配置
当然也可以在代码中去配置对应的`access_token`, 当前配置会覆盖文件中的相同配置项

```ruby
DingHook.configure do |config|
  config[:default] = 'access_token'
  config[:dev] = 'dev_group_access_token'
  config[:alarm] = 'alarm_group_access_token'
end
```

可以通过下列命令查看已配置的信息：
```ruby
  DingHook.config
```

## 项目使用
在项目中使用时，提供了下列的方法调用：

### 文本类型消息

```ruby
# 必需的参数
text = '消息内容' # 文本信息

# 可选参数
options = {
  at_mobiles: [12345678901], # 数组，被@人的手机号码
  is_at_all: false           # Boolean, 是否 @所有人
}

accounts = [:default, :dev]  # 数组，配置的key值，支持多机器人同时发送

# 方法调用
DingHook.send_text_msg(text, options = {}, accounts = [:default])
```

或者是

```ruby
params = {
  text: '消息内容',
  at_mobiles: [],
  is_at_all: true
}

DingHook.send_msg(params, :text, accounts)
```

### link类型消息

```ruby
# 必需参数
text = '消息内容。如果太长只会部分展示'
title = '消息标题'
msg_url = '点击消息跳转的URL'

# 可选参数
options = {
  pic_url: '图片链接'
} 

DingHook.send_link_msg(title, text, msg_url, options = {}, accounts = [:default]) 
```

或者是

```ruby
params = {
  text: '消息内容。如果太长只会部分展示',
  title: '消息标题',
  message_url: '点击消息跳转的URL',
  pic_url: '图片链接'
}

DingHook.send_msg(params, :link, accounts)
```

### markdown类型消息
```ruby
# 必需参数
title = '首屏会话透出的展示内容'
text = 'markdown格式的消息'

# 可选参数
options = {
  at_mobiles: [],
  is_at_all: false
}

# 调用方法
DingHook.send_markdown_msg(title, text, options = {}, accounts = [:default])
```
或者是

```ruby
params = {
  text: 'markdown格式的消息',
  title: '首屏会话透出的展示内容',
  at_mobiles: [],
  is_at_all: false
}

DingHook.send_msg(params, :markdown, accounts)
```

### 发送单个按钮的action_card
````ruby
# 必需参数
title = '首屏会话透出的展示内容'
text = 'markdown格式的消息'
single_title = '按钮提示'
single_url = '点击按钮触发的URL'

# 可选参数
options = {
  btn_orientation: '按钮排列方式，0：垂直排列，1：横向排列',
  hide_avator: '0-正常发消息者头像,1-隐藏发消息者头像'
}

# 方法调用
DingHook.send_single_action_card(title, text, single_title, single_url, options = {}, accounts = [:default])
````

或者是
```ruby
params = {
  title: '首屏会话透出的展示内容',
  text: 'markdown格式的消息',
  single_title: '按钮提示',
  single_url: '点击按钮触发的URL',
  btn_orientation: '按钮排列方式，0：垂直排列，1：横向排列',
  hide_avator: '0-正常发消息者头像,1-隐藏发消息者头像'
}

DingHook.send_msg(params, :action_card, accounts)
```

### 发送多个按钮的action_card

```ruby
# 必需参数
text = 'markdown格式的消息'
title = '首屏会话透出的展示内容'
btns = [{
  title: '按钮方案',
  action_url: '点击按钮触发的URL'
}]

# 可选参数
options = {
  btn_orientation: '按钮排列方式，0：垂直排列，1：横向排列',
  hide_avator: '0-正常发消息者头像,1-隐藏发消息者头像'
}

# 方法调用
DingHook.send_btns_action_card(title, text, btns, options = {}, accounts = [:default])
```
或者是
```ruby
params = {
  title: '首屏会话透出的展示内容',
  text: 'markdown格式的消息',
  btns: [{
    title: '按钮方案',
    action_url: '点击按钮触发的URL',
  }],
  btn_orientation: '按钮排列方式，0：垂直排列，1：横向排列',
  hide_avator: '0-正常发消息者头像,1-隐藏发消息者头像'
}

DingHook.send_msg(params, :action_card, accounts)
```

### 发送feed_card消息
```ruby
# 必需参数
links = [
  {
    title: '单条信息文本',
    message_url: '点击单条信息到跳转链接',
    pic_url: '单条信息后面图片的URL'
  }
]

# 方法调用
DingHook.send_feed_card(links, accounts = [:default])
```

或者是

```ruby
params = {
  links: [
    {
      title: '单条信息文本',
      message_url: '点击单条信息到跳转链接',
      pic_url: '单条信息后面图片的URL'
    }
  ]
}

DingHook.send_msg(params, accounts)
```
### 返回格式
`[true, msg]`
 - true: Boolean 消息发送成功；多账号同时发送时，只有全部成功才会返回true
 - msg: String 错误消息提示

## 命令行使用
```shell
$ bundle exec ding_hook -h
Usage: ding_hook [options]

Specific options:
    -t, --type TYPE                  the type of msg to send: text, link, markdown, action_card, feed_card
    -a <Account1,Account2...>,       the accounts that want to send msg
        --accounts
    -c <Account,Access_token>,       the config of accounts
        --config
        --text TEXT                  the content of msg
        --title TITLE                the title of msg
        --mobiles <Phone_no_1,Phone_no_2...>
                                     the array of mobiles that want to @
        --[no-]all                   the option is want to @all
        --msg-url                    the message url of msg
        --pic-url                    the picture url of msg
        --[no-]btn-vertical          Buttons are arranged vertically
        --[no-]show-avator           show the avator of sender
        --btns <Title,ActionURL>     multi btns for action card
        --single-title Single_title  the single btn title for action card
        --single-url Single_url      the single btn url for action card
        --links <Title,MessageURL,PicURL>
                                     the links for feed card

Common options:
    -h, --help                       Show the help message
    -v, --version                    Show version

```

⚠️：发送对应类型消息时，请参考上面文档，提供所必须的参数，否则消息会发送失败或出现异常错误

例子：
```shell
$ bundle exec ding_hook -c default,access_token -t action_card -a default --text 我爱你 --title ❤ --btns homepage,https://renyijiu.com --btns blog,htts://blog.renyijiu.com --no-btn-vertical --show-avator

```

## 如何贡献

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

欢迎贡献相关代码或是反馈使用时遇到的问题👏，另外请记得为你的代码编写测试。
