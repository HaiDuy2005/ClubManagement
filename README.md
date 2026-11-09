# ClubManagement — Website quản lý câu lạc bộ văn nghệ

Đồ án cuối kỳ học phần **Điện toán đám mây** của **Nhóm 2**, lớp **242101TH001**, Trường Đại học Bình Dương – Phân hiệu Cà Mau.

ClubManagement hỗ trợ câu lạc bộ văn nghệ sinh viên quản lý thông tin câu lạc bộ, thành viên, hoạt động, đăng ký tham gia, điểm danh và liên hệ.

> README này phản ánh tiến độ ghi trong báo cáo của nhóm. Các bước Docker Compose là quy trình triển khai dự kiến. Nhóm cần xác nhận cấu hình và chạy thử toàn bộ hệ thống trước buổi demo.

## Thành viên

| Họ và tên | MSSV |
| --- | --- |
| Trần Trọng Nghĩa | 24210501025 |
| Nguyễn Hải Duy | 24210501007 |
| Đoàn Hoàng Hảo | 24210501014 |
| Mã Triệu Phát | 24210501030 |
| Trần Nguyễn Khánh Duy | 24210501010 |

## Chức năng và tiến độ

| Hạng mục | Trạng thái theo báo cáo tiến độ |
| --- | --- |
| Trang chủ | Hiển thị tổng quan về thành viên, hoạt động và câu lạc bộ. |
| Quản trị | Có đăng nhập, dashboard và đăng xuất dựa trên session. Cần kiểm thử bảo vệ các trang quản trị và xác nhận vai trò thứ hai. |
| Quản lý nghiệp vụ | Có màn hình quản lý câu lạc bộ, thành viên, hoạt động, đăng ký thành viên, đăng ký hoạt động và liên hệ. Trang đăng ký hoạt động có thao tác duyệt. |
| Tìm kiếm và CRUD | Một số màn hình có tìm kiếm. Cần kiểm thử thêm, sửa, xóa cho ba thực thể chính và xác nhận trang chi tiết. |
| Mô hình dữ liệu | Đã xây dựng các model `Club`, `Member`, `ClubActivity`, `Attendance`, `FileStorage` và `Admin`. |
| MinIO | Đã có container và cấu hình ban đầu. Cần kiểm thử upload, lưu metadata trong MySQL, hiển thị danh sách và xem hoặc tải tệp. |
| REST API | Cần xác nhận API cho ba thực thể chính và tài liệu kiểm thử Swagger/OpenAPI hoặc Postman. |
| Triển khai | MySQL đã chạy trong Docker. Cần xác nhận Dockerfile ứng dụng, cấu hình Compose, network, volume và khả năng giữ dữ liệu sau khi tạo lại container. |

## Công nghệ

| Thành phần | Công nghệ và vai trò |
| --- | --- |
| Giao diện | Razor View và Bootstrap |
| Ứng dụng | ASP.NET Core MVC xử lý nghiệp vụ và dựng giao diện |
| Cơ sở dữ liệu | MySQL 8.4. Môi trường phát triển trong báo cáo dùng database `ClubManagementDB` qua cổng host `3307`. |
| Lưu trữ tệp | MinIO Object Storage |
| Triển khai | Docker và Docker Compose. Kiến trúc dự kiến gồm ứng dụng, MySQL và MinIO trong cùng mạng Docker, với volume cho MySQL và MinIO. |

## Triển khai bằng Docker Compose

### Yêu cầu môi trường

- Docker Desktop hoặc Docker Engine đang chạy, có Docker Compose.
- Bản mã nguồn chứa tệp cấu hình Compose, Dockerfile của ứng dụng và `.env.example`.

Mở terminal tại thư mục chứa tệp Compose. Kiểm tra Docker và Compose:

```bash
docker version
docker compose version
```

### Tạo tệp cấu hình

Tạo `.env` từ `.env.example`.

**Windows PowerShell**

```powershell
Copy-Item .env.example .env
```

**Linux hoặc macOS**

```bash
cp .env.example .env
```

