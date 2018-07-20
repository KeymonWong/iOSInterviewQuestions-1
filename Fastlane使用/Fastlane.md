
序号  | Action | Author | Description | 描述 | 注意事项
---- | ------ | ------ | ------------ | --- | ---
001 | adb | hjanuschka | Run ADB Actions | 安卓adb | 无
002 | adb_devices | hjanuschka | Get an array of Connected android device serials | 获取所有连接的安卓设备device serials | 无
003 | add_extra_platforms | lacostej | Modify the default list of supported platforms | 无 | 无
004 | add_git_tag | Multiple | This will add an annotated git tag to the current branch | 当前分支打tag | 无
005 | app_store_build_number | hjanuschka | Returns the current build_number of either live or edit version | 无 | 无
006 | appaloosa | Appaloosa | Upload your app to Appaloosa Store | 上传到Appaloosa | 付费
007 | appetize | Multiple | Upload your app to Appetize.io to stream it in the browser | 无 | 无
008 | appetize_viewing_url_generator | KrauseFx | Generate an URL for appetize simulator | 在浏览器查看Native | 无
009 | appium | yonekawa | Run UI test by Appium with RSpec | UI 测试 | 无
010 | appledoc | alexmx | Generate Apple-like source code | 没懂 | 无

0001 | cocoapods | Multiple | Runs `pod install` for the project | pod 安装不是uodate | 无
002 | deliver | KrauseFx | Alias for the `upload_to_app_store` action | `upload_to_app_store` 的别名 | 无
0002 | gym | KrauseFx | Alias for the `build_ios_app` action | `build_ios_app` 的别名 | 无
0002 | increment_build_number | KrauseFx | Increment the build number of your | 增加build版本号 | 需要先配置build setting
0003 | testflight | ldl | Alias for the `upload_to_testflight` action | `upload_to_testflight` 的别名 | 无


