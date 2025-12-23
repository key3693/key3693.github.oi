import http.server
import socketserver
import os
from urllib.parse import urlparse

# 配置服务器参数
PORT = 8080  # 服务器端口
TARGET_FILE = "网页效果.html"  # 要直接访问的目标HTML文件

# 自定义请求处理器：根路径自动跳转至目标HTML
class CustomHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        # 解析请求路径
        parsed_path = urlparse(self.path)
        # 如果访问根路径（/），自动跳转到目标HTML
        if parsed_path.path == '/':
            self.send_response(302)  # 302临时重定向
            self.send_header('Location', f'/{TARGET_FILE}')
            self.end_headers()
            return
        # 其他路径按默认方式处理
        super().do_GET()

# 获取当前脚本所在目录并切换工作目录
current_dir = os.path.dirname(os.path.abspath(__file__))
os.chdir(current_dir)

try:
    # 使用自定义处理器创建服务器
    with socketserver.TCPServer(("", PORT), CustomHandler) as httpd:
        print(f"本地服务器已启动")
        print(f"直接访问：http://localhost:{PORT}")
        print(f"也可访问：http://localhost:{PORT}/{TARGET_FILE}")
        print("按 Ctrl+C 停止服务器...")
        httpd.serve_forever()

except OSError as e:
    if "address already in use" in str(e):
        print(f"错误：端口 {PORT} 已被占用，请修改PORT变量（如8080）")
    else:
        print(f"启动失败：{e}")
except KeyboardInterrupt:
    print("\n服务器已手动停止")