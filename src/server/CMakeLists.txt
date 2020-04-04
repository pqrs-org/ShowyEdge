cmake_minimum_required (VERSION 3.9)

include (../common.cmake)

project (ShowyEdge)

set(VENDOR_FRAMEWORKS, "")
if(DEFINED ENV{PQRS_ORG_CODE_SIGN_IDENTITY})
  set(VENDOR_FRAMEWORKS, "../vendor/Sparkle/Sparkle.framework")

  add_compile_options(
    -F${CMAKE_CURRENT_LIST_DIR}/../vendor/Sparkle
    -DUSE_SPARKLE
  )

  set_source_files_properties(
    ../vendor/Sparkle/Sparkle.framework
    PROPERTIES
    MACOSX_PACKAGE_LOCATION
    Frameworks
  )
endif()

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
  Resources/app.icns
  ${VENDOR_FRAMEWORKS}
)

set_source_files_properties(
  Resources/MainMenu.xib
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

  XCODE_ATTRIBUTE_LD_RUNPATH_SEARCH_PATHS
  "@loader_path @loader_path/../Frameworks"
)

if(DEFINED ENV{PQRS_ORG_CODE_SIGN_IDENTITY})
  target_link_libraries(
    ShowyEdge
    -F${CMAKE_CURRENT_LIST_DIR}/../vendor/Sparkle
    "-framework Sparkle"
  )
endif()
