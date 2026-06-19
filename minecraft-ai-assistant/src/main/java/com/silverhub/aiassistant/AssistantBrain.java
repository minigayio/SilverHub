package com.silverhub.aiassistant;

import java.util.Locale;

public final class AssistantBrain {
    private AssistantBrain() {}

    public static String answer(String question, long timeOfDay) {
        String q = question.toLowerCase(Locale.ROOT);

        if (q.contains("craft") || q.contains("chế") || q.contains("recipe")) {
            return "Bạn có thể dùng JEI/REI để xem recipe nhanh. Ưu tiên craft giáp sắt, khiên và pickaxe trước.";
        }
        if (q.contains("diamond") || q.contains("kim cương") || q.contains("mine")) {
            return "Đào ở tầng Y ~ -58 để kiếm kim cương tốt. Mang nhiều đuốc và food để sống sót lâu hơn.";
        }
        if (q.contains("nether") || q.contains("địa ngục")) {
            return "Đi Nether nhớ mang giáp vàng để piglin không tấn công ngay, và đặt mốc đường quay về portal.";
        }
        if (q.contains("end") || q.contains("rồng")) {
            return "Trước khi đánh Ender Dragon: mang bow, water bucket, block và slow falling potion nếu có.";
        }

        boolean isNight = (timeOfDay % 24000) >= 13000;
        if (isNight) {
            return "Đang ban đêm: ưu tiên ngủ hoặc dựng chỗ trú an toàn, tránh đánh nhau khi thiếu giáp.";
        }
        return "Mẹo chung: hoàn thành food farm sớm, enchant đồ cơ bản và luôn có kế hoạch rút lui khi khám phá.";
    }
}
