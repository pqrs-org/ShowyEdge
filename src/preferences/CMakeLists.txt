cmake_minimum_required (VERSION 3.9)

include (../common.cmake)

project (ShowyEdge)

add_executable(
  ShowyEdge
  MACOSX_BUNDLE
  src/AppDelegate.m
  src/ColorsCellView.m
  src/ColorsTableViewDataSource.m
  src/ColorsTableViewDelegate.m
  src/PreferencesWindowController.m
  src/main.m
  ../share/ColorUtilities.m
  ../share/PreferencesClient.m
  ../share/PreferencesModel.m
  ../share/Relauncher.m
  ../share/ServerClient.m
  ../share/SharedUtilities.m
  Resources/Assets.xcassets
  Resources/MainMenu.xib
  Resources/app.icns
)

set_source_files_properties(
  Resources/Assets.xcassets
  Resources/MainMenu.xib
  Resources/ShowyEdge_pub.pem
  Resources/app.icns
  PROPERTIES
  MACOSX_PACKAGE_LOCATION
  Resources
)

set_target_properties(
  ShowyEdge
  PROPERTIES

  MACOSX_BUNDLE_INFO_PLIST
  ${CMAKE_CURRENT_LIST_DIR}/Resources/Info.plist.in

  XCODE_ATTRIBUTE_ENABLE_HARDENED_RUNTIME
  YES
)
