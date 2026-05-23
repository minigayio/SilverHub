# AI Assistant Mod (Fabric)

Mod Minecraft thêm trợ lý AI nội bộ bằng lệnh chat, giúp người chơi hỏi nhanh về gameplay.

## Tính năng
- `/aiask <câu_hỏi>`: hỏi mẹo chơi theo ngữ cảnh.
- `/aitips`: mẹo nhanh cho người mới.
- `/aisetgoal <mục_tiêu>`: đặt mục tiêu cá nhân (ví dụ: `survival`, `speedrun`, `builder`, `pvp`).
- `/aiplan`: nhận lộ trình theo mục tiêu đã đặt.

## Ví dụ dùng
- `/aisetgoal speedrun`
- `/aiplan`
- `/aiask nên chuẩn bị gì để vào nether?`

## Cài đặt nhanh
1. Cài Java 17.
2. Cài Fabric Loader đúng bản Minecraft.
3. Build mod:
   ```bash
   ./gradlew build
   ```
4. Copy file `.jar` trong `build/libs` vào thư mục `mods`.

## Ý tưởng mở rộng
- Tích hợp OpenAI API để có trả lời thông minh hơn.
- Lưu lịch sử hội thoại theo người chơi vào file JSON.
- Gợi ý nhiệm vụ hằng ngày theo tiến độ trong world.
- Tạo GUI thay vì chỉ chat command.
