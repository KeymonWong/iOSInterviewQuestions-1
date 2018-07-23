
序号  | Action | Author | Description | 描述 | 注意事项
---- | ------ | ------ | ------------ | --- | ---
001 | `adb` | hjanuschka | Run ADB Actions | 安卓adb | 无
002 | `adb_devices` | hjanuschka | Get an array of Connected android device serials | 获取所有连接的安卓设备device serials | 无
003 | `add_extra_platforms` | lacostej | Modify the default list of supported platforms | 无 | 无
004 | `add_git_tag` | Multiple | This will add an annotated git tag to the current branch | 当前分支打tag | 无
005 | `app_store_build_number` | hjanuschka | Returns the current build_number of either live or edit version | 无 | 无
006 | `appaloosa` | Appaloosa | Upload your app to Appaloosa Store | 上传到Appaloosa | 付费
007 | `appetize` | Multiple | Upload your app to Appetize.io to stream it in the browser | 无 | 无
008 | `appetize_viewing_url_generator` | KrauseFx | Generate an URL for appetize simulator | 在浏览器查看Native | 无
009 | `appium` | yonekawa | Run UI test by Appium with RSpec | UI 测试 | 无
010 | `appledoc` | alexmx | Generate Apple-like source code documentation from the source code | 没懂 | 无
011 | `appstore` | KrauseFx | Alias for the `upload_to_app_store` action | `upload_to_app_store` action | 无
012 | `apteligent` | Mo7amedFouad | Upload dSYM file to Apteligent (Crittercism) | 上传dSYM到Apteligent | 国内不好用
013 | `artifactory` | Multiple | This action uploads an artifact to artifactory | 开源的Maven仓库管理者 | 无
014 | `automatic_code_signing` | Multiple | Configures Xcode's Codesigning options | 配置xcode的code sign | 无
015 | `backup_file` | gin0606 | This action backs up your file to "[path].back" | 备份 | 无
016 | `backup_xcarchive` | dral3x | Save your [zipped] xcarchive elsewhere from default path | 备份 xcarchive | 无
017 | `badge (DEPRECATED)` | DanielGri | Automatically add a badge to your app icon | 自动添加badge | 已经过期
018 | `build_and_upload_to_appetize` | KrauseFx | Generate and upload an ipa file to appetize.io | 编译并上传到 appetize | 无
019 | `build_android_app` | Multiple | Alias for the `gradle` action | `gradle` 别名 | 无
020 | `build_app` | KrauseFx | Alias for the `build_ios_app` action | `build_ios_app` 的别名 | 无
021 | `build_ios_app` | KrauseFx | Easily build and sign your app (via _gym_) | 打包iOS | 无
022 | `bundle_install` | Multiple | This action runs `bundle install` (if available) | -- | --
023 | `capture_android_screenshots` | Multiple | Automated localized screenshots of your Android app (via _screengrab_) | -- | --
024 | `capture_ios_screenshots` | KrauseFx | Generate new localized screenshots on multiple devices (via _snapshot_) | -- | --
025 | `capture_screenshots` | KrauseFx | Alias for the `capture_ios_screenshots` action | iOS截图别名 | --
026 | `carthage` | Multiple | Runs `carthage` for your project | carthage | --
027 | `cert` | KrauseFx | Alias for the `get_certificates` action | `get_certificates`别名 | --
028 | `changelog_from_git_commits` | Multiple | Collect git commit messages into a changelog | 收集gitlog | --
029 | `chatwork` | astronaughts | Send a success/error message to ChatWork | 发送消息到 ChatWork | --
030 | `check_app_store_metadata` | taquitos | Check your app's metadata before you submit your app to review (via _precheck_) | 核查元数据 | --
031 | `clean_build_artifacts` | lmirosevic | Deletes files created as result of running gym, cert, sigh or download_dsyms | -- | --
032 | `clean_cocoapods_cache` | alexmx | Remove the cache for pods | 移除cocoapods | --
033 | `clear_derived_data` | KrauseFx | Deletes the Xcode Derived Data | 删除Derived Data | --
034 | `clipboard` | KrauseFx | Copies a given string into the clipboard. Works only on macOS | 剪切板copy(仅macOS) | --
035 | `cloc` | intere | Generates a Code Count that can be read by Jenkins (xml format) | -- | --
036 | `cocoapods` | Multiple | Runs `pod install` for the project | pod 安装不是update | 无
037 | `commit_github_file` | tommeier | This will commit a file directly on GitHub via the API | GitHub提交文件 | --
038 | `commit_version_bump` | lmirosevic | Creates a 'Version Bump' commit. Run after `increment_build_number` | -- | --
039 | `copy_artifacts` | lmirosevic | Copy and save your build artifacts (useful when you use reset_git_repo) | -- | --
040 | `crashlytics` | Multiple | Upload a new build to Crashlytics Beta | -- | --
041 | `create_app_online` | KrauseFx | Creates the given application on iTC and the Dev Portal (via _produce_) | -- | --
042 | `create_keychain` | gin0606 | Create a new Keychain | -- | --
043 | `create_pull_request` | Multiple | This will create a new pull request on GitHub | -- | --
044 | `danger` | KrauseFx | Runs `danger` for the project | -- | --
045 | `debug` | KrauseFx | Print out an overview of the lane context values | -- | --
046 | `default_platform` | KrauseFx | Defines a default platform to not have to specify the platform | -- | --
047 | `delete_keychain` | Multiple | Delete keychains and remove them from the search list | -- | --
048 | deliver | KrauseFx | Alias for the `upload_to_app_store` action | `upload_to_app_store` 的别名 | 无
049 | `deploygate` | Multiple | Upload a new build to [DeployGate](https://deploygate.com/) | -- | --
050 | `dotgpg_environment` | simonlevy5 | Reads in production secrets set in a dotgpg file and puts them in ENV | -- | --
051 | `download` | KrauseFx | Download a file from a remote server (e.g. JSON file)  | -- | --
052 | `download_dsyms` | KrauseFx | Download dSYM files from App Store Connect for Bitcode apps | -- | --
053 | `dsym_zip` | lmirosevic | Creates a zipped dSYM in the project root from the .xcarchive | -- | --
054 | `echo` | KrauseFx | Alias for the `puts` action | -- | --
055 | `ensure_git_branch` | Multiple | Raises an exception if not on a specific git branch | 分支不对报警 | --
056 | `ensure_git_status_clean` | Multiple | Raises an exception if there are uncommitted git changes | 有未提交的报警 | --
057 | `ensure_no_debug_code` | KrauseFx | Ensures the given text is nowhere in the code base | -- | --
058 | `ensure_xcode_version` | Multiple | Ensure the right version of Xcode is used | xcode版本的检验 | --
059 | `environment_variable` | taquitos | Sets/gets env vars for Fastlane.swift. Don't use in ruby, use `ENV[key] = val` | 环境版本 | --
060 | `erb` | hjanuschka | Allows to Generate output files based on ERB templates | -- | --
061 | `fastlane_version` | KrauseFx | Alias for the `min_fastlane_version` action | `min_fastlane_version`别名 | --
062 | `flock` | Manav | Send a message to a Flock group | -- | --
063 | `frame_screenshots` | KrauseFx | Adds device frames around all screenshots (via _frameit_) | -- | --
064 | `frameit` | KrauseFx | Alias for the `frame_screenshots` action | `frame_screenshots` 别名 | --
065 | `gcovr` | dtrenz | Runs test coverage reports for your Xcode project | -- | --
066 | `get_build_number` | Liquidsoul | Get the build number of your project | 获取编译版本号 | --
067 | `get_build_number_repository` | Multiple | Get the build number from the current repository | -- | --
068 | `get_certificates` | KrauseFx | Create new iOS code signing certificates (via _cert_) | -- | --
069 | `get_github_release` | Multiple | This will verify if a given release version is available on GitHub | 验证Github上可用版本号 | --
070 | `get_info_plist_value` | kohtenko | Returns value from Info.plist of your project as native Ruby data structures | 获取Info.plist的内容
071 | `get_ipa_info_plist_value` | johnboiles | Returns a value from Info.plist inside a.ipa file |  获取ipa中的Info.plist的内容 | --
072 | `get_provisioning_profile` | KrauseFx | Generates a provisioning profile, saving it in the current folder (via _sigh_) | 生成新的`provisioning_profile` | --
073 | `get_push_certificate` | KrauseFx | Ensure a valid push profile is active, creating a new one if needed (via _pem_) | 确保可用的Push证书，如果需要会自动创建新的 | --
074 | `get_version_number` | Multiple | Get the version number of your project | 获取工程的版本号 | ---
075 | `git_add` | Multiple | Directly add the given file or all files | git 的 add | --
076 | `git_branch` | KrauseFx | Returns the name of the current git branch, possibly as managed by CI ENV vars | 获取当前的Git分支名称 | --
077 | `git_commit` | KrauseFx | Directly commit the given file with the given message | 提交git | --
078 | `git_pull` | Multiple | Executes a simple git pull command | git拉取 | --
079 | `git_submodule_update` | braunico | Executes a git submodule command | submodule 更新 | --
080 | `git_tag_exists` | antondomashnev | Checks if the git tag with the given name exists in the current repo | 检查git tag 是否存在 | --
081 | `github_api` | tommeier | Call a GitHub API endpoint and get the resulting JSON response | 调取GitHub API | --
082 | `google_play_track_version_codes` | panthomakos | Retrieves version codes for a Google Play track | Google Play track 版本 | --
083 | `gradle` | Multiple | All gradle related actions, including building and testing your Android app  | -- | --
084 | `gym` | KrauseFx | Alias for the `build_ios_app` action | `build_ios_app` 的别名 | 无
085 | `hg_add_tag` | sjrmanning | This will add a hg tag to the current branch | -- | --
086 | `hg_commit_version_bump` | sjrmanning | This will commit a version bump to the hg repo | -- | --
087 | `hg_ensure_clean_status` | sjrmanning | Raises an exception if there are uncommitted hg changes | -- | --
088 | `hg_push` | sjrmanning | This will push changes to the remote hg repository | -- | --
089 | `hipchat` | jingx23 | Send a error/success message to HipChat | -- | --
090 | `hockey` | Multiple | Upload a new build to HockeyApp | -- | --
091 | `ifttt` | vpolouchkine | Connect to the IFTTT Maker Channel. https://ifttt.com/maker | -- | --
092 | `import` | KrauseFx | Import another Fastfile to use its lanes | 引入其他Fastfile | --
093 | `import_certificate` | gin0606 | Import certificate from inputfile into a keychain | 安装证书到钥匙串 | --
094 | `import_from_git` | Multiple | Import another Fastfile from a remote git repository to use its lanes | git仓库拉取其他引入其他Fastfile | --
095 | `increment_build_number` | KrauseFx | Increment the build number of your | 增加build版本号 | 需要先配置build setting
096 | `increment_version_number` | serluca | Increment the version number of your project | 增加version版本 | --
097 | `install_on_device` | hjanuschka | Installs an .ipa file on a connected iOS-device via usb or wifi | 安装ipa到手机通过usb或者WiFi | --
098 | `install_xcode_plugin` | Multiple | Install an Xcode plugin for the current user | xCode 安装插件 | --
099 | `installr` | scottrhoyt | Upload a new build to Installr | -- | --
100 | `ipa (DEPRECATED)` | joshdholtz | Easily build and sign your app using shenzhen | -- | 过期
101 | `is_ci` | KrauseFx | Is the current run being executed on a CI system, like Jenkins or Travis | -- | --
102 | `jazzy` | KrauseFx | Generate docs using Jazzy | -- | --
103 | `jira` | iAmChrisTruman | Leave a comment on JIRA tickets  | -- | --
104 | `lane_context` | KrauseFx | Access lane context values | -- | --
105 | `last_git_commit` | ngutman | Return last git commit hash, abbreviated commit hash, commit message and author | 获取最后一次提交的信息 | --
106 | `last_git_tag` | KrauseFx | Get the most recent git tag | -- | --
107 | `latest_testflight_build_number` | daveanderson | Fetches most recent build number from TestFlight | TestFlight最新的build版本 | --
108 | `lcov` | thiagolioy | Generates coverage data using lcov | -- | --
109 | `mailgun` | thiagolioy | Send a success/error message to an email group | 发送邮件报告结果 | --
110 | `make_changelog_from_jenkins` | mandrizzle | Generate a changelog using the Changes section from the current Jenkins build | -- | --
111 | `match` | KrauseFx | Alias for the `sync_code_signing` action | `sync_code_signing`同步签名的别名 | --
112 | `min_fastlane_version` | KrauseFx | Verifies the minimum fastlane version required | fastlane最低版本验证 | --
113 | `modify_services` | bhimsenpadalkar | Modifies the services of the app created on Developer Portal | -- | --
114 | `nexus_upload` | Multiple | Upload a file to Sonatype Nexus platform | -- | --
115 | `notification` | Multiple | Display a macOS notification with custom message and title | macOS通知 | --
116 | `notify (DEPRECATED)` | Multiple | Shows a macOS notification - use `notification` instead | -- | --
117 | `number_of_commits` | Multiple | Return the number of commits in current git branch | 返回提交号 | --
118 | `oclint` | HeEAaD | Lints implementation files with OCLint | -- | --
119 | `onesignal` | Multiple Create a new OneSignal application | 创建一个application | --
120 | `opt_out_crash_reporting (DEPRECATED)` | Multiple | This will prevent reports from being uploaded when _fastlane_ crashes | -- | --
121 | `opt_out_usage` | KrauseFx | This will stop uploading the information which actions were run | -- | --
122 | `pem` | KrauseFx | Alias for the `get_push_certificate` action| `get_push_certificate` action 别名 | --
123 | `pilot` | KrauseFx | Alias for the `upload_to_testflight` action | `upload_to_testflight`别名 | --
124 | `pod_lib_lint` | thierryxing | Pod lib lint | -- | --
125 | `pod_push` | squarefrog | Push a Podspec to Trunk or a private repository | -- | --
126 | `podio_item` | Multiple | Creates or updates an item within your Podio app | -- | --
127 | `precheck` | taquitos | Alias for the `check_app_store_metadata` action | -- | --
128 | `println` | KrauseFx | Alias for the `puts` action | -- | --
129 | `produce` | KrauseFx | Alias for the `create_app_online` action | -- | --
130 | `prompt` | KrauseFx | Ask the user for a value or for confirmation | -- | --
131 | `push_git_tags` | vittoriom | Push local tags to the remote - this will only push tags | -- | --
132 | `push_to_git_remote` | lmirosevic | Push local changes to the remote branch | -- | --
133 | `puts` | KrauseFx | Prints out the given text | -- | --
134 | `read_podspec` | czechboy0 | Loads a CocoaPods spec as JSON | -- | --
135 | `recreate_schemes` | jerolimov | Recreate not shared Xcode project schemes | -- | ---
136 | `register_device` | pvinis | Registers a new device to the Apple Dev  | 注册新设备 | --
137 | `register_devices` | lmirosevic | Registers new devices to the Apple Dev Portal | 批量注册新设备 | --
138 | `reset_git_repo` | lmirosevic | Resets git repo to a clean state by discarding uncommitted changes | -- | --
139 | `reset_simulator_contents` | danramteke | Shutdown and reset running simulators | 重启正在运行的模拟器 | --
140 | `resign` | lmirosevic | Codesign an existing ipa file | 重签名 | --
141 | `restore_file` | gin0606 | This action restore your file that was backuped with the `backup_file` action | -- | --
142 | `rocket` | Multiple | Outputs ascii-art for a rocket 🚀  | -- | --
143 | `rsync` | hjanuschka | Rsync files from :source to :destination | -- | --
144 | `ruby_version` | sebastianvarela | Verifies the minimum ruby version required | -- | --
145 | `run_tests` | KrauseFx | Easily run tests of your iOS app (via _scan_) | -- | --
146 | `s3 (DEPRECATED)` | joshdholtz | Generates a plist file and uploads all to AWS S3  | -- | --
147 | `say` | KrauseFx | This action speaks the given text out loud | 发出声音 | --
148 | `scan` | KrauseFx | Alias for the `run_tests` action | -- | --
149 | `scp` | hjanuschka | Transfer files via SCP | -- | --
150 | `screengrab` | Multiple | Alias for the `capture_android_screenshots` action | -- | --
151 | `set_build_number_repository` | Multiple | Set the build number from the current repository | -- | --
152 | `set_changelog` | KrauseFx | Set the changelog for all languages on App Store Connect | 在App Store上设置各种语言的log | --
153 | `set_github_release` | Multiple | This will create a new release on GitHub and upload assets for it | -- | --
154 | `set_info_plist_value` | Multiple | Sets value to Info.plist of your project as native Ruby data structures | -- | --
155 | `set_pod_key` | marcelofabri | Sets a value for a key with cocoapods-keys | -- | --
156 | `setup_circle_ci` | dantoml | Setup the keychain and match to work with CircleCI | -- | --
157 | `setup_jenkins` | bartoszj | Setup xcodebuild, gym and scan for easier Jenkins integration | Jenkins | --
158 | `setup_travis` | KrauseFx | Setup the keychain and match to work with Travis CI | -- | --
159 | `sh` | KrauseFx | Runs a shell command | -- | --
160 | `sigh` | KrauseFx | Alias for the `get_provisioning_profile` action | -- | --
161 | `skip_docs` | KrauseFx | Skip the creation of the fastlane/README.md file when running fastlane | -- | --
162 | `slack` | KrauseFx | Send a success/error message to your Slack group | -- | --
163 | `slather` | mattdelves | Use slather to generate a code coverage report | -- | --
164 | `snapshot` | KrauseFx | Alias for the `capture_ios_screenshots` action | -- | --
165 | `sonar` | c_gretzki | Invokes sonar-scanner to programmatically run SonarQube analysis | -- | --
166 | `splunkmint` | xfreebird |  Upload dSYM file to Splunk MINT | -- | --
167 | `spm` | Flávio Caetano(@fjcaetano) | Runs Swift Package Manager on your project | -- | --
168 | `ssh` | hjanuschka | Allows remote command execution using ssh | -- | --
169 | `supply` | KrauseFx | Alias for the `upload_to_play_store` action | -- | --
170 | `swiftlint` | KrauseFx | Run swift code validation using SwiftLint | -- | --
171 | `sync_code_signing` | KrauseFx | Easily sync your certificates and profiles across your team (via _match_) | 同步证书和描述文件 | --
172 | `team_id` | KrauseFx | Specify the Team ID you want to use for the Apple Developer Portal | -- | --
173 | `team_name` | KrauseFx | Set a team to use by its name | -- | --
174 | `testfairy` | Multiple | Upload a new build to TestFairy | -- | --
175 | `testflight` | KrauseFx | Alias for the `upload_to_testflight` action | `upload_to_testflight` 的别名 | 无
176 | `tryouts` | alicertel | Upload a new build to Tryouts | -- | --
177 | `twitter` | hjanuschka | Post a tweet on witter.com | -- | --
178 | `typetalk` | Nulab Inc. | Post a message to Typetalk | -- | --
179 | `unlock_keychain` | xfreebird | Unlock a keychain | -- | --
180 | `update_app_group_identifiers` | mathiasAichinger | This action changes the app group identifiers in the entitlements file | -- | --
181 | `update_app_identifier` | Multiple | Update the project's bundle identifier | -- | --
182 | `update_fastlane` | Multiple | Makes sure fastlane-tools are up-to-date when running fastlane | -- | --
183 | `update_icloud_container_identifiers` | JamesKuang | This action changes the iCloud container identifiers in the entitlements file | -- | --
184 | `update_info_plist` | tobiasstrebitzer | Update a Info.plist file with bundle identifier and display name  | -- | --
185 | `update_plist` | rishabhtayal | Update a plist file | 更新plist file | --
186 | `update_project_code_signing (DEPRECATED)` | KrauseFx | Updated code signing settings from 'Automatic' to a specific profile  | -- | --
187 | `update_project_provisioning` | Multiple | Update projects code signing settings from your provisioning profile | -- | --
188 | `update_project_team` | lgaches | Update Xcode Development Team ID | -- | --
189 | `update_urban_airship_configuration` | kcharwood | Set the Urban Airship plist configuration values | -- | --
190 | `update_url_schemes` | kmikael | Updates the URL schemes in the given Info.plist | -- | --
191 | `upload_symbols_to_crashlytics` | KrauseFx | Upload dSYM symbolication files to Crashlytics | -- | --
192 | `upload_symbols_to_sentry (DEPRECATED)` | joshdholtz | Upload dSYM symbolication files to Sentry | -- | --
193 | `upload_to_app_store` | KrauseFx | Upload metadata and binary to App Store Connect (via _deliver_) | -- | --
194 | `upload_to_play_store` | KrauseFx | Upload metadata, screenshots and binaries to Google Play (via _supply_) | -- | --
195 | `upload_to_testflight` | KrauseFx | Upload new binary to App Store Connect for TestFlight beta testing (via _pilot_) | -- | --
196 | `verify_build` | CodeReaper | Able to verify various settings in ipa file | 在ipa中验证版本 | --
197 | `verify_pod_keys` | ashfurrow | Verifies all keys referenced from the Podfile are non-empty | -- | --
198 | `verify_xcode` | KrauseFx | Verifies that the Xcode installation is properly signed by Apple | -- | --
199 | `version_bump_podspec` | Multiple | Increment or set the version in a podspec file | -- | --
200 | `version_get_podspec` | Multiple | Receive the version number from a podspec file | 获取podspec里的version | --
201 | `xcarchive` | dtrenz | Archives the project using `xcodebuild` | -- | --
202 | `xcbuild` | dtrenz | Builds the project using `xcodebuild` | -- | --
203 | `xcclean` | dtrenz | Cleans the project using `xcodebuild` | -- | --
204 | `xcexport` | dtrenz | Exports the project using `xcodebuild` | -- | --
205 | `xcode_install` | Krausefx | Make sure a certain version of Xcode is installed | 确定xcode版本 | --
206 | `xcode_select` | dtrenz | Change the xcode-path to use. Useful for eta versions of Xcode | xcode版本的切换 | --
207 | `xcode_server_get_assets` | czechboy0 | Downloads Xcode Bot assets like the `.xcarchive` and logs | 下载`.xcarchive` and logs | --
208 | `xcodebuild` | dtrenz | Use the `xcodebuild` command to build and sign your app  | -- | --
209 | `xcov` | nakiostudio | Nice code coverage reports without hassle | -- | --
210 | `xctest` | dtrenz | Runs tests on the given simulator | -- | --
211 | `xctool` | KrauseFx | Run tests using xctool | -- | --
212 | `xcversion` | oysta | Select an Xcode to use by version specifier | 使用版本选择Xcode | --
213 | `zip` | KrauseFx | Compress a file or folder to a zip | -- | --
