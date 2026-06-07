package com.silverhub.aiassistant;

import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

public final class PlayerContextStore {
    private static final Map<UUID, PlayerContext> CONTEXTS = new ConcurrentHashMap<>();

    private PlayerContextStore() {}

    public static PlayerContext get(UUID playerId) {
        return CONTEXTS.computeIfAbsent(playerId, ignored -> new PlayerContext());
    }

    public static final class PlayerContext {
        private String goal = "survival";
        private String lastQuestion = "";

        public String getGoal() {
            return goal;
        }

        public void setGoal(String goal) {
            this.goal = goal == null || goal.isBlank() ? "survival" : goal;
        }

        public String getLastQuestion() {
            return lastQuestion;
        }

        public void setLastQuestion(String lastQuestion) {
            this.lastQuestion = lastQuestion == null ? "" : lastQuestion;
        }
    }
}
