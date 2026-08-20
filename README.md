# Mackenzie Iguiron
## INF 231
## CTADMOBL Advance Mobile Programming

A new Flutter project that focuses on advanced topics. Covering the mobile to web transactions.

## Lab Activity 2:
In this 2nd activity, my service first fetches the raw data from the API endpoint. My model then converts that raw data into clean Dart objects, which my screen uses to display the information on the UI. This activity introduces the Service Pattern by separating network calls from the user interface logic. Doing this makes my project much cleaner, organized, and easier to understand instead of putting all the code in one file.

## Lab Activity 3: discussion
In this 3rd activity, cart_service.dart follows the same Service Pattern as product_service.dart: it fetches raw cart JSON and converts it into Cart and CartProduct model objects, which cart_screen.dart then displays. Since a cart item only carries a product id and not the full product details, tapping it fetches the full product by id and reuses the same detail_screen.dart already used by product_screen.dart, instead of building a second detail screen. The updated design pattern simply groups files by role (models, services, screens, widgets) so each new resource, like cart, gets its own model and service pair. For getById on the Cart endpoint, GET /carts/{id} looks up one specific cart directly, while GET /carts/user/{userId} is used instead on the cart screen so it can render only the current user's cart.

## Lab Activity 4: discussion
In this 4th activity, user_service.dart saves the logged-in user to SharedPreferences, and profile_screen.dart just asks it for the User model to display, the same pattern the other screens use with their own services. splash_screen.dart checks user_service.dart for a saved session to decide between /signin and /home, and either path sets the current user id in constants.dart. cart_screen.dart then uses that same id to load and show only that user's cart.