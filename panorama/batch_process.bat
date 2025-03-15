@echo off
setlocal enabledelayedexpansion

REM ��������Ŀ¼
set INPUT_DIR=.

REM ��������Ŀ¼�е�����ͼƬ�ļ�
for %%f in ("%INPUT_DIR%\*.jpg") do (
    REM ��ȡ�ļ�����������չ����
    set FILENAME=%%~nf

    REM �������ļ��������� tile �ļ���
    set TILE_DIR=tiles\!FILENAME!
    if not exist "!TILE_DIR!" mkdir "!TILE_DIR!"

    REM ��ͼ�����浽��Ӧ�� tile �ļ���
    echo ���ڴ����ļ�: %%f
    magick.exe "%%f" ^
        -crop 750x750 -quality 95 ^
        -set filename:tile "%%[fx:page.x/750]_%%[fx:page.y/750]" ^
        -set filename:orig %%~nf ^
        "!TILE_DIR!\%%[filename:orig]_%%[filename:tile].jpg"
)

echo ������ɣ�
pause   
