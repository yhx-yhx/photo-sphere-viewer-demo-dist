@echo off
setlocal enabledelayedexpansion

REM 设置输入目录
set INPUT_DIR=.

REM 设置图块大小
set WIDTH=905
set HEIGHT=905

REM 检查ImageMagick是否可用
where magick.exe >nul 2>&1
if errorlevel 1 (
    echo 错误：未找到ImageMagick，请先安装并配置环境变量
    pause
    exit /b 1
)

REM 检查是否有图片文件
set FILE_COUNT=0
for %%f in ("%INPUT_DIR%\*.jpg") do set /a FILE_COUNT+=1
if %FILE_COUNT%==0 (
    echo 错误：未找到任何.jpg文件
    pause
    exit /b 1
)

REM 遍历输入目录中的所有图片文件
for %%f in ("%INPUT_DIR%\*.jpg") do (
    REM 获取文件名（不含扩展名）
    set FILENAME=%%~nf
    echo 正在处理文件: %%f

    REM 创建以文件名命名的 tile 文件夹
    set TILE_DIR=tiles\!FILENAME!
    if not exist "!TILE_DIR!" (
        echo 创建目录: !TILE_DIR!
        mkdir "!TILE_DIR!"
    )

    REM 切图并保存到对应的 tile 文件夹
    magick.exe "%%f" ^
        -crop !WIDTH!x!HEIGHT! -quality 95 ^
        -set filename:tile "%%[fx:page.x/!WIDTH!]_%%[fx:page.y/!HEIGHT!]" ^
        -set filename:orig %%~nf ^
        "!TILE_DIR!\%%[filename:orig]_%%[filename:tile].jpg"
    if errorlevel 1 (
        echo 错误：切图失败: %%f
        pause
        exit /b 1
    )

    REM 生成低质量图片
    set LOW_QUALITY_FILE=%%~dpnf_low.jpg
    if not exist "!LOW_QUALITY_FILE!" (
        echo 生成低质量图片: !LOW_QUALITY_FILE!
        magick.exe "%%f"  -quality 20 "!LOW_QUALITY_FILE!"
        if errorlevel 1 (
            echo 错误：生成低质量图片失败: %%f
            pause
            exit /b 1
        )
    )
)

echo 处理完成！
pause