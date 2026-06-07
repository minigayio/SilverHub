package com.silverhub.aiassistant;

import com.mojang.brigadier.arguments.StringArgumentType;
import net.fabricmc.api.ModInitializer;
import net.fabricmc.fabric.api.command.v2.CommandRegistrationCallback;
import net.minecraft.server.command.CommandManager;
import net.minecraft.server.network.ServerPlayerEntity;
import net.minecraft.text.Text;

public class AiAssistantMod implements ModInitializer {
    @Override
    public void onInitialize() {
        CommandRegistrationCallback.EVENT.register((dispatcher, registryAccess, environment) -> {
            dispatcher.register(CommandManager.literal("aiask")
                .then(CommandManager.argument("question", StringArgumentType.greedyString())
                    .executes(ctx -> {
                        ServerPlayerEntity player = ctx.getSource().getPlayer();
                        if (player == null) {
                            return 0;
                        }

                        String question = StringArgumentType.getString(ctx, "question");
                        var context = PlayerContextStore.get(player.getUuid());
                        context.setLastQuestion(question);

                        String answer = AssistantBrain.answer(question, context.getGoal(), player.getWorld().getTimeOfDay());
                        ctx.getSource().sendFeedback(() -> Text.literal("§b[AI Assistant] §f" + answer), false);
                        return 1;
                    })));

            dispatcher.register(CommandManager.literal("aisetgoal")
                .then(CommandManager.argument("goal", StringArgumentType.greedyString())
                    .executes(ctx -> {
                        ServerPlayerEntity player = ctx.getSource().getPlayer();
                        if (player == null) {
                            return 0;
                        }

                        String goal = StringArgumentType.getString(ctx, "goal").trim();
                        PlayerContextStore.get(player.getUuid()).setGoal(goal);
                        ctx.getSource().sendFeedback(() -> Text.literal("§b[AI Assistant] §fĐã đặt mục tiêu: " + goal), false);
                        return 1;
                    })));

            dispatcher.register(CommandManager.literal("aiplan")
                .executes(ctx -> {
                    ServerPlayerEntity player = ctx.getSource().getPlayer();
                    if (player == null) {
                        return 0;
                    }

                    String goal = PlayerContextStore.get(player.getUuid()).getGoal();
                    String plan = AssistantBrain.answer("plan", goal, player.getWorld().getTimeOfDay());
                    ctx.getSource().sendFeedback(() -> Text.literal("§b[AI Assistant] §f" + plan), false);
                    return 1;
                }));

            dispatcher.register(CommandManager.literal("aitips")
                .executes(ctx -> {
                    ctx.getSource().sendFeedback(() -> Text.literal("§b[AI Assistant] §fMẹo: mang khiên, đuốc, food, water bucket và đặt bed làm mốc hồi sinh."), false);
                    return 1;
                }));
        });
    }
}
