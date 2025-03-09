#!/bin/bash

# Đường dẫn tới file storage.json
FILE_PATH="/Users/nht/Library/Application Support/Cursor/User/globalStorage/storage.json"
APP_UPDATE_PATH="/Applications/Cursor.app/Contents/Resources/app-update.yml"

# Hàm tạo mã UUID ngẫu nhiên
generate_uuid() {
    uuidgen
}

# Hiển thị thông báo nhắc nhở (tô màu)
echo -e "\033[1;33m⚠️  Vui lòng đảm bảo rằng ứng dụng Cursor đã được tắt trước khi tiếp tục!\033[0m"

# Kiểm tra xem Cursor.app có được cài đặt không
if [[ ! -d "/Applications/Cursor.app" ]]; then
    echo -e "\033[1;31mLỗi: Không tìm thấy Cursor.app trong thư mục Applications.\033[0m"
    exit 1
fi

# Kiểm tra folder cursor-updater
UPDATER_PATH="/Users/nht/Library/Application Support/Caches/cursor-updater"
if [[ -d "$UPDATER_PATH" ]]; then
    echo -e "\n\033[1;35m=== KIỂM TRA FOLDER CURSOR-UPDATER ===\033[0m"
    echo -e "\033[1;33mĐã tìm thấy folder cursor-updater tại:\033[0m"
    echo "$UPDATER_PATH"
    
    # Add prompt to open folder
    read -p "Bạn có muốn mở folder cursor-updater không? (Y/N): " open_folder
    if [[ "$open_folder" =~ ^[Yy]$ ]]; then
        open "$UPDATER_PATH"
    fi
    
    read -p "Bạn có muốn xử lý folder này không? (Y/N): " handle_folder
    if [[ "$handle_folder" =~ ^[Yy]$ ]]; then
        echo "1. Xóa folder"
        echo "2. Đổi tên folder"
        read -p "Chọn hành động (1/2): " folder_action
        
        case $folder_action in
            1)
                rm -rf "$UPDATER_PATH"
                echo -e "\033[1;32mĐã xóa folder cursor-updater.\033[0m"
                read -p "Bạn có muốn tạo lại folder cursor-updater trống không? (Y/N): " recreate_response
                if [[ "$recreate_response" =~ ^[Yy]$ ]]; then
                    mkdir -p "$UPDATER_PATH"
                    echo -e "\033[1;32mĐã tạo lại folder cursor-updater trống.\033[0m"
                fi
                ;;
            2)
                read -p "Nhập tên mới (không cần đường dẫn đầy đủ): " new_name
                mv "$UPDATER_PATH" "$(dirname "$UPDATER_PATH")/$new_name"
                echo -e "\033[1;32mĐã đổi tên folder thành: $new_name\033[0m"
                read -p "Bạn có muốn tạo lại folder cursor-updater trống không? (Y/N): " recreate_response
                if [[ "$recreate_response" =~ ^[Yy]$ ]]; then
                    mkdir -p "$UPDATER_PATH"
                    echo -e "\033[1;32mĐã tạo lại folder cursor-updater trống.\033[0m"
                fi
                ;;
            *)
                echo -e "\033[1;33mKhông thực hiện thay đổi với folder.\033[0m"
                ;;
        esac
    fi
else
    echo -e "\n\033[1;35m=== KIỂM TRA FOLDER CURSOR-UPDATER ===\033[0m"
    echo -e "\033[1;33mKhông tìm thấy folder cursor-updater.\033[0m"
    read -p "Bạn có muốn tạo folder cursor-updater không? (Y/N): " create_folder
    if [[ "$create_folder" =~ ^[Yy]$ ]]; then
        mkdir -p "$UPDATER_PATH"
        echo -e "\033[1;32mĐã tạo folder cursor-updater tại: $UPDATER_PATH\033[0m"
    fi
fi

