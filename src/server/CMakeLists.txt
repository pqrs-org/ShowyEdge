cmake_minimum_required (VERSION 3.9)

include (../common.cmake)

project (ShowyEdge)

add_compile_options(
  -F${CMAKE_CURRENT_LIST_DIR}/../vendor/Sparkle
)

add_executable(
  ShowyEdge
  MACOSX_BUNDLE
  src/AppDelegate.m
  src/MenuBarOverlayView.m
  src/PreferencesManager.m
  src/ServerController.m
  src/ServerForUserspace.m
  src/Updater.m
  src/WorkSpaceData.m
  src/main.m
  ../share/ColorUtilities.m
  ../share/PreferencesModel.m
  ../share/Relauncher.m
  ../share/StartAtLoginUtilities.m
  Resources/MainMenu.xib
  Resources/ShowyEdge_pub.pem
  Resources/app.icns
  ../vendor/Sparkle/Sparkle.framework
)

set_source_files_properties(
  Resources/MainMenu.xib
  Resources/ShowyEdge_pub.pem
  Resources/app.icns
  PROPERTIES
  MACOSX_PACKAGE_LOCATION
  Resources
)

set_source_files_properties(
  ../vendor/Sparkle/Sparkle.framework
  PROPERTIES
  MACOSX_PACKAGE_LOCATION
  Frameworks
)

set_target_properties(
  ShowyEdge
  PROPERTIES
  MACOSX_BUNDLE_INFO_PLIST
  ${CMAKE_CURRENT_LIST_DIR}/Resources/Info.plist.in
)

set_target_properties(
  ShowyEdge
  PROPERTIES
  XCODE_ATTRIBUTE_LD_RUNPATH_SEARCH_PATHS
  "@loader_path @loader_path/../Frameworks"
)

target_link_libraries(
  ShowyEdge
  -F${CMAKE_CURRENT_LIST_DIR}/../vendor/Sparkle
  "-framework Sparkle"
)
