#!/bin/bash

# Đường dẫn tới file storage.json
FILE_PATH="/Users/nht/Library/Application Support/Cursor/User/globalStorage/storage.json"

# Hàm tạo mã UUID ngẫu nhiên
generate_uuid() {
    uuidgen
}

# Hiển thị thông báo nhắc nhở (tô màu)
echo -e "\033[1;33m⚠️  Vui lòng đảm bảo rằng ứng dụng Cursor đã được tắt trước khi tiếp tục!\033[0m"

# Kiểm tra file tồn tại
if [[ -f "$FILE_PATH" ]]; then
    echo "Đang đọc nội dung file storage.json..."

    # Lấy giá trị cũ từ file sử dụng sed
    OLD_UUID1=$(sed -n 's/.*"telemetry\.macMachineId": "\(.*\)".*/\1/p' "$FILE_PATH")
    OLD_UUID2=$(sed -n 's/.*"telemetry\.machineId": "\(.*\)".*/\1/p' "$FILE_PATH")
    OLD_UUID3=$(sed -n 's/.*"telemetry\.devDeviceId": "\(.*\)".*/\1/p' "$FILE_PATH")

    echo "Mã cũ:"
    echo -e "  \033[1;34mtelemetry.macMachineId:\033[0m ${OLD_UUID1:-Không tìm thấy}"
    echo -e "  \033[1;34mtelemetry.machineId:\033[0m ${OLD_UUID2:-Không tìm thấy}"
    echo -e "  \033[1;34mtelemetry.devDeviceId:\033[0m ${OLD_UUID3:-Không tìm thấy}"

    # Hỏi người dùng có muốn cập nhật mã mới không
    read -p "Bạn có muốn cập nhật mã mới không? (Y/N): " update_response
    if [[ ! "$update_response" =~ ^[Yy]$ ]]; then
        echo "Không thực hiện thay đổi. Thoát script."
        exit 0
    fi

    echo "Đang tạo mã UUID mới..."
    # Tạo các mã UUID mới
    NEW_UUID1=$(generate_uuid)
    NEW_UUID2=$(generate_uuid)
    NEW_UUID3=$(generate_uuid)

    # Cập nhật file với mã mới
    sed -i '' -e "s/\"telemetry\.macMachineId\": \".*\"/\"telemetry.macMachineId\": \"$NEW_UUID1\"/" \
              -e "s/\"telemetry\.machineId\": \".*\"/\"telemetry.machineId\": \"$NEW_UUID2\"/" \
              -e "s/\"telemetry\.devDeviceId\": \".*\"/\"telemetry.devDeviceId\": \"$NEW_UUID3\"/" \
              "$FILE_PATH"

    echo "Cập nhật thành công!"
    echo -e "Mã mới:"
    echo -e "  \033[1;32mtelemetry.macMachineId:\033[0m $NEW_UUID1"
    echo -e "  \033[1;32mtelemetry.machineId:\033[0m $NEW_UUID2"
    echo -e "  \033[1;32mtelemetry.devDeviceId:\033[0m $NEW_UUID3"

    # Hỏi người dùng có muốn mở file hay không
    read -p "Bạn có muốn mở file storage.json không? (Y/N): " open_response
    if [[ "$open_response" =~ ^[Yy]$ ]]; then
        open "$FILE_PATH" # Dùng lệnh `open` trên macOS
    else
        echo "Kết thúc script."
    fi
else
    echo "File không tồn tại tại đường dẫn $FILE_PATH"
    exit 1
fi
