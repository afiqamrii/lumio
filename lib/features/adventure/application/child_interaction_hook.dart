enum ChildInteractionEvent {
  homeContinue,
  worldTapped,
  worldEntered,
  lockedWorldTapped,
}

typedef ChildInteractionHook =
    void Function(ChildInteractionEvent event, String? worldId);

void noChildInteraction(ChildInteractionEvent event, String? worldId) {}
