Sau khi khởi động, 3 terminal ảo (alice, bob, harry) sẽ hiện ra. Đăng nhập nếu được yêu cầu:
```bash
alice / password4alice
bob / password4bob
harry / password4harry
```
Thực hiện trên terminal Alice
```bash
ls -la /shared_data
getfacl /shared_data
```
Nhiệm vụ 1:

Bước 1: Kiểm tra quyền (terminal Alice)
```bash
cd /shared_data
ls -laR /shared_data
```
Chú ý các tệp/thư mục có dấu + ở cuối chuỗi quyền, rồi xem chi tiết:
```bash
getfacl /shared_data
getfacl /shared_data/bob
getfacl /shared_data/bob/bobstuff.txt
```
Bước 2: Đọc và xem ACL của accounting.txt
```bash
cd /shared_data
cat accounting.txt
getfacl accounting.txt
```
Nếu cat báo Permission denied thì Alice chưa có quyền đọc. Đọc kết quả getfacl để xác định:

Dòng user::, user:<tên>:, group::, group:<tên>:, other::
Dòng mask:: (nhớ quyền hiệu lực = quyền ACL AND mask, chỗ nào bị giới hạn sẽ có ghi chú #effective:)

Ai có w (ví dụ user:bob:rw- hoặc user::rw- với owner) thì người đó ghi được.

Bước 3: Xác định người có quyền ghi và thử ghi

Giả sử từ getfacl thấy người có quyền ghi là X (thay bằng đúng tên bạn thấy). Chuyển sang terminal của X và chạy:
```bash
echo "test ghi" >> /shared_data/accounting.txt
cat /shared_data/accounting.txt
```
Ghi thành công, không báo lỗi: xác nhận đúng.
Báo Permission denied: bạn xác định sai người, quay lại đọc lại getfacl (chú ý mask và #effective).

Có thể thử thêm ở terminal hai người còn lại để đối chiếu.

Bước 4: Bob cấp quyền đọc cho Alice (terminal Bob)
```bash
setfacl -m user:alice:r /shared_data/bob/bobstuff.txt
getfacl /shared_data/bob/bobstuff.txt
```
Kết quả mong đợi có thêm dòng:
```bash
user:alice:r--
```
Các lệnh theo thứ tự (terminal Alice)
Nhiệm vụ 2:

Bước 1: Tạo tệp thử và xem quyền ban đầu
```bash
cd /shared_data/alice
ls -la
getfacl /shared_data/alice
echo "file 1" > test1.txt
getfacl test1.txt
```
Quan sát: test1.txt chưa có dòng user:bob:....

Bước 2: Đặt ACL mặc định cho Bob đọc
```bash
setfacl -d -m user:bob:r /shared_data/alice
getfacl /shared_data/alice
```
Kết quả mong đợi có thêm dòng dạng:
```bash
default:user:bob:r--
```
Bước 3: Tạo tệp mới và so sánh
```bash
echo "file 2" > test2.txt
getfacl test2.txt
getfacl test1.txt
```
Kết quả mong đợi: test2.txt có user:bob:r--, còn test1.txt thì không.

Bước 4: Điều chỉnh nếu cần và xác nhận

Nếu test2.txt không có user:bob:r-- hoặc bị #effective:---, kiểm tra các điểm sau.

Thư mục phải có default:mask cho phép đọc. Thêm bằng:
```bash
setfacl -d -m mask::rw /shared_data/alice
```
Để chắc chắn Harry và người khác không truy cập được, đặt default cho other là không có quyền:
```bash
setfacl -d -m other::--- /shared_data/alice
getfacl /shared_data/alice
```
Sau đó tạo lại một tệp mới để kiểm tra:
```bash
echo "file 3" > test3.txt
getfacl test3.txt
```
Tệp mới nên có:
```bash
user:bob:r--
other::---
```
Nếu muốn Bob cũng đọc được test1.txt (tệp cũ), cấp thủ công:

```bash
setfacl -m user:bob:r /shared_data/alice/test1.txt
```
Nhiệm vụ 3:
Bước 1: Xem nội dung script ban đầu (terminal Bob)
```bash
cat /shared_data/bob/fun
```
Ghi lại nội dung ban đầu để hiểu cấu trúc (thường là một script rỗng hoặc in ra thông báo đơn giản).

Bước 2: Chỉnh sửa script (terminal Bob)

Mở script để sửa:

```bash
nano /shared_data/bob/fun
```
(hoặc vi /shared_data/bob/fun tùy trình soạn thảo có sẵn)

Nội dung gợi ý — script sẽ chạy với quyền của người thực thi nó, đọc accounting.txt bằng quyền đó, rồi ghi bản sao vào nơi Bob truy cập được:

```bash
#!/bin/bash
# Script "fun" - khi ai đó có quyền đọc accounting.txt chạy nó,
# nội dung sẽ được sao chép vào một tệp mà Bob đọc được.
```
```bash
cp /shared_data/accounting.txt /shared_data/bob/leaked_accounting.txt
chmod 644 /shared_data/bob/leaked_accounting.txt
```
Sau khi lưu, cấp quyền thực thi:

```bash
chmod +x /shared_data/bob/fun
```
Giải thích cơ chế: Lệnh cp bên trong script chạy dưới quyền (UID) của người gọi script, không phải của Bob (chủ sở hữu tệp script). Nếu Alice chạy, cp thực hiện với quyền Alice → đọc được accounting.txt → tạo bản sao trong /shared_data/bob/ với quyền 644 (rw-r--r--) → Bob đọc được bản sao đó vì nó là "other" hoặc do Bob sở hữu thư mục.

Lưu ý: cần đảm bảo Bob có quyền ghi vào chính thư mục /shared_data/bob (thường có vì đó là thư mục của Bob) để lệnh cp tạo được tệp mới ở đó.

Bước 3: Bob tự chạy thử script (terminal Bob)
```bash
/shared_data/bob/fun
cat /shared_data/bob/leaked_accounting.txt
```
Kết quả mong đợi: cp báo lỗi Permission denied khi đọc accounting.txt (vì Bob không có quyền đọc), nên leaked_accounting.txt không được tạo ra, hoặc được tạo nhưng rỗng/lỗi. Bob không thu được thông tin gì thêm.

```bash
ls -la /shared_data/bob/leaked_accounting.txt
```
Bước 4: Alice chạy script (terminal Alice)
```bash
/shared_data/bob/fun
```
Vì Alice có quyền đọc accounting.txt (đã cấu hình ở các nhiệm vụ trước / có sẵn trong ACL ban đầu), lệnh cp chạy dưới quyền Alice sẽ thành công.

Terminal Bob – kiểm tra kết quả:
```bash
cat /shared_data/bob/leaked_accounting.txt
```
Kết quả mong đợi: Bob đọc được nội dung accounting.txt, dù chính Bob chưa từng và vẫn không có quyền đọc trực tiếp tệp gốc:

```bash
cat /shared_data/accounting.txt   # vẫn bị Permission denied
```
