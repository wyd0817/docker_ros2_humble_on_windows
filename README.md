# docker_ros2_humble_on_windows
ターミナルだけだが，RvizなどのGUIも動く．

## GUIを使うための設定
X-serverを使えるようにする

1. X-serverをインストール
```
winget install marha.VcXsrv
```
1. X-serverを立ち上げる
    - アプリXLAUNCHをスタートメニューなどから起動
    - 設定は気にせず，nextを押していく

- 参考
https://zenn.dev/dozo/articles/3ef1565b2b069e

## VSCodeで改行の設定を変更する必要がある
Windows上でgit cloneするとCRLFとなってしまうことがあるようだ

![image](https://user-images.githubusercontent.com/83892604/233789822-5dcc164c-874d-42cf-b69c-c60e3cd5972d.png)
