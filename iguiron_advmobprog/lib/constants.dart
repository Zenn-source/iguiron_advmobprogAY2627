import 'package:flutter_dotenv/flutter_dotenv.dart';

var host = dotenv.env['HOST'];

// enhancement 3: id of the signed-in user, set from SplashScreen/SignInScreen
// once UserService resolves the session, so cart_screen and detail_screen can
// always operate on whoever is currently logged in instead of a fixed id.
int currentUserId = 1;
