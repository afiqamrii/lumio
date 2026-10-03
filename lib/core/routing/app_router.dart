import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/adventure/presentation/adventure_map_screen.dart';
import '../../features/adventure/presentation/world_landing_screen.dart';
import '../../features/child_home/presentation/child_home_screen.dart';
import '../../features/child_home/presentation/child_rewards_screen.dart';
import '../../features/child_shell/presentation/child_shell.dart';
import '../../features/dev/presentation/design_system_showcase.dart';
import '../../features/dev/presentation/development_entry_screen.dart';
import '../../features/foundation/presentation/foundation_screen.dart';
import '../../features/learning/presentation/learning_content_browser_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/parent_shell/presentation/parent_shell.dart';
import '../../features/profiles/application/profile_store.dart';
import '../../features/profiles/domain/profiles.dart';
import '../../features/profiles/presentation/child_editor_screen.dart';
import '../../features/profiles/presentation/child_unavailable_screen.dart';
import '../../features/profiles/presentation/children_screen.dart';
import '../../features/profiles/presentation/parent_profile_screens.dart';
import '../../features/profiles/presentation/profile_entry_screen.dart';
import '../../features/route_error/presentation/route_error_screen.dart';
import '../../features/startup/presentation/bootstrap_screen.dart';
import '../../services/app_logger.dart';
import '../config/app_config.dart';
import 'app_routes.dart';
import 'lumio_route_page.dart';

export 'app_routes.dart';

final appRouterProvider = Provider.autoDispose.family<GoRouter, AppConfig>((
  ref,
  config,
) {
  final refresh = _RouterRefresh();
  ref.listen(profileStoreProvider, (_, next) {
    if (next.hasError) {
      const DebugAppLogger().error(
        'profile_load_failed',
        next.error!,
        next.stackTrace ?? StackTrace.current,
      );
    }
    refresh.refresh();
  });
  final router = createAppRouter(
    config,
    profiles: () => ref.read(profileStoreProvider),
    refreshListenable: refresh,
  );
  ref.onDispose(refresh.dispose);
  ref.onDispose(router.dispose);
  return router;
});

