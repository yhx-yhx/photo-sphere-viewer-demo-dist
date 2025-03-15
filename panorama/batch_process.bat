@echo off
setlocal enabledelayedexpansion

REM 设置输入目录
set INPUT_DIR=.

REM 遍历输入目录中的所有图片文件
for %%f in ("%INPUT_DIR%\*.jpg") do (
    REM 获取文件名（不含扩展名）
    set FILENAME=%%~nf

    REM 创建以文件名命名的 tile 文件夹
    set TILE_DIR=tiles\!FILENAME!
    if not exist "!TILE_DIR!" mkdir "!TILE_DIR!"

    REM 切图并保存到对应的 tile 文件夹
    echo 正在处理文件: %%f
    magick.exe "%%f" ^
        -crop 750x750 -quality 95 ^
        -set filename:tile "%%[fx:page.x/750]_%%[fx:page.y/750]" ^
        -set filename:orig %%~nf ^
        "!TILE_DIR!\%%[filename:orig]_%%[filename:tile].jpg"
)

echo 处理完成！
pause   
