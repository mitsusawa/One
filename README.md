# One  
## Overview

The One is the both simple and unofficial "one-night werewolf" server been able to use that Instead of GM. Usable language is Japanese only.  

## Description  

このソフトウェアは主にJSPで書かれおり、Tomcat上で動作を確認しています。現状はまだバグが多いですが、一通り動作はします。  
アナログゲームとして名高いワンナイト人狼のGM(ゲームマスター)の代わりをすることを目標としています。  
プログラミングを覚えたての頃に習作として書いたもののため、出来に関してはご容赦ください。

## Demo

<https://tomcat.mitsusawa.com/one/web/index.jsp>

## Requirement

* Java
* Tomcat等のJava Servlet動作環境
* Javascript対応ウェブブラウザ

## Usage

ページの上から順に操作していく形式となっています。  
QRコードによるログインにも対応しています。

## Install

1. `./web/index.jsp` に `www.hogehoge.com`　となっている箇所が存在するため、設置するサーバのFQDNに書き換えてください。  
2. その後、フォルダ全体をリネーム(任意)し、Tomcatであれば `webapps` フォルダ等にアップロードしてください。
3. デフォルトの設定であれば、 `http://(FQDN)/one/web/index.jsp` にアクセスすれば使用可能です。

## Licence

使用しているライブラリやテンプレートのライセンスは守ってください。  
著作権は放棄しませんが、公序良俗に反しない目的であればご自由に利用、改変、再配布等して頂いて構いません。

## Author

[mitsusawa](https://github.com/mitsusawa)
