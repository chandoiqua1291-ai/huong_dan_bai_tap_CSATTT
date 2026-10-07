Giới thiệu về quản lý người dùng, nhóm và quyền đối với tệp trên hệ thống Unix


1. Mục đích:

Giúp sinh viên hiểu về cách quản lý người dùng và nhóm trên hệ thống Unix thông qua thực hiện các câu lệnh.
2. Yêu cầu đối với sinh viên:

Có kiến thức cơ bản về hệ điều hành CentOS, cách quản lý người dùng, nhóm, quyền đối với tệp trên Unix.
3. Nội dung thực hành

Khởi động bài lab:
Vào terminal, gõ:
labtainer users

 (chú ý: sinh viên sử dụng <TÊN_TÀI_KHOẢN_HỆ_THỐNG> của mình để nhập thông tin người thực hiện bài lab khi có yêu cầu, để sử dụng khi chấm điểm)

Sau khi khởi động xong hai terminal ảo sẽ xuất hiện Trên màn hình Terminal 1: đăng nhập với tên “admin” và mật khẩu “password123”, sau đó dùng lệnh sudo su để có quyền root.
Nhiệm vụ 1: Thêm người dùng bob

Trên Terminal 1, sử dụng quyền root tạo người dùng “bob” và đặt mật khẩu
useradd -m bob

Tùy chọn -m sẽ tạo một thư mục home cho người dùng tại đường dẫn /home/bob. Đặt mật khẩu cho bob dùng lệnh passwd. Trên Terminal 2, đăng nhập bằng tài khoản “bob”. Sau đó thoát khỏi tài khoản bob bằng lệnh exit.
Nhiệm vụ 2: Thêm người dùng mary

Trên Terminal 1, dùng tài khoản admin, thêm người dùng “mary” giống như cách thêm người dùng bob. Kiểm tra file được chia sẻ:
ls -l /shared_stuff/tarts.txt

Ta thấy rằng file này được chia sẻ cho nhóm “bakers” có quyền đọc, ghi và có người sở hữu “frank”. Quyền truy cập tệp trên Unix có thể tham khảo tại đây: https://mason.gmu.edu/~montecin/UNIXpermiss.htm. Đối với tập tin này, chủ sở hữu và các thành viên của nhóm có quyền đọc và ghi. Người dùng khác ngoài chủ sở hữu hoặc thành viên của nhóm không có quyền truy cập vào tập tin này. Chủ sở hữu là Frank và nhóm là bakers. Các quyền chỉ ra rằng chỉ các thành viên của nhóm bakers mới có thể đọc hoặc ghi vào tập tin.

Muốn “mary” có thể truy cập tệp này vì cô ấy là một thợ làm bánh, cần thêm “mary” vào nhóm thợ làm bánh. Điều này được thực hiện với câu lệnh sau:
usermod -a -G bakers mary

Dùng Terminal 2 để đăng nhập vào tài khoản mary. Sử dụng “id” để kiểm tra nhóm của “mary” là “bakers” sau đó kiểm tra “mary” có thể xem file tart.txt và chạy được chương trình eggcheck.
id mary

cat /shared_stuff/tarts.txt

eggcheck tarts.txt

“mary” được cấp quyền để chạy chương trình eggcheck. Sử dụng lệnh id lần nữa. Lưu ý người dùng là mary và nhóm là mary. Ta thấy, mary là thành viên của cả nhóm mary và nhóm thợ làm bánh. Sử dụng lệnh sau để tạo một tệp mới:
touch newfile.txt

Sử dụng ls -l để xem quyền sở hữu của tập tin. Sau đó thay đổi nhóm hiện tại của “mary” bằng cách sử dụng:
newgrp bakers

Sử dụng lại ls -l. Nhiều thứ có thể ảnh hưởng đến quyền của một tệp, bao gồm nhóm người dùng hiện tại đang tạo tệp. Thoát khỏi tài khoản “mary” bằng lệnh exit.
Nhiệm vụ 3: Đọc tệp với bob

Đăng nhập vào bob và xem file tarts.txt, do “bob” không thuộc nhóm “baker” nên không thể xem được file này
cat /shared_stuff/tarts.txt

Đăng nhập lại vào tài khoản “mary” chạy chương trình eggcheck. Chương trình này tạo một bản sao tạm thời của tệp mà nó đọc và đặt bản sao đó vào /tmp/tmpfile.txt. Đăng nhập lại vào tài khoản “bob” và cố gắng đọc file này, sau đó đưa ra nhận xét?
Nhiệm vụ 4: Leo thang đặc quyền người dùng

Tạo người dùng tên “lisa”, lisa là phụ tá cho người quản trị nên cần đặc quyền gọi là “Superuser do”. Phải thêm “lisa” vào nhóm “admin”
sudo usermod –a –G admin lisa

Sau đó đăng nhập vào “lisa” và xóa người dùng “bob”:
sudo userdel bob

Kết thúc bài lab:
Trên terminal đầu tiên sử dụng câu lênh sau để kết thúc bài lab:
stoplab users

Khi bài lab kết thúc, một tệp zip lưu kết quả được tạo và lưu vào một vị trí được hiển thị bên dưới stoplab.
Khởi động lại bài lab:
Trong quá trình làm bài sinh viên cần thực hiện lại bài lab, dùng câu lệnh:
labtainer -r users