echo -e "\n\033[1;35m=== KIỂM TRA FILE APP-UPDATE.YML ===\033[0m"
# Kiểm tra file app-update.yml
if [[ -f "$APP_UPDATE_PATH" ]]; then
    echo -e "\033[1;32mĐã tìm thấy file app-update.yml tại đường dẫn:\033[0m"
    echo "$APP_UPDATE_PATH"
    
    # Add prompt to open file
    read -p "Bạn có muốn mở file app-update.yml không? (Y/N): " open_yml
    if [[ "$open_yml" =~ ^[Yy]$ ]]; then
        open "$APP_UPDATE_PATH"
    fi
    
    # Kiểm tra nếu file có nội dung
    if [[ -s "$APP_UPDATE_PATH" ]]; then
        echo -e "\033[1;32mNội dung của file app-update.yml:\033[0m"
        while IFS= read -r line; do
            echo -e "\033[1;36m│\033[0m $line"
        done < "$APP_UPDATE_PATH"
        
        # Hỏi người dùng có muốn tạo bản sao backup không
        read -p "Bạn có muốn tạo bản sao backup của file app-update.yml không? (Y/N): " backup_response
        if [[ "$backup_response" =~ ^[Yy]$ ]]; then
            BAK_FILE="${APP_UPDATE_PATH}.bak"
            cp "$APP_UPDATE_PATH" "$BAK_FILE"
            echo -e "\033[1;32mĐã tạo bản sao backup tại: $BAK_FILE\033[0m"
            
            # Hỏi người dùng có muốn xóa và tạo lại file gốc không
            read -p "Bạn có muốn xóa và tạo lại file app-update.yml trống không? (Y/N): " recreate_response
            if [[ "$recreate_response" =~ ^[Yy]$ ]]; then
                rm "$APP_UPDATE_PATH"
                touch "$APP_UPDATE_PATH"
                chmod 444 "$APP_UPDATE_PATH"
                echo -e "\033[1;32mĐã xóa và tạo lại file app-update.yml trống với quyền chỉ đọc.\033[0m"
            fi
        fi
    else
        echo -e "\033[1;33mFile app-update.yml tồn tại nhưng không có nội dung.\033[0m"
        chmod 444 "$APP_UPDATE_PATH"
        echo -e "\033[1;32mĐã thay đổi quyền file app-update.yml thành chỉ đọc.\033[0m"
    fi
else
    echo -e "\033[1;31mKhông tìm thấy file app-update.yml tại đường dẫn:\033[0m"
    echo "$APP_UPDATE_PATH"
    read -p "Bạn vẫn muốn tiếp tục không? (Y/N): " continue_response
    if [[ ! "$continue_response" =~ ^[Yy]$ ]]; then
        echo "Thoát script."
        exit 0
    fi
fi

echo -e "\n\033[1;35m=== KIỂM TRA FILE STORAGE.JSON ===\033[0m"
# Kiểm tra file storage.json
if [[ -f "$FILE_PATH" ]]; then
    echo "Đang đọc nội dung file storage.json..."

    # Lấy giá trị cũ từ file sử dụng sed
    OLD_UUID1=$(sed -n 's/.*"telemetry\.macMachineId": "\(.*\)".*/\1/p' "$FILE_PATH")
    OLD_UUID2=$(sed -n 's/.*"telemetry\.machineId": "\(.*\)".*/\1/p' "$FILE_PATH")
    OLD_UUID3=$(sed -n 's/.*"telemetry\.devDeviceId": "\(.*\)".*/\1/p' "$FILE_PATH")
    OLD_UUID4=$(sed -n 's/.*"telemetry\.sqmId": "\(.*\)".*/\1/p' "$FILE_PATH")

    echo "Mã cũ:"
    echo -e "  \033[1;34mtelemetry.macMachineId:\033[0m ${OLD_UUID1:-Không tìm thấy}"
    echo -e "  \033[1;34mtelemetry.machineId:\033[0m ${OLD_UUID2:-Không tìm thấy}"
    echo -e "  \033[1;34mtelemetry.devDeviceId:\033[0m ${OLD_UUID3:-Không tìm thấy}"
    echo -e "  \033[1;34mtelemetry.sqmId:\033[0m ${OLD_UUID4:-Không tìm thấy}"

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
    NEW_UUID4=$(generate_uuid)

    # Cập nhật file với mã mới
    sed -i '' -e "s/\"telemetry\.macMachineId\": \".*\"/\"telemetry.macMachineId\": \"$NEW_UUID1\"/" \
              -e "s/\"telemetry\.machineId\": \".*\"/\"telemetry.machineId\": \"$NEW_UUID2\"/" \
              -e "s/\"telemetry\.devDeviceId\": \".*\"/\"telemetry.devDeviceId\": \"$NEW_UUID3\"/" \
              -e "s/\"telemetry\.sqmId\": \".*\"/\"telemetry.sqmId\": \"$NEW_UUID4\"/" \
              "$FILE_PATH"

    echo "Cập nhật thành công!"
    echo -e "Mã mới:"
    echo -e "  \033[1;32mtelemetry.macMachineId:\033[0m $NEW_UUID1"
    echo -e "  \033[1;32mtelemetry.machineId:\033[0m $NEW_UUID2"
    echo -e "  \033[1;32mtelemetry.devDeviceId:\033[0m $NEW_UUID3"
    echo -e "  \033[1;32mtelemetry.sqmId:\033[0m $NEW_UUID4"

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
