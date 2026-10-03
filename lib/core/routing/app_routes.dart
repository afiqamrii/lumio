/// Stable route identifiers. Call goNamed/pushNamed with these names.
class LumioRoute {
  const LumioRoute(this.path, this.name);
  final String path;
  final String name;
}

abstract final class AppRoutes {
  static const bootstrap = LumioRoute('/', 'bootstrap');
  static const entry = LumioRoute('/entry', 'entry');
  static const onboarding = LumioRoute('/onboarding', 'onboarding');
  static const selectChild = LumioRoute('/select-child', 'selectChild');
  static const newChild = LumioRoute('/parent/children/new', 'newChild');
  static const editChild = LumioRoute(
    '/parent/children/:childId/edit',
    'editChild',
  );
  static const childUnavailable = LumioRoute(
    '/child-unavailable',
    'childUnavailable',
  );
  static const welcome = LumioRoute('/welcome', 'welcome');
  static const lost = LumioRoute('/lost', 'lost');
  static const development = LumioRoute('/dev', 'development');
  static const designSystem = LumioRoute('/dev/design-system', 'designSystem');
  static const learningContent = LumioRoute(
    '/dev/learning-content',
    'learningContent',
  );
  static const parent = LumioRoute('/parent', 'parent');
  static const parentHome = LumioRoute('/parent/home', 'parentHome');
  static const parentChildren = LumioRoute(
    '/parent/children',
    'parentChildren',
  );
  static const parentProgress = LumioRoute(
    '/parent/progress',
    'parentProgress',
  );
  static const parentSettings = LumioRoute(
    '/parent/settings',
    'parentSettings',
  );
  static const childIdParameter = 'childId';
  static const child = LumioRoute('/child/:childId', 'child');
  static const childHome = LumioRoute('/child/:childId/home', 'childHome');
  static const childAdventure = LumioRoute(
    '/child/:childId/adventure',
    'childAdventure',
  );
  // Compatibility alias for Phase 2/3 callers. New UI copy says Adventure.
  static const childWorlds = childAdventure;
  static const childWorldsLegacy = LumioRoute(
    '/child/:childId/worlds',
    'childWorldsLegacy',
  );
  static const childRewards = LumioRoute(
    '/child/:childId/rewards',
    'childRewards',
  );
  static const worldIdParameter = 'worldId';
  static const worldLanding = LumioRoute(
    '/child/:childId/adventure/:worldId',
    'worldLanding',
  );

  // Structural validation only. This does not authorize or load a child.
  static bool isValidChildId(String value) =>
      RegExp(r'^[A-Za-z0-9][A-Za-z0-9_-]{0,127}$').hasMatch(value);

  static Map<String, String> childParameters(String childId) {
    if (!isValidChildId(childId)) {
      throw ArgumentError.value(childId, 'childId', 'Invalid route identifier');
    }
    return {childIdParameter: childId};
  }
}

enum ParentSection {
  home(AppRoutes.parentHome),
  children(AppRoutes.parentChildren),
  progress(AppRoutes.parentProgress),
  settings(AppRoutes.parentSettings);

  const ParentSection(this.route);
  final LumioRoute route;

  static ParentSection forPath(String path) => values.firstWhere(
    (section) => section.route.path == path,
    orElse: () => home,
  );
}

enum ChildSection {
  home(AppRoutes.childHome),
  worlds(AppRoutes.childAdventure),
  rewards(AppRoutes.childRewards);

  const ChildSection(this.route);
  final LumioRoute route;

  static ChildSection forPath(String path) {
    final segments = Uri.parse(path).pathSegments;
    if (segments.contains('adventure') || segments.contains('worlds')) {
      return worlds;
    }
    if (segments.contains('rewards')) return rewards;
    return home;
  }
}
