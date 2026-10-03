import 'package:flutter/foundation.dart';

enum ProfileAvatar { spark, sun, moon, leaf }

/// Placement hint only. Never a permanent difficulty assignment or exact DOB.
@immutable
class ChildDraft {
  const ChildDraft({
    required this.displayName,
    required this.startingAge,
    required this.avatar,
    required this.language,
  });
  final String displayName;
  final int startingAge;
  final ProfileAvatar avatar;
  final String language;

  ChildDraft validated() {
    final name = displayName.trim();
    if (name.isEmpty ||
        name.runes.length > 40 ||
        RegExp(r'[\x00-\x1F\x7F]').hasMatch(name)) {
      throw const ProfileValidationException();
    }
    if (startingAge < 5 ||
        startingAge > 9 ||
        !['en', 'ms'].contains(language)) {
      throw const ProfileValidationException();
    }
    return ChildDraft(
      displayName: name,
      startingAge: startingAge,
      avatar: avatar,
      language: language,
    );
  }
}

@immutable
class ParentProfile {
  const ParentProfile({
    required this.id,
    required this.displayName,
    required this.createdAt,
    required this.updatedAt,
  });
  final String id;
  final String? displayName;
  final DateTime createdAt;
  final DateTime updatedAt;
}

@immutable
class ChildProfile {
  const ChildProfile({
    required this.id,
    required this.parentId,
    required this.displayName,
    required this.startingAge,
    required this.avatar,
    required this.language,
    required this.createdAt,
    required this.updatedAt,
  });
  final String id;
  final String parentId;
  final String displayName;
  final int startingAge;
  final ProfileAvatar avatar;
  final String language;
  final DateTime createdAt;
  final DateTime updatedAt;
  ChildDraft get draft => ChildDraft(
    displayName: displayName,
    startingAge: startingAge,
    avatar: avatar,
    language: language,
  );
}

@immutable
class ProfileSnapshot {
  ProfileSnapshot({
    required this.onboardingComplete,
    required this.parent,
    required List<ChildProfile> children,
  }) : children = List.unmodifiable(children);
  final bool onboardingComplete;
  final ParentProfile? parent;
  final List<ChildProfile> children;
  ChildProfile? child(String id) {
    for (final child in children) {
      if (child.id == id) return child;
    }
    return null;
  }
}

class ProfileValidationException implements Exception {
  const ProfileValidationException();
}

class ProfileMissingException implements Exception {
  const ProfileMissingException();
}

class ProfileDataException implements Exception {
  const ProfileDataException();
}

abstract interface class ChildProfileRepository {
  Future<ChildProfile> createChild(ChildDraft draft);
  Future<ChildProfile> updateChild(String id, ChildDraft draft);
  Future<void> deleteChild(String id);
}

/// Aggregate boundary keeps initial parent + first child + completion atomic.
abstract interface class ProfileRepository implements ChildProfileRepository {
  Future<ProfileSnapshot> load();
  Future<void> completeSetup(String parentName, ChildDraft firstChild);
  Future<void> reset();
}
