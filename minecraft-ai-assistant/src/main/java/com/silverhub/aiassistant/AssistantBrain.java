package com.silverhub.aiassistant;

import java.util.Locale;

public final class AssistantBrain {
    private AssistantBrain() {}

    public static String answer(String question, String goal, long timeOfDay) {
        String q = question.toLowerCase(Locale.ROOT);
        String g = goal.toLowerCase(Locale.ROOT);

        if (q.contains("plan") || q.contains("lộ trình") || q.contains("tiến độ")) {
            return buildGoalPlan(g);
        }
        if (q.contains("craft") || q.contains("chế") || q.contains("recipe")) {
            return "Craft ưu tiên: khiên -> giáp sắt -> pickaxe sắt -> bàn phù phép. Dùng JEI/REI để tra recipe nhanh.";
        }
        if (q.contains("diamond") || q.contains("kim cương") || q.contains("mine")) {
            return "Đào branch mine ở Y=-58, đặt đuốc đều, luôn mang water bucket + food + 1 stack block.";
        }
        if (q.contains("nether") || q.contains("địa ngục")) {
            return "Nether checklist: giáp vàng, fire resistance (nếu có), mốc tọa độ portal, cobblestone để đánh dấu đường.";
        }
        if (q.contains("end") || q.contains("rồng")) {
            return "Trước Ender Dragon: bow + 2 stack arrow, water bucket, slow falling potion, phá crystal trước rồi focus dragon.";
        }
        if (q.contains("food") || q.contains("đồ ăn") || q.contains("farm")) {
            return "Làm farm lúa + bò/cừu sớm để ổn định food; ưu tiên nguồn food tái tạo liên tục trước khi đi xa.";
        }

        boolean isNight = (timeOfDay % 24000) >= 13000;
        if (isNight) {
            return "Đang ban đêm: ngủ nếu được. Nếu chưa ngủ được, dựng shelter 3x3 và tránh combat khi chưa đủ giáp.";
        }

        return "Mục tiêu hiện tại của bạn là '" + goal + "'. Gõ '/aiplan' để lấy lộ trình chi tiết theo mục tiêu.";
    }

    private static String buildGoalPlan(String goal) {
        return switch (goal) {
            case "speedrun" -> "Plan speedrun: 1) lấy iron nhanh 2) vào Nether kiếm blaze rod 3) trade ender pearl 4) vào End.";
            case "builder" -> "Plan builder: 1) thiết kế palette block 2) tạo quarry/farm vật liệu 3) xây theo từng module nhỏ.";
            case "pvp" -> "Plan PvP: 1) full iron/diamond 2) enchant Protection + Sharpness 3) luyện bow + shield timing.";
            default -> "Plan survival: 1) ổn định food 2) set base + storage 3) mining + enchant 4) Nether 5) End.";
        };
    }
}