Điền các giá trị dùng cho môi trường demo theo tên biến trong tệp Compose và cấu hình ứng dụng. Giữ `.env.example` ở dạng giá trị mẫu và đưa `.env` vào `.gitignore`. Xác nhận cách khởi tạo schema và dữ liệu mẫu. Báo cáo ghi nhận nhóm đã xuất `ClubManagementDB.sql`, bản dump cần được kiểm tra trước khi dùng để khôi phục.

### Khởi động

```bash
docker compose up -d --build
docker compose ps
```

### Cách lấy thông tin truy cập

1. **Tìm cổng web.** Trong kết quả `docker compose ps`, tìm dòng của ứng dụng web và xem cột `PORTS`. Ví dụ, `0.0.0.0:8080->80/tcp` nghĩa là cổng **8080 trên máy** được chuyển tiếp tới cổng **80 trong container**. Nếu ứng dụng dùng HTTP, mở `http://localhost:8080`. Cổng 8080 chỉ là ví dụ. Dùng cổng ngay trước dấu `->` trên dòng của ứng dụng và sao chép URL sau khi mở được trang chủ. Nếu chạy ứng dụng bằng Visual Studio, lấy URL từ trình duyệt do Visual Studio mở và ghi rõ đó là URL chạy local bằng Visual Studio.
2. **Lấy URL đăng nhập quản trị.** Từ trang chủ, mở trang đăng nhập và sao chép địa chỉ trước khi đăng nhập. Đường dẫn `/Account/Dashboard` trong báo cáo là trang quản trị sau khi đăng nhập.
3. **Lấy thông tin API.** Nếu nhóm dùng Swagger, mở trang Swagger và sao chép URL đã thử. Nếu dùng Postman, ghi đường dẫn đến file Collection và giá trị `baseUrl`, tức địa chỉ gốc mà Collection dùng để gửi yêu cầu. Nếu chưa thử, ghi **Chưa kiểm thử**.
4. **Lấy URL MinIO Console.** Tìm dòng MinIO trong `docker compose ps` và đối chiếu với tệp Compose để xác định cổng dành cho Console. Mở trang đăng nhập MinIO bằng cổng host tương ứng rồi sao chép URL.
5. **Xác nhận tài khoản demo.** Đăng nhập thử bằng tài khoản dành riêng cho demo. Ghi tên đăng nhập và cách nhận hoặc tạo tài khoản cho từng vai trò. Giữ mật khẩu ngoài README công khai.

Điền các giá trị đã kiểm thử vào bảng dưới đây.

| Mục | Thông tin truy cập |
| --- | --- |
| Giao diện web | **Cần xác nhận.** Mở `http://localhost:<cổng-host-web>` nếu Compose cấu hình HTTP. Dùng giao thức và cổng đã kiểm thử cho bản demo. |
| Quản trị | **Cần xác nhận URL đăng nhập.** Báo cáo xác định dashboard tại `/Account/Dashboard` sau khi đăng nhập. |
| API/Swagger hoặc Postman | **Cần bổ sung.** Ghi URL Swagger đã thử hoặc đường dẫn tới Postman Collection và giá trị `baseUrl`. |
| MinIO Console | **Cần xác nhận.** Ghi URL theo cổng host ánh xạ riêng cho Console trong Compose. |
| Tài khoản demo | **Cần bổ sung.** Ghi tên đăng nhập và cách nhận hoặc khởi tạo tài khoản mẫu cho từng vai trò. Dùng tài khoản riêng cho dữ liệu demo. |

### Dừng hệ thống

```bash
docker compose down
```

Để kiểm thử dữ liệu bền vững, tạo một bản ghi và upload một tệp, dừng bằng lệnh trên rồi chạy `docker compose up -d`. Kiểm tra lại bản ghi trong ứng dụng và thử mở hoặc tải tệp từ MinIO.

### Xóa dữ liệu demo

**Cảnh báo:** Lệnh dưới đây xóa các volume do Compose quản lý trong lần triển khai này. Dữ liệu MySQL và MinIO có thể bị mất nếu nằm trong các volume đó. Chỉ dùng khi cần đặt lại môi trường demo.

```bash
docker compose down -v
```
