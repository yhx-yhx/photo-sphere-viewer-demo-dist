@echo off
setlocal enabledelayedexpansion

REM ��������Ŀ¼
set INPUT_DIR=.

REM ���ImageMagick�Ƿ����
where magick.exe >nul 2>&1
if errorlevel 1 (
    echo ����δ�ҵ�ImageMagick�����Ȱ�װ�����û�������
    pause
    exit /b 1
)

REM ��������Ŀ¼�е�����ͼƬ�ļ�
for %%f in ("%INPUT_DIR%\*.jpg") do (
    REM ��ȡ�ļ�����������չ����
    set FILENAME=%%~nf
    echo ���ڴ����ļ�: %%f

    REM �������ļ��������� tile �ļ���
    set TILE_DIR=tiles\!FILENAME!
    if not exist "!TILE_DIR!" (
        mkdir "!TILE_DIR!"
    )

    REM ��ȡͼƬ�ߴ�
    for /f "tokens=1,2" %%a in ('magick.exe "%%f" -format "%%w %%h" info:') do (
        set WIDTH=%%a
        set HEIGHT=%%b
    )

    REM ����ÿ��ͼ��Ĵ�С
    set /a TILE_WIDTH=!WIDTH!/16
    set /a TILE_HEIGHT=!HEIGHT!/8

    REM ��ͼ�����浽��Ӧ�� tile �ļ���
    echo ������ͼ��16��8��
    magick.exe "%%f" ^
        -crop !TILE_WIDTH!x!TILE_HEIGHT! +repage ^
        -set filename:tile "%%[fx:page.x/!TILE_WIDTH!]_%%[fx:page.y/!TILE_HEIGHT!]" ^
        -set filename:orig %%~nf ^
        "!TILE_DIR!\%%[filename:orig]_%%[filename:tile].jpg"
    if errorlevel 1 (
        echo ������ͼʧ��: %%f
        pause
        exit /b 1
    )

    REM ���ɵ�����ͼƬ
    set LOW_QUALITY_FILE=%%~dpnf_low.jpg
    if not exist "!LOW_QUALITY_FILE!" (
        magick.exe "%%f" -resize 25% -quality 60 "!LOW_QUALITY_FILE!"
        if errorlevel 1 (
            echo �������ɵ�����ͼƬʧ��: %%f
            pause
            exit /b 1
        )
    )
)

echo ������ɣ�
pause