|                        | documentation from     |                  |
|                        | the source code        |                  |
| appstore               | Alias for the          | KrauseFx         |
|                        | `upload_to_app_store`  |                  |
|                        | action                 |                  |
| apteligent             | Upload dSYM file to    | Mo7amedFouad     |
|                        | Apteligent             |                  |
|                        | (Crittercism)          |                  |
| artifactory            | This action uploads    | Multiple         |
|                        | an artifact to         |                  |
|                        | artifactory            |                  |
| automatic_code_signin  | Configures Xcode's     | Multiple         |
| g                      | Codesigning options    |                  |
| backup_file            | This action backs up   | gin0606          |
|                        | your file to           |                  |
|                        | "[path].back"          |                  |
| backup_xcarchive       | Save your [zipped]     | dral3x           |
|                        | xcarchive elsewhere    |                  |
|                        | from default path      |                  |
| badge (DEPRECATED)     | Automatically add a    | DanielGri        |
|                        | badge to your app      |                  |
|                        | icon                   |                  |
| build_and_upload_to_a  | Generate and upload    | KrauseFx         |
| ppetize                | an ipa file to         |                  |
|                        | appetize.io            |                  |
| build_android_app      | Alias for the          | Multiple         |
|                        | `gradle` action        |                  |
| build_app              | Alias for the          | KrauseFx         |
|                        | `build_ios_app`        |                  |
|                        | action                 |                  |
| build_ios_app          | Easily build and sign  | KrauseFx         |
|                        | your app (via _gym_)   |                  |
| bundle_install         | This action runs       | Multiple         |
|                        | `bundle install` (if   |                  |
|                        | available)             |                  |
| capture_android_scree  | Automated localized    | Multiple         |
| nshots                 | screenshots of your    |                  |
|                        | Android app (via       |                  |
|                        | _screengrab_)          |                  |
| capture_ios_screensho  | Generate new           | KrauseFx         |
| ts                     | localized screenshots  |                  |
|                        | on multiple devices    |                  |
|                        | (via _snapshot_)       |                  |
| capture_screenshots    | Alias for the          | KrauseFx         |
|                        | `capture_ios_screensh  |                  |
|                        | ots` action            |                  |
| carthage               | Runs `carthage` for    | Multiple         |
|                        | your project           |                  |
| cert                   | Alias for the          | KrauseFx         |
|                        | `get_certificates`     |                  |
|                        | action                 |                  |
| changelog_from_git_co  | Collect git commit     | Multiple         |
| mmits                  | messages into a        |                  |
|                        | changelog              |                  |
| chatwork               | Send a success/error   | astronaughts     |
|                        | message to ChatWork    |                  |
| check_app_store_metad  | Check your app's       | taquitos         |
| ata                    | metadata before you    |                  |
|                        | submit your app to     |                  |
|                        | review (via            |                  |
|                        | _precheck_)            |                  |
| clean_build_artifacts  | Deletes files created  | lmirosevic       |
|                        | as result of running   |                  |
|                        | gym, cert, sigh or     |                  |
|                        | download_dsyms         |                  |
| clean_cocoapods_cache  | Remove the cache for   | alexmx           |
|                        | pods                   |                  |
| clear_derived_data     | Deletes the Xcode      | KrauseFx         |
|                        | Derived Data           |                  |
| clipboard              | Copies a given string  | KrauseFx         |
|                        | into the clipboard.    |                  |
|                        | Works only on macOS    |                  |
| cloc                   | Generates a Code       | intere           |
|                        | Count that can be      |                  |
|                        | read by Jenkins (xml   |                  |
|                        | format)                |                  |
| --cocoapods              | Runs `pod install`     | Multiple         |
|                        | for the project        |                  |
| commit_github_file     | This will commit a     | tommeier         |
|                        | file directly on       |                  |
|                        | GitHub via the API     |                  |
| commit_version_bump    | Creates a 'Version     | lmirosevic       |
|                        | Bump' commit. Run      |                  |
|                        | after                  |                  |
|                        | `increment_build_numb  |                  |
|                        | er`                    |                  |
| copy_artifacts         | Copy and save your     | lmirosevic       |
|                        | build artifacts        |                  |
|                        | (useful when you use   |                  |
|                        | reset_git_repo)        |                  |
| crashlytics            | Upload a new build to  | Multiple         |
|                        | Crashlytics Beta       |                  |
| create_app_online      | Creates the given      | KrauseFx         |
|                        | application on iTC     |                  |
|                        | and the Dev Portal     |                  |
|                        | (via _produce_)        |                  |
| create_keychain        | Create a new Keychain  | gin0606          |
| create_pull_request    | This will create a     | Multiple         |
|                        | new pull request on    |                  |
|                        | GitHub                 |                  |
| danger                 | Runs `danger` for the  | KrauseFx         |
|                        | project                |                  |
| debug                  | Print out an overview  | KrauseFx         |
|                        | of the lane context    |                  |
|                        | values                 |                  |
| default_platform       | Defines a default      | KrauseFx         |
|                        | platform to not have   |                  |
|                        | to specify the         |                  |
|                        | platform               |                  |
| delete_keychain        | Delete keychains and   | Multiple         |
|                        | remove them from the   |                  |
|                        | search list            |                  |
| --deliver                | Alias for the          | KrauseFx         |
|                        | `upload_to_app_store`  |                  |
|                        | action                 |                  |
| deploygate             | Upload a new build to  | Multiple         |
|                        | [DeployGate](https://  |                  |
|                        | deploygate.com/)       |                  |
| dotgpg_environment     | Reads in production    | simonlevy5       |
|                        | secrets set in a       |                  |
|                        | dotgpg file and puts   |                  |
|                        | them in ENV            |                  |
| download               | Download a file from   | KrauseFx         |
|                        | a remote server (e.g.  |                  |
|                        | JSON file)             |                  |
| download_dsyms         | Download dSYM files    | KrauseFx         |
|                        | from App Store         |                  |
|                        | Connect for Bitcode    |                  |
|                        | apps                   |                  |
| dsym_zip               | Creates a zipped dSYM  | lmirosevic       |
|                        | in the project root    |                  |
|                        | from the .xcarchive    |                  |
| echo                   | Alias for the `puts`   | KrauseFx         |
|                        | action                 |                  |
| ensure_git_branch      | Raises an exception    | Multiple         |
|                        | if not on a specific   |                  |
|                        | git branch             |                  |
| ensure_git_status_cle  | Raises an exception    | Multiple         |
| an                     | if there are           |                  |
|                        | uncommitted git        |                  |
|                        | changes                |                  |
| ensure_no_debug_code   | Ensures the given      | KrauseFx         |
|                        | text is nowhere in     |                  |
|                        | the code base          |                  |
| ensure_xcode_version   | Ensure the right       | Multiple         |
|                        | version of Xcode is    |                  |
|                        | used                   |                  |
| environment_variable   | Sets/gets env vars     | taquitos         |
|                        | for Fastlane.swift.    |                  |
|                        | Don't use in ruby,     |                  |
|                        | use `ENV[key] = val`   |                  |
| erb                    | Allows to Generate     | hjanuschka       |
|                        | output files based on  |                  |
|                        | ERB templates          |                  |
| fastlane_version       | Alias for the          | KrauseFx         |
|                        | `min_fastlane_version  |                  |
|                        | ` action               |                  |
| flock                  | Send a message to a    | Manav            |
|                        | Flock group            |                  |
| frame_screenshots      | Adds device frames     | KrauseFx         |
|                        | around all             |                  |
|                        | screenshots (via       |                  |
|                        | _frameit_)             |                  |
| frameit                | Alias for the          | KrauseFx         |
|                        | `frame_screenshots`    |                  |
|                        | action                 |                  |
| gcovr                  | Runs test coverage     | dtrenz           |
|                        | reports for your       |                  |
|                        | Xcode project          |                  |
| get_build_number       | Get the build number   | Liquidsoul       |
|                        | of your project        |                  |
| get_build_number_repo  | Get the build number   | Multiple         |
| sitory                 | from the current       |                  |
|                        | repository             |                  |
| get_certificates       | Create new iOS code    | KrauseFx         |
|                        | signing certificates   |                  |
|                        | (via _cert_)           |                  |
| get_github_release     | This will verify if a  | Multiple         |
|                        | given release version  |                  |
|                        | is available on        |                  |
|                        | GitHub                 |                  |
| get_info_plist_value   | Returns value from     | kohtenko         |
|                        | Info.plist of your     |                  |
|                        | project as native      |                  |
|                        | Ruby data structures   |                  |
| get_ipa_info_plist_va  | Returns a value from   | johnboiles       |
| lue                    | Info.plist inside a    |                  |
|                        | .ipa file              |                  |
| get_provisioning_prof  | Generates a            | KrauseFx         |
| ile                    | provisioning profile,  |                  |
|                        | saving it in the       |                  |
|                        | current folder (via    |                  |
|                        | _sigh_)                |                  |
| get_push_certificate   | Ensure a valid push    | KrauseFx         |
|                        | profile is active,     |                  |
|                        | creating a new one if  |                  |
|                        | needed (via _pem_)     |                  |
| get_version_number     | Get the version        | Multiple         |
|                        | number of your         |                  |
|                        | project                |                  |
| git_add                | Directly add the       | Multiple         |
|                        | given file or all      |                  |
|                        | files                  |                  |
| git_branch             | Returns the name of    | KrauseFx         |
|                        | the current git        |                  |
|                        | branch, possibly as    |                  |
|                        | managed by CI ENV      |                  |
|                        | vars                   |                  |
| git_commit             | Directly commit the    | KrauseFx         |
|                        | given file with the    |                  |
|                        | given message          |                  |
| git_pull               | Executes a simple git  | Multiple         |
|                        | pull command           |                  |
| git_submodule_update   | Executes a git         | braunico         |
|                        | submodule command      |                  |
| git_tag_exists         | Checks if the git tag  | antondomashnev   |
|                        | with the given name    |                  |
|                        | exists in the current  |                  |
|                        | repo                   |                  |
| github_api             | Call a GitHub API      | tommeier         |
|                        | endpoint and get the   |                  |
|                        | resulting JSON         |                  |
|                        | response               |                  |
| google_play_track_ver  | Retrieves version      | panthomakos      |
| sion_codes             | codes for a Google     |                  |
|                        | Play track             |                  |
| gradle                 | All gradle related     | Multiple         |
|                        | actions, including     |                  |
|                        | building and testing   |                  |
|                        | your Android app       |                  |
| --gym                    | Alias for the          | KrauseFx         |
|                        | `build_ios_app`        |                  |
|                        | action                 |                  |
| hg_add_tag             | This will add a hg     | sjrmanning       |
|                        | tag to the current     |                  |
|                        | branch                 |                  |
| hg_commit_version_bum  | This will commit a     | sjrmanning       |
| p                      | version bump to the    |                  |
|                        | hg repo                |                  |
| hg_ensure_clean_statu  | Raises an exception    | sjrmanning       |
| s                      | if there are           |                  |
|                        | uncommitted hg         |                  |
|                        | changes                |                  |
| hg_push                | This will push         | sjrmanning       |
|                        | changes to the remote  |                  |
|                        | hg repository          |                  |
| hipchat                | Send a error/success   | jingx23          |
|                        | message to HipChat     |                  |
| hockey                 | Upload a new build to  | Multiple         |
|                        | HockeyApp              |                  |
| ifttt                  | Connect to the IFTTT   | vpolouchkine     |
|                        | Maker Channel.         |                  |
|                        | https://ifttt.com/mak  |                  |
|                        | er                     |                  |
| import                 | Import another         | KrauseFx         |
|                        | Fastfile to use its    |                  |
|                        | lanes                  |                  |
| import_certificate     | Import certificate     | gin0606          |
|                        | from inputfile into a  |                  |
|                        | keychain               |                  |
| import_from_git        | Import another         | Multiple         |
|                        | Fastfile from a        |                  |
|                        | remote git repository  |                  |
|                        | to use its lanes       |                  |
| increment_build_number | Increment the build    | KrauseFx         |
|                        | number of your         |                  |
|                        | project                |                  |
| increment_version_num  | Increment the version  | serluca          |
| ber                    | number of your         |                  |
|                        | project                |                  |
| install_on_device      | Installs an .ipa file  | hjanuschka       |
|                        | on a connected         |                  |
|                        | iOS-device via usb or  |                  |
|                        | wifi                   |                  |
| install_xcode_plugin   | Install an Xcode       | Multiple         |
|                        | plugin for the         |                  |
|                        | current user           |                  |
| installr               | Upload a new build to  | scottrhoyt       |
|                        | Installr               |                  |
| ipa (DEPRECATED)       | Easily build and sign  | joshdholtz       |
|                        | your app using         |                  |
|                        | shenzhen               |                  |
| is_ci                  | Is the current run     | KrauseFx         |
|                        | being executed on a    |                  |
|                        | CI system, like        |                  |
|                        | Jenkins or Travis      |                  |
| jazzy                  | Generate docs using    | KrauseFx         |
|                        | Jazzy                  |                  |
| jira                   | Leave a comment on     | iAmChrisTruman   |
|                        | JIRA tickets           |                  |
| lane_context           | Access lane context    | KrauseFx         |
|                        | values                 |                  |
| last_git_commit        | Return last git        | ngutman          |
|                        | commit hash,           |                  |
|                        | abbreviated commit     |                  |
|                        | hash, commit message   |                  |
|                        | and author             |                  |
| last_git_tag           | Get the most recent    | KrauseFx         |
|                        | git tag                |                  |
| latest_testflight_bui  | Fetches most recent    | daveanderson     |
| ld_number              | build number from      |                  |
|                        | TestFlight             |                  |
| lcov                   | Generates coverage     | thiagolioy       |
|                        | data using lcov        |                  |
| mailgun                | Send a success/error   | thiagolioy       |
|                        | message to an email    |                  |
|                        | group                  |                  |
| make_changelog_from_j  | Generate a changelog   | mandrizzle       |
| enkins                 | using the Changes      |                  |
|                        | section from the       |                  |
|                        | current Jenkins build  |                  |
| match                  | Alias for the          | KrauseFx         |
|                        | `sync_code_signing`    |                  |
|                        | action                 |                  |
| min_fastlane_version   | Verifies the minimum   | KrauseFx         |
|                        | fastlane version       |                  |
|                        | required               |                  |
| modify_services        | Modifies the services  | bhimsenpadalkar  |
|                        | of the app created on  |                  |
|                        | Developer Portal       |                  |
| nexus_upload           | Upload a file to       | Multiple         |
|                        | Sonatype Nexus         |                  |
|                        | platform               |                  |
| notification           | Display a macOS        | Multiple         |
|                        | notification with      |                  |
|                        | custom message and     |                  |
|                        | title                  |                  |
| notify (DEPRECATED)    | Shows a macOS          | Multiple         |
|                        | notification - use     |                  |
|                        | `notification`         |                  |
|                        | instead                |                  |
| number_of_commits      | Return the number of   | Multiple         |
|                        | commits in current     |                  |
|                        | git branch             |                  |
| oclint                 | Lints implementation   | HeEAaD           |
|                        | files with OCLint      |                  |
| onesignal              | Create a new           | Multiple         |
|                        | OneSignal application  |                  |
| opt_out_crash_reporti  | This will prevent      | Multiple         |
| ng (DEPRECATED)        | reports from being     |                  |
|                        | uploaded when          |                  |
|                        | _fastlane_ crashes     |                  |
| opt_out_usage          | This will stop         | KrauseFx         |
|                        | uploading the          |                  |
|                        | information which      |                  |
|                        | actions were run       |                  |
| pem                    | Alias for the          | KrauseFx         |
|                        | `get_push_certificate  |                  |
|                        | ` action               |                  |
| pilot                  | Alias for the          | KrauseFx         |
|                        | `upload_to_testflight  |                  |
|                        | ` action               |                  |
| pod_lib_lint           | Pod lib lint           | thierryxing      |
| pod_push               | Push a Podspec to      | squarefrog       |
|                        | Trunk or a private     |                  |
|                        | repository             |                  |
| podio_item             | Creates or updates an  | Multiple         |
|                        | item within your       |                  |
|                        | Podio app              |                  |
| precheck               | Alias for the          | taquitos         |
|                        | `check_app_store_meta  |                  |
|                        | data` action           |                  |
| println                | Alias for the `puts`   | KrauseFx         |
|                        | action                 |                  |
| produce                | Alias for the          | KrauseFx         |
|                        | `create_app_online`    |                  |
|                        | action                 |                  |
| prompt                 | Ask the user for a     | KrauseFx         |
|                        | value or for           |                  |
|                        | confirmation           |                  |
| push_git_tags          | Push local tags to     | vittoriom        |
|                        | the remote - this      |                  |
|                        | will only push tags    |                  |
| push_to_git_remote     | Push local changes to  | lmirosevic       |
|                        | the remote branch      |                  |
| puts                   | Prints out the given   | KrauseFx         |
|                        | text                   |                  |
| read_podspec           | Loads a CocoaPods      | czechboy0        |
|                        | spec as JSON           |                  |
| recreate_schemes       | Recreate not shared    | jerolimov        |
|                        | Xcode project schemes  |                  |
| register_device        | Registers a new        | pvinis           |
|                        | device to the Apple    |                  |
|                        | Dev Portal             |                  |
| register_devices       | Registers new devices  | lmirosevic       |
|                        | to the Apple Dev       |                  |
|                        | Portal                 |                  |
| reset_git_repo         | Resets git repo to a   | lmirosevic       |
|                        | clean state by         |                  |
|                        | discarding             |                  |
|                        | uncommitted changes    |                  |
| reset_simulator_conte  | Shutdown and reset     | danramteke       |
| nts                    | running simulators     |                  |
| resign                 | Codesign an existing   | lmirosevic       |
|                        | ipa file               |                  |
| restore_file           | This action restore    | gin0606          |
|                        | your file that was     |                  |
|                        | backuped with the      |                  |
|                        | `backup_file` action   |                  |
| rocket                 | Outputs ascii-art for  | Multiple         |
|                        | a rocket 🚀            |                  |
| rsync                  | Rsync files from       | hjanuschka       |
|                        | :source to             |                  |
|                        | :destination           |                  |
| ruby_version           | Verifies the minimum   | sebastianvarela  |
|                        | ruby version required  |                  |
| run_tests              | Easily run tests of    | KrauseFx         |
|                        | your iOS app (via      |                  |
|                        | _scan_)                |                  |
| s3 (DEPRECATED)        | Generates a plist      | joshdholtz       |
|                        | file and uploads all   |                  |
|                        | to AWS S3              |                  |
| say                    | This action speaks     | KrauseFx         |
|                        | the given text out     |                  |
|                        | loud                   |                  |
| scan                   | Alias for the          | KrauseFx         |
|                        | `run_tests` action     |                  |
| scp                    | Transfer files via     | hjanuschka       |
|                        | SCP                    |                  |
| screengrab             | Alias for the          | Multiple         |
|                        | `capture_android_scre  |                  |
|                        | enshots` action        |                  |
| set_build_number_repo  | Set the build number   | Multiple         |
| sitory                 | from the current       |                  |
|                        | repository             |                  |
| set_changelog          | Set the changelog for  | KrauseFx         |
|                        | all languages on App   |                  |
|                        | Store Connect          |                  |
| set_github_release     | This will create a     | Multiple         |
|                        | new release on GitHub  |                  |
|                        | and upload assets for  |                  |
|                        | it                     |                  |
| set_info_plist_value   | Sets value to          | Multiple         |
|                        | Info.plist of your     |                  |
|                        | project as native      |                  |
|                        | Ruby data structures   |                  |
| set_pod_key            | Sets a value for a     | marcelofabri     |
|                        | key with               |                  |
|                        | cocoapods-keys         |                  |
| setup_circle_ci        | Setup the keychain     | dantoml          |
|                        | and match to work      |                  |
|                        | with CircleCI          |                  |
| setup_jenkins          | Setup xcodebuild, gym  | bartoszj         |
|                        | and scan for easier    |                  |
|                        | Jenkins integration    |                  |
| setup_travis           | Setup the keychain     | KrauseFx         |
|                        | and match to work      |                  |
|                        | with Travis CI         |                  |
| sh                     | Runs a shell command   | KrauseFx         |
| sigh                   | Alias for the          | KrauseFx         |
|                        | `get_provisioning_pro  |                  |
|                        | file` action           |                  |
| skip_docs              | Skip the creation of   | KrauseFx         |
|                        | the                    |                  |
|                        | fastlane/README.md     |                  |
|                        | file when running      |                  |
|                        | fastlane               |                  |
| slack                  | Send a success/error   | KrauseFx         |
|                        | message to your Slack  |                  |
|                        | group                  |                  |
| slather                | Use slather to         | mattdelves       |
|                        | generate a code        |                  |
|                        | coverage report        |                  |
| snapshot               | Alias for the          | KrauseFx         |
|                        | `capture_ios_screensh  |                  |
|                        | ots` action            |                  |
| sonar                  | Invokes sonar-scanner  | c_gretzki        |
|                        | to programmatically    |                  |
|                        | run SonarQube          |                  |
|                        | analysis               |                  |
| splunkmint             | Upload dSYM file to    | xfreebird        |
|                        | Splunk MINT            |                  |
| spm                    | Runs Swift Package     | Flávio Caetano   |
|                        | Manager on your        | (@fjcaetano)     |
|                        | project                |                  |
| ssh                    | Allows remote command  | hjanuschka       |
|                        | execution using ssh    |                  |
| supply                 | Alias for the          | KrauseFx         |
|                        | `upload_to_play_store  |                  |
|                        | ` action               |                  |
| swiftlint              | Run swift code         | KrauseFx         |
|                        | validation using       |                  |
|                        | SwiftLint              |                  |
| sync_code_signing      | Easily sync your       | KrauseFx         |
|                        | certificates and       |                  |
|                        | profiles across your   |                  |
|                        | team (via _match_)     |                  |
| team_id                | Specify the Team ID    | KrauseFx         |
|                        | you want to use for    |                  |
|                        | the Apple Developer    |                  |
|                        | Portal                 |                  |
| team_name              | Set a team to use by   | KrauseFx         |
|                        | its name               |                  |
| testfairy              | Upload a new build to  | Multiple         |
|                        | TestFairy              |                  |
| --testflight             | Alias for the          | KrauseFx         |
|                        | `upload_to_testflight  |                  |
|                        | ` action               |                  |
| tryouts                | Upload a new build to  | alicertel        |
|                        | Tryouts                |                  |
| twitter                | Post a tweet on        | hjanuschka       |
|                        | Twitter.com            |                  |
| typetalk               | Post a message to      | Nulab Inc.       |
|                        | Typetalk               |                  |
| unlock_keychain        | Unlock a keychain      | xfreebird        |
| update_app_group_iden  | This action changes    | mathiasAichinger |
| tifiers                | the app group          |                  |
|                        | identifiers in the     |                  |
|                        | entitlements file      |                  |
| update_app_identifier  | Update the project's   | Multiple         |
|                        | bundle identifier      |                  |
| update_fastlane        | Makes sure             | Multiple         |
|                        | fastlane-tools are     |                  |
|                        | up-to-date when        |                  |
|                        | running fastlane       |                  |
| update_icloud_contain  | This action changes    | JamesKuang       |
| er_identifiers         | the iCloud container   |                  |
|                        | identifiers in the     |                  |
|                        | entitlements file      |                  |
| update_info_plist      | Update a Info.plist    | tobiasstrebitzer |
|                        | file with bundle       |                  |
|                        | identifier and         |                  |
|                        | display name           |                  |
| update_plist           | Update a plist file    | rishabhtayal     |
| update_project_code_s  | Updated code signing   | KrauseFx         |
| igning (DEPRECATED)    | settings from          |                  |
|                        | 'Automatic' to a       |                  |
|                        | specific profile       |                  |
| update_project_provis  | Update projects code   | Multiple         |
| ioning                 | signing settings from  |                  |
|                        | your provisioning      |                  |
|                        | profile                |                  |
| update_project_team    | Update Xcode           | lgaches          |
|                        | Development Team ID    |                  |
| update_urban_airship_  | Set the Urban Airship  | kcharwood        |
| configuration          | plist configuration    |                  |
|                        | values                 |                  |
| update_url_schemes     | Updates the URL        | kmikael          |
|                        | schemes in the given   |                  |
|                        | Info.plist             |                  |
| upload_symbols_to_cra  | Upload dSYM            | KrauseFx         |
| shlytics               | symbolication files    |                  |
|                        | to Crashlytics         |                  |
| upload_symbols_to_sen  | Upload dSYM            | joshdholtz       |
| try (DEPRECATED)       | symbolication files    |                  |
|                        | to Sentry              |                  |
| upload_to_app_store    | Upload metadata and    | KrauseFx         |
|                        | binary to App Store    |                  |
|                        | Connect (via           |                  |
|                        | _deliver_)             |                  |
| upload_to_play_store   | Upload metadata,       | KrauseFx         |
|                        | screenshots and        |                  |
|                        | binaries to Google     |                  |
|                        | Play (via _supply_)    |                  |
| upload_to_testflight   | Upload new binary to   | KrauseFx         |
|                        | App Store Connect for  |                  |
|                        | TestFlight beta        |                  |
|                        | testing (via _pilot_)  |                  |
| verify_build           | Able to verify         | CodeReaper       |
|                        | various settings in    |                  |
|                        | ipa file               |                  |
| verify_pod_keys        | Verifies all keys      | ashfurrow        |
|                        | referenced from the    |                  |
|                        | Podfile are non-empty  |                  |
| verify_xcode           | Verifies that the      | KrauseFx         |
|                        | Xcode installation is  |                  |
|                        | properly signed by     |                  |
|                        | Apple                  |                  |
| version_bump_podspec   | Increment or set the   | Multiple         |
|                        | version in a podspec   |                  |
|                        | file                   |                  |
| version_get_podspec    | Receive the version    | Multiple         |
|                        | number from a podspec  |                  |
|                        | file                   |                  |
| xcarchive              | Archives the project   | dtrenz           |
|                        | using `xcodebuild`     |                  |
| xcbuild                | Builds the project     | dtrenz           |
|                        | using `xcodebuild`     |                  |
| xcclean                | Cleans the project     | dtrenz           |
|                        | using `xcodebuild`     |                  |
| xcexport               | Exports the project    | dtrenz           |
|                        | using `xcodebuild`     |                  |
| xcode_install          | Make sure a certain    | Krausefx         |
|                        | version of Xcode is    |                  |
|                        | installed              |                  |
| xcode_select           | Change the xcode-path  | dtrenz           |
|                        | to use. Useful for     |                  |
|                        | beta versions of       |                  |
|                        | Xcode                  |                  |
| xcode_server_get_asse  | Downloads Xcode Bot    | czechboy0        |
| ts                     | assets like the        |                  |
|                        | `.xcarchive` and logs  |                  |
| xcodebuild             | Use the `xcodebuild`   | dtrenz           |
|                        | command to build and   |                  |
|                        | sign your app          |                  |
| xcov                   | Nice code coverage     | nakiostudio      |
|                        | reports without        |                  |
|                        | hassle                 |                  |
| xctest                 | Runs tests on the      | dtrenz           |
|                        | given simulator        |                  |
| xctool                 | Run tests using        | KrauseFx         |
|                        | xctool                 |                  |
| xcversion              | Select an Xcode to     | oysta            |
|                        | use by version         |                  |
|                        | specifier              |                  |
| zip                    | Compress a file or     | KrauseFx         |
|                        | folder to a zip        |                  |
+------------------------+------------------------+------------------+
  Total of 213 actions
