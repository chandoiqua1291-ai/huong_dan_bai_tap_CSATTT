Sau khi khởi động, 2 terminal ảo xuất hiện:

Terminal 1: đăng nhập admin / mật khẩu password123

Terminal 2: dùng để test đăng nhập các tài khoản bob, mary, lisa

Bước 1: Trên Terminal 1 — đăng nhập admin và nâng quyền

Nếu terminal chưa tự đăng nhập, thực hiện:
```bash
login: admin
Password: password123
```
Sau đó nâng quyền lên root để thực hiện các lệnh quản trị (theo yêu cầu đề bài dùng su -s):
```bash
su -s /bin/bash root
```
Bước 2: Tạo tài khoản bob kèm thư mục home
```bash
useradd -m bob
```
Bước 3: Đặt mật khẩu cho bob
```bash
passwd bob
```
Bước 4: Trên Terminal 2 — đăng nhập xác nhận tài khoản bob
```bash
login: bob
Password: <mật khẩu vừa đặt>
```
Kết quả mong đợi: đăng nhập thành công, dấu nhắc chuyển thành bob@...$.

Sau đó exit

Nhiệm vụ 2:

Bước 1: Khởi tạo tài khoản mary và thiết lập mật khẩu.(terminal 1 -admin)
```bash
useradd -m mary
passwd mary
```
Bước 2: Kiểm tra quyền và chủ sở hữu tệp chia sẻ
```bash
ls -l /shared_stuff/tarts.txt
```
Kết quả sẽ có dạng tương tự:
```bash
-rw-r----- 1 root bakers 234 ... /shared_stuff/tarts.txt
```
Bước 3: Thêm mary vào nhóm bakers
```bash
usermod -a -G bakers mary
```
Từ bc 4 là làm trên terminal 2
Bước 4: Đăng nhập mary (Terminal 2) và kiểm tra nhóm
```bash
login: mary
Password: <mật khẩu vừa đặt>
```
```bash
id mary
```
Bước 5: Kiểm thử quyền đọc tệp dữ liệu và khả năng thực thi công cụ nghiệp vụ.
```bash
cat /shared_stuff/tarts.txt
eggcheck tarts.txt
```
Bước 6: Tạo tệp mới trước khi đổi nhóm hiện hành
```bash
touch newfile1.txt
ls -l newfile1.txt
```
Bước 7: Đổi nhóm hiện hành bằng newgrp rồi tạo tệp mới
```bash
newgrp bakers
touch newfile2.txt
ls -l newfile2.txt
```
Sau đó exit

Nhiệm vụ 3:

Bước 1: Đăng nhập bằng tài khoản bob và thử truy cập đọc tệp gốc /shared_stuff/tarts.txt được chia sẻ.
```bash
su - bob
cat /shared_stuff/tarts.txt
```
Kết quả mong đợi:
```bash
cat: /shared_stuff/tarts.txt: Permission denied
```
Bước 2: Mary chạy eggcheck để tạo tệp tạm (Terminal 2)

Thoát khỏi phiên bob trước:

```bash
exit
```
Chuyển sang mary:

```bash
su - mary
```
Chạy công cụ để phát sinh tệp tạm:

```bash
eggcheck tarts.txt
```
exit

Bước 3:  quay lại bob đọc tệp tạm (Terminal 2)
```bash
su - bob
cat /tmp/tmpfile.txt
```
Kết quả mong đợi: Bob đọc được nội dung — dù trước đó (Bước 1) bị từ chối đọc tệp gốc tarts.txt.
Nhiệm vụ 4:

Bước 1: Tạo tài khoản lisa (Terminal 1 — admin/root)
```bash
useradd -m lisa
passwd lisa
```
Nhập mật khẩu 2 lần (ví dụ password4lisa).

Bước 2: Thêm lisa vào nhóm admin
```bash
usermod -a -G admin lisa
```
Bước 3: Đăng nhập lisa và thực hiện xóa bob (Terminal 2)
```bash
su - lisa
```
Thực hiện lệnh xóa tài khoản bob:

```bash
sudo userdel bob
```
