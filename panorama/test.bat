@echo off
setlocal enabledelayedexpansion

REM 设置输入目录
set INPUT_DIR=.

REM 检查ImageMagick是否可用
where magick.exe >nul 2>&1
if errorlevel 1 (
    echo 错误：未找到ImageMagick，请先安装并配置环境变量
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
        mkdir "!TILE_DIR!"
    )

    REM 获取图片尺寸
    for /f "tokens=1,2" %%a in ('magick.exe "%%f" -format "%%w %%h" info:') do (
        set WIDTH=%%a
        set HEIGHT=%%b
    )

    REM 计算每个图块的大小
    set /a TILE_WIDTH=!WIDTH!/16
    set /a TILE_HEIGHT=!HEIGHT!/8

    REM 切图并保存到对应的 tile 文件夹
    echo 正在切图：16列8行
    magick.exe "%%f" ^
        -crop !TILE_WIDTH!x!TILE_HEIGHT! +repage ^
        -set filename:tile "%%[fx:page.x/!TILE_WIDTH!]_%%[fx:page.y/!TILE_HEIGHT!]" ^
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
        magick.exe "%%f" -resize 25% -quality 60 "!LOW_QUALITY_FILE!"
        if errorlevel 1 (
            echo 错误：生成低质量图片失败: %%f
            pause
            exit /b 1
        )
    )
)

echo 处理完成！
pause