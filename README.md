# Twi-Kanji
Twi-Kanjiは、Twitterアカウントを使って、簡単な操作で"幹事する"サービスです。
メールアドレスやLineを交換しなくても、オフ会や飲み会の管理ができます。
- 日程の調整
- Twitterリストからメンバー追加
- イベントページをURLで共有(今後リプライ通知機能を追加予定)
など、面倒な幹事のお仕事をサポートします。

登録不要。Twitterアカウントだけで利用できます
https://twi-kanji.herokuapp.com/

# 使用した技術
- フレームワーク
  - Ruby on Rails 5.2.3(Ruby 2.6.3)
- インフラ
  - Docker
  - heroku
  - heroku.ymlを使って、git pushでDockerイメージの自動ビルド
  - heroku Pipeline
- データベース
  - MySQL
- CSSフレームワーク
  - Materialize
- ユーザー認証
  - Devise
  - omniauth-twitter

# 機能
- アカウント登録不要で利用可能(要Twitterアカウント)
- カレンダーから日付候補の選択
- メンバーをTwitterのリストから追加
- プライベート機能(メンバー以外のイベント詳細閲覧不可)
- 出欠情報を1画面で把握可能

# 今後のアップデート予定
- RSpecによるテストの導入
- スケジュールに一人一言コメントできる機能
- DB応答速度改善
- CDNの導入
