import http.server
import socketserver

class CustomHandler(http.server.SimpleHTTPRequestHandler):
    # 强制为HTML文件添加UTF-8编码头，解决中文乱码
    def end_headers(self):
        # 对HTML/HTM文件添加UTF-8编码声明
        if self.path.endswith(('.html', '.htm')):
            self.send_header('Content-Type', 'text/html; charset=utf-8')
        # 对CSS文件添加编码声明（若有样式乱码可启用）
        # elif self.path.endswith('.css'):
        #     self.send_header('Content-Type', 'text/css; charset=utf-8')
        super().end_headers()

if __name__ == '__main__':
    PORT = 8000  # 与批处理脚本保持一致的端口号
    Handler = CustomHandler
    # 绑定所有网络接口，允许本地访问
    with socketserver.TCPServer(("", PORT), Handler) as httpd:
        print(f"HTTP服务已启动，端口：{PORT}，编码：UTF-8")
        print(f"访问地址：http://localhost:{PORT}/网页效果.html")
        print("按 Ctrl+C 停止服务")
        httpd.serve_forever()