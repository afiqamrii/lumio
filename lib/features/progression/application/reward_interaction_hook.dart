enum RewardInteractionEvent {
  starEarned,
  coinEarned,
  xpProgress,
  levelUp,
  achievementUnlocked,
}

typedef RewardInteractionHook =
    void Function(RewardInteractionEvent event, int amount);

void noRewardInteraction(RewardInteractionEvent event, int amount) {}
