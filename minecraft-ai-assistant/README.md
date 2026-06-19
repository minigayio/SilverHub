# AI Assistant Mod (Fabric)

Mod Minecraft đơn giản thêm lệnh `/aiask` để hỏi trợ lý AI trong game.

## Tính năng
- `/aiask <câu_hỏi>`: trả lời theo ngữ cảnh gameplay (crafting, sinh tồn, đào mỏ...)
- `/aitips`: mẹo nhanh cho người mới

## Cài đặt nhanh
1. Cài Java 17
2. Cài Fabric Loader cho đúng phiên bản Minecraft
3. Build mod:
   ```bash
   ./gradlew build
   ```
4. Copy file jar trong `build/libs` vào thư mục `mods`

## Ghi chú
- Đây là phiên bản offline rule-based (không gọi API ngoài).
- Bạn có thể mở rộng `AssistantBrain` để gọi OpenAI API hoặc server riêng.
