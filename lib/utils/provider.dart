import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../state/authentication_provider.dart';


List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
];
