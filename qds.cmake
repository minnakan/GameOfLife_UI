### This file is automatically generated by Qt Design Studio.
### Do not change

add_subdirectory(GameOfLife_UIContent)
add_subdirectory(GameOfLife_UI)
add_subdirectory(App)

target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE
    GameOfLife_UIContentplugin
    GameOfLife_UIplugin)