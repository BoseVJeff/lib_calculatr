import '../utils/linked_list.dart';
import 'num.dart';

abstract class AstTerm extends LinkedListTerm<AstTerm> {
  AstTerm({
    super.prevTerm,
    super.nextTerm,
  });

  num solve();

  /// This function must resolve the chain at the end of the computation and return a ref to the new term, if the exisiting one has been replaced. Return itself if that is not the case.
  AstTermNum resolve();
}
