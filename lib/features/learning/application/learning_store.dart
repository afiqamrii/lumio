import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local_learning_content_repository.dart';
import '../domain/learning_content_repository.dart';
import '../domain/learning_models.dart';

final learningContentRepositoryProvider = Provider<LearningContentRepository>((
  ref,
) {
  return LocalLearningContentRepository();
});

final learningCatalogProvider = FutureProvider<LearningCatalog>((ref) {
  return ref.watch(learningContentRepositoryProvider).loadCatalog();
});
