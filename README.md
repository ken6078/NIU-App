![Build Test](https://github.com/ken6078/NIU-App-iOS/workflows/Build%20Test/badge.svg)

# 國立宜蘭大學校務資訊系統 (Niu app)
國立宜蘭大學校務資訊系統 iOS版，使用[Apple Swift](https://developer.apple.com/swift/)進行開發。

National Ilan University System for School Information iOS version.
Develop with [Apple Swift](https://developer.apple.com/swift/).

# 專案截圖
<p float="left">
  <img src="https://raw.githubusercontent.com/ken6078/NIU-App-iOS/develop/screenshot/loginPage.png" width="200" />
  <img src="https://raw.githubusercontent.com/ken6078/NIU-App-iOS/develop/screenshot/menuPage.png" width="200" />
</p>

# 支援功能
 - [x] 登入
 - [x] 學校行事曆
 - [x] 天氣預報
 - [ ] 學校活動系統
   - [X] 查看活動
   - [ ] 報名活動
   - [ ] 活動紀錄
 - [ ] 教務系統
   - [ ] 課表
   - [ ] 成績
   - [ ] 畢業門檻
   - [ ] 請假

# 如何參與開發
如果你想參與本專案，你必須了解Swift的基本架構以及了解多人協作

### 步驟
1. `Fork` 此專案
2. 選擇你想要寫(改善)的功能
3. 創建一個 `分支(Branch)` 並以該功能命名
   Ex: **改善登入方法**則把分支命名為 `feature/improve-login-method`
4. 使用以下程式碼開啟專案並開始寫程式
``` bash
cd "NIU App"
pod install
open "NIU App.xcworkspace"
```
5. 提出 `合併請求(Pull Request)` 從 `feature分支` 合併到 `develop分支`
6. (如有必要)等待並解決相關問題
7. 完成合併
