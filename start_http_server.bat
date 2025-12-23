@echo off
chcp 65001 >nul 2>&1 :: 确保命令行中文正常显示

:: 配置参数（根据实际情况修改）
set "PYTHON_PATH=D:\ANKD\envs\main\python.exe" :: 你的Python解释器路径
set "PORT=8000" :: 端口号（需与custom_server.py一致）
set "ROOT_DIR=%~dp0" :: 脚本所在目录（自动获取，无需修改）
set "TARGET_FILE=网页效果.html" :: 主页面文件名

:: 检查Python是否存在
if not exist "%PYTHON_PATH%" (
    echo 错误：未找到Python解释器，请检查路径是否正确：
    echo %PYTHON_PATH%
    pause
    exit /b 1
)

:: 检查主HTML文件是否存在
if not exist "%ROOT_DIR%%TARGET_FILE%" (
    echo 错误：未找到文件 %TARGET_FILE%，请确认文件在脚本同目录下
    pause
    exit /b 1
)

:: 检查自定义服务器脚本是否存在
if not exist "%ROOT_DIR%custom_server.py" (
    echo 错误：未找到custom_server.py，请将该文件放在脚本同目录下
    pause
    exit /b 1
)

:: 启动自定义HTTP服务器（后台运行）
start "" "%PYTHON_PATH%" "%ROOT_DIR%custom_server.py"

:: 等待服务启动（2秒延迟，根据电脑性能可调整）
echo 正在启动HTTP服务...
timeout /t 2 /nobreak >nul

:: 浏览器路径配置（常见浏览器默认安装路径）
set "EDGE_PATH=C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
set "CHROME_PATH=C:\Program Files\Google\Chrome\Application\chrome.exe"
set "FIREFOX_PATH=C:\Program Files\Mozilla Firefox\firefox.exe"
set "OPERA_PATH=C:\Program Files\Opera\launcher.exe"

:: 检测可用浏览器
set "BROWSERS="
set "BROWSER_NAMES="
set "INDEX=1"

if exist "%EDGE_PATH%" (
    set "BROWSERS[%INDEX%]=%EDGE_PATH%"
    set "BROWSER_NAMES=%BROWSER_NAMES%%INDEX%. 微软Edge"
    set /a INDEX+=1
)
if exist "%CHROME_PATH%" (
    set "BROWSERS[%INDEX%]=%CHROME_PATH%"
    set "BROWSER_NAMES=%BROWSER_NAMES%\n%INDEX%. 谷歌Chrome"
    set /a INDEX+=1
)
if exist "%FIREFOX_PATH%" (
    set "BROWSERS[%INDEX%]=%FIREFOX_PATH%"
    set "BROWSER_NAMES=%BROWSER_NAMES%\n%INDEX%. 火狐Firefox"
    set /a INDEX+=1
)
if exist "%OPERA_PATH%" (
    set "BROWSERS[%INDEX%]=%OPERA_PATH%"
    set "BROWSER_NAMES=%BROWSER_NAMES%\n%INDEX%. 欧朋Opera"
    set /a INDEX+=1
)

:: 显示浏览器选择菜单
echo.
echo 请选择浏览器（输入序号）：
echo ------------------------
echo %BROWSER_NAMES%
echo ------------------------
set /p "CHOICE=请输入序号: "

:: 验证选择并打开浏览器
set "SELECTED_BROWSER="
for /f "tokens=2 delims==" %%i in ('set BROWSERS[%CHOICE%] 2^>nul') do set "SELECTED_BROWSER=%%i"

if defined SELECTED_BROWSER (
    echo 正在打开 %TARGET_FILE%...
    start "" "%SELECTED_BROWSER%" "http://localhost:%PORT%/%TARGET_FILE%"
) else (
    echo 无效的选择，将使用默认浏览器打开...
    start "" "http://localhost:%PORT%/%TARGET_FILE%"
)

echo.
echo 服务运行中，访问地址：http://localhost:%PORT%/%TARGET_FILE%
echo 提示：关闭服务请回到Python运行窗口按 Ctrl+C 并输入 Y 确认
pause >nul