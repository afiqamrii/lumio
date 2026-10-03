import 'package:flutter_test/flutter_test.dart';
import 'package:lumio/core/widgets/responsive_content.dart';

void main() {
  test('layout size changes at documented available-width boundaries', () {
    expect(LayoutBreakpoints.sizeFor(599), LayoutSize.compact);
    expect(LayoutBreakpoints.sizeFor(600), LayoutSize.medium);
    expect(LayoutBreakpoints.sizeFor(839), LayoutSize.medium);
    expect(LayoutBreakpoints.sizeFor(840), LayoutSize.expanded);
  });
}
