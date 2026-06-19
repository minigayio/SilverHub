package com.silverhub.aiassistant;

import com.mojang.brigadier.arguments.StringArgumentType;
import net.fabricmc.api.ModInitializer;
import net.fabricmc.fabric.api.command.v2.CommandRegistrationCallback;
import net.minecraft.server.command.CommandManager;
import net.minecraft.server.network.ServerPlayerEntity;
import net.minecraft.text.Text;

public class AiAssistantMod implements ModInitializer {
    public static final String MOD_ID = "aiassistant";

    @Override
    public void onInitialize() {
        CommandRegistrationCallback.EVENT.register((dispatcher, registryAccess, environment) -> {
            dispatcher.register(CommandManager.literal("aiask")
                .then(CommandManager.argument("question", StringArgumentType.greedyString())
                    .executes(ctx -> {
                        ServerPlayerEntity player = ctx.getSource().getPlayer();
                        String question = StringArgumentType.getString(ctx, "question");
                        String answer = AssistantBrain.answer(question, player.getWorld().getTimeOfDay());
                        ctx.getSource().sendFeedback(() -> Text.literal("§b[AI Assistant] §f" + answer), false);
                        return 1;
                    })));

            dispatcher.register(CommandManager.literal("aitips")
                .executes(ctx -> {
                    ctx.getSource().sendFeedback(() -> Text.literal("§b[AI Assistant] §fMẹo: luôn mang khiên, đuốc, thức ăn và water bucket khi đi mine."), false);
                    return 1;
                }));
        });
    }
}
