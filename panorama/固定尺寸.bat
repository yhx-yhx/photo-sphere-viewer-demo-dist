@echo off
setlocal enabledelayedexpansion

REM ��������Ŀ¼
set INPUT_DIR=.

REM ����ͼ���С
set WIDTH=905
set HEIGHT=905

REM ���ImageMagick�Ƿ����
where magick.exe >nul 2>&1
if errorlevel 1 (
    echo ����δ�ҵ�ImageMagick�����Ȱ�װ�����û�������
    pause
    exit /b 1
)

REM ����Ƿ���ͼƬ�ļ�
set FILE_COUNT=0
for %%f in ("%INPUT_DIR%\*.jpg") do set /a FILE_COUNT+=1
if %FILE_COUNT%==0 (
    echo ����δ�ҵ��κ�.jpg�ļ�
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
        echo ����Ŀ¼: !TILE_DIR!
        mkdir "!TILE_DIR!"
    )

    REM ��ͼ�����浽��Ӧ�� tile �ļ���
    magick.exe "%%f" ^
        -crop !WIDTH!x!HEIGHT! -quality 95 ^
        -set filename:tile "%%[fx:page.x/!WIDTH!]_%%[fx:page.y/!HEIGHT!]" ^
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
        echo ���ɵ�����ͼƬ: !LOW_QUALITY_FILE!
        magick.exe "%%f"  -quality 20 "!LOW_QUALITY_FILE!"
        if errorlevel 1 (
            echo �������ɵ�����ͼƬʧ��: %%f
            pause
            exit /b 1
        )
    )
)

echo ������ɣ�
pause