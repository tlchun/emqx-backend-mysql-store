### emqx-backend-mysql-store

EMQX client connection and message save to MySQL
emqx 客户端连接状态和消息持久化到MySQL 插件

### erlang 环境配置
erlang 版本 22
rebar3

### 编译发布插件
1、clone emqx-rel 项目, 切换到改 tag v4.0.7

git clone https://github.com/emqx/emqx-rel.git  
cd emqx-rel  
git checkout v4.0.7  
make  

### 添加自定义插件
#### 1、rebar.config 添加依赖
{deps,
   [
   {emqx_backend_mysql_store, {git, "https://github.com/tlchun/emqx-backend-mysql-store.git", {branch, "master"}}}
   ]
}

#### 2、rebar.config 中 relx 段落添加
{relx,
    [
    {release, {emqx, git_describe},
       [
         {emqx_backend_mysql, load},
       ]
      }
    ]
}
#### 3、编译
make

#### 4、emqx_backend_mysql.conf

%% mysql 服务器
mysql.server = 127.0.0.1:3306
%% 连接池数量
mysql.pool_size = 8
%% mysql 用户名
mysql.username = root
%% mysql密码
mysql.password = 123456
%% 数据库名
mysql.database = mqtt
%% 超时时间（秒）
mysql.query_timeout = 10s

#### 注意执行init.sql文件

#### 5、加载插件
1、./bin/emqx_ctl plugins load emqx_backend_mysql  适合emqx启动后
2、编辑 data/loaded_plugins 添加 {emqx_backend_mysql, true}. 适合未启动之前配置
3、可以在emqx启动后，在 dashboard 插件栏点击启用emqx_backend_mysql 即可启用成功

##### 6、进入dashboard的websocket 创建客户端，创建订阅，创建发布，然后就可以在数据库看到相关的信息
