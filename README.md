# 講座情報アプリ
デモ講座を表示するアプリです

# 機能
- [x] 講座情報を表示します
- [x] オフライン時には取得したことのある講座を表示します
  - [まずサーバーから講座取得を試みる](https://native-team-code-test-api.herokuapp.com/api/courses)
  - 講座一覧取得できたら[進捗率を取得する](https://native-team-code-test-api.herokuapp.com/api/5d662ee46fa3b05b18005223/usage)
  - 講座一覧の取得に失敗する場合はローカルDBから取得する
  - サーバから取得できず、ローカルDBからも取得できない場合はエラー画面を表示する

# 使用技術
- Redux
- SwiftUI
- async/await