GoRouter createAppRouter(
  AppConfig config, {
  required AsyncValue<ProfileSnapshot> Function() profiles,
  required Listenable refreshListenable,
}) {
  final startup = config.navigationPreviewEnabled
      ? AppRoutes.development
      : config.designPreviewEnabled
      ? AppRoutes.designSystem
      : AppRoutes.selectChild;

  void returnSafely(BuildContext context) =>
      context.goNamed(AppRoutes.entry.name);
  VoidCallback? exitPreview(BuildContext context) =>
      config.navigationPreviewEnabled
      ? () => context.goNamed(AppRoutes.development.name)
      : null;

  return GoRouter(
    initialLocation: AppRoutes.bootstrap.path,
    refreshListenable: refreshListenable,
    // State/route tracing can be enabled externally during debugging. The
    // existing logger reports fixed events and types without child identifiers.
    redirect: (context, state) {
      final childId = state.pathParameters[AppRoutes.childIdParameter];
      if (childId != null && !AppRoutes.isValidChildId(childId)) {
        return AppRoutes.lost.path;
      }
      final path = state.uri.path;
      final data = profiles();
      final snapshot = data.value;
      if (path == AppRoutes.entry.path && snapshot != null && !data.hasError) {
        if (config.navigationPreviewEnabled || config.designPreviewEnabled) {
          return startup.path;
        }
        return snapshot.onboardingComplete
            ? AppRoutes.selectChild.path
            : AppRoutes.onboarding.path;
      }
      final isBusiness =
          path.startsWith('/parent') ||
          path.startsWith('/child/') ||
          path == AppRoutes.selectChild.path ||
          path == AppRoutes.onboarding.path;
      if (isBusiness) {
        if (data.hasError || snapshot == null) return AppRoutes.entry.path;
        if (!snapshot.onboardingComplete && path != AppRoutes.onboarding.path) {
          return AppRoutes.onboarding.path;
        }
        if (snapshot.onboardingComplete && path == AppRoutes.onboarding.path) {
          return AppRoutes.selectChild.path;
        }
        if (childId != null &&
            snapshot.onboardingComplete &&
            snapshot.child(childId) == null) {
          return AppRoutes.childUnavailable.path;
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.entry.path,
        name: AppRoutes.entry.name,
        builder: (_, _) => const ProfileEntryScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding.path,
        name: AppRoutes.onboarding.name,
        pageBuilder: (context, state) => lumioRoutePage(
          context: context,
          state: state,
          child: const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.selectChild.path,
        name: AppRoutes.selectChild.name,
        pageBuilder: (context, state) => lumioRoutePage(
          context: context,
          state: state,
          child: const ChildrenScreen(selector: true),
        ),
      ),
      GoRoute(
        path: AppRoutes.childUnavailable.path,
        name: AppRoutes.childUnavailable.name,
        builder: (_, _) => const ChildUnavailableScreen(),
      ),
      GoRoute(
        path: AppRoutes.newChild.path,
        name: AppRoutes.newChild.name,
        pageBuilder: (context, state) => lumioRoutePage(
          context: context,
          state: state,
          motion: LumioRouteMotion.parent,
          child: const ChildEditorScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.editChild.path,
        name: AppRoutes.editChild.name,
        pageBuilder: (context, state) => lumioRoutePage(
          context: context,
          state: state,
          motion: LumioRouteMotion.parent,
          child: ChildEditorScreen(
            key: ValueKey(state.pathParameters[AppRoutes.childIdParameter]),
            childId: state.pathParameters[AppRoutes.childIdParameter],
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.bootstrap.path,
        name: AppRoutes.bootstrap.name,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: BootstrapScreen(
            onReady: () {
              if (context.mounted) returnSafely(context);
            },
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.welcome.path,
        name: AppRoutes.welcome.name,
        pageBuilder: (context, state) => lumioRoutePage(
          context: context,
          state: state,
          child: const FoundationScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.lost.path,
        name: AppRoutes.lost.name,
        pageBuilder: (context, state) => lumioRoutePage(
          context: context,
          state: state,
          child: RouteErrorScreen(onReturn: () => returnSafely(context)),
        ),
      ),
      if (config.navigationPreviewEnabled)
        GoRoute(
          path: AppRoutes.development.path,
          name: AppRoutes.development.name,
          pageBuilder: (context, state) => lumioRoutePage(
            context: context,
            state: state,
            child: DevelopmentEntryScreen(
              showDesignSystem: config.designPreviewEnabled,
            ),
          ),
        ),
      if (config.designPreviewEnabled)
        GoRoute(
          path: AppRoutes.designSystem.path,
          name: AppRoutes.designSystem.name,
          pageBuilder: (context, state) => lumioRoutePage(
            context: context,
            state: state,
            child: DesignSystemShowcase(
              onBack: () => context.goNamed(
                config.navigationPreviewEnabled
                    ? AppRoutes.development.name
                    : AppRoutes.welcome.name,
              ),
            ),
          ),
        ),
      if (config.debugToolsEnabled)
        GoRoute(
          path: AppRoutes.learningContent.path,
          name: AppRoutes.learningContent.name,
          pageBuilder: (context, state) => lumioRoutePage(
            context: context,
            state: state,
            child: const LearningContentBrowserScreen(),
          ),
        ),
      ShellRoute(
        builder: (context, state, child) => ParentShell(
          section: ParentSection.forPath(state.uri.path),
          onExitPreview: exitPreview(context),
          child: child,
        ),
        routes: [
          GoRoute(
            path: AppRoutes.parent.path,
            name: AppRoutes.parent.name,
            redirect: (context, state) => AppRoutes.parentHome.path,
          ),
          for (final section in ParentSection.values)
            GoRoute(
              path: section.route.path,
              name: section.route.name,
              pageBuilder: (context, state) => lumioRoutePage(
                context: context,
                state: state,
                motion: LumioRouteMotion.parent,
                child: switch (section) {
                  ParentSection.home => const ParentHomeScreen(),
                  ParentSection.children => const ChildrenScreen(),
                  ParentSection.settings => ParentSettingsScreen(
                    debugTools: config.debugToolsEnabled,
                  ),
                  ParentSection.progress => ParentPlaceholderScreen(
                    section: section,
                  ),
                },
              ),
            ),
        ],
      ),
      ShellRoute(
        builder: (context, state, child) => ChildShell(
          childId: state.pathParameters[AppRoutes.childIdParameter]!,
          section: ChildSection.forPath(state.uri.path),
          currentPath: state.uri.path,
          onExitPreview: () => context.goNamed(AppRoutes.selectChild.name),
          child: child,
        ),
        routes: [
          GoRoute(
            path: AppRoutes.child.path,
            name: AppRoutes.child.name,
            redirect: (context, state) => context.namedLocation(
              AppRoutes.childHome.name,
              pathParameters: AppRoutes.childParameters(
                state.pathParameters[AppRoutes.childIdParameter]!,
              ),
            ),
          ),
          GoRoute(
            path: AppRoutes.childWorldsLegacy.path,
            name: AppRoutes.childWorldsLegacy.name,
            redirect: (context, state) => context.namedLocation(
              AppRoutes.childAdventure.name,
              pathParameters: AppRoutes.childParameters(
                state.pathParameters[AppRoutes.childIdParameter]!,
              ),
            ),
          ),
          for (final section in ChildSection.values)
            GoRoute(
              path: section.route.path,
              name: section.route.name,
              pageBuilder: (context, state) => lumioRoutePage(
                context: context,
                state: state,
                motion: LumioRouteMotion.child,
                child: switch (section) {
                  ChildSection.home => ChildHomeScreen(
                    childId: state.pathParameters[AppRoutes.childIdParameter]!,
                  ),
                  ChildSection.worlds => AdventureMapScreen(
                    childId: state.pathParameters[AppRoutes.childIdParameter]!,
                  ),
                  ChildSection.rewards => ChildRewardsScreen(
                    childId: state.pathParameters[AppRoutes.childIdParameter]!,
                    debugTools: config.debugToolsEnabled,
                  ),
                },
              ),
            ),
          GoRoute(
            path: AppRoutes.worldLanding.path,
            name: AppRoutes.worldLanding.name,
            pageBuilder: (context, state) => lumioRoutePage(
              context: context,
              state: state,
              motion: LumioRouteMotion.child,
              child: WorldLandingScreen(
                childId: state.pathParameters[AppRoutes.childIdParameter]!,
                worldId: state.pathParameters[AppRoutes.worldIdParameter]!,
              ),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) {
      const DebugAppLogger().error(
        'route_not_found',
        state.error ?? StateError('Route not found'),
        StackTrace.current,
      );
      return RouteErrorScreen(onReturn: () => returnSafely(context));
    },
  );
}

class _RouterRefresh extends ChangeNotifier {
  void refresh() => notifyListeners();
}
