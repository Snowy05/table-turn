import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'appTitle': 'TableTurn',
      'settings': 'Settings',
      'highContrast': 'High Contrast',
      'fontSize': 'Font Size',
      'language': 'Language',
      'english': 'English',
      'spanish': 'Spanish',
      'login': 'Login',
      'signup': 'Sign Up',
      'dashboard': 'Dashboard',
      'profile': 'Profile',
      'bookings': 'Bookings',
      'menu': 'Menu',
      'gameOfWeek': 'Game of the Week',
      'voteGOW': 'Vote Game of the Week',
      'gameOfWeekResult': 'GOW Results',
      'boardgames': 'Board Games',
      'loyalty': 'Loyalty',
      'qr': 'QR Code',
      'findYourGame': 'Find Your Game',
      'logout': 'Logout',
      'save': 'Save',
      'cancel': 'Cancel',
      'email': 'Email',
      'password': 'Password',
      'name': 'Name',
      'welcome': 'Welcome',
      'home': 'Home',
      'open': 'Open',
      'close': 'Close',
      'available': 'Available',
      'notAvailable': 'Not Available',
      'search': 'Search',
      'filter': 'Filter',
      'apply': 'Apply',
      'remove': 'Remove',
      'edit': 'Edit',
      'delete': 'Delete',
      'confirm': 'Confirm',
      'yes': 'Yes',
      'no': 'No',
      'next': 'Next',
      'previous': 'Previous',
      'submit': 'Submit',
      'error': 'Error',
      'success': 'Success',
      'retry': 'Retry',
      'description': 'Description',
      'players': 'Players',
      'playTime': 'Play Time',
      'category': 'Category',
      'tags': 'Tags',
      'price': 'Price',
      'calories': 'Calories',
      'points': 'Points',
      'details': 'Details',
      'walkthrough': 'Walkthrough',
      'instructions': 'Instructions',
      'back': 'Back',
      'ok': 'OK',
      'welcomeBack': 'Welcome Back',
      'forgotPassword': 'Forgot Password?',
      'dontHaveAccount': "Don't have an account?",
      'alreadyHaveAccount': 'Already have an account?',
      'createAccount': 'Create Account',
      'rememberMe': 'Remember Me',
      'logoutConfirm': 'Are you sure you want to logout?',
      'cancelBooking': 'Cancel Booking',
      'confirmBooking': 'Confirm Booking',
      'bookNow': 'Book Now',
      'mybookings': 'My Bookings',
      'noResults': 'No results found',
      'loading': 'Loading...',
      'emptyList': 'Nothing to show',
      'chooseLanguage': 'Choose Language',
      'changeLanguage': 'Change Language',
      'select': 'Select',
      'add': 'Add',
      'removeFromList': 'Remove from list',
      'addToList': 'Add to list',
      'favorite': 'Favorite',
      'favorites': 'Favorites',
      'share': 'Share',
      'copy': 'Copy',
      'copied': 'Copied!',
      'settingsSaved': 'Settings saved',
      'settingsNotSaved': 'Settings not saved',

      // Game/Filter/Tag/Category/Option values
      // Categories
      'strategy': 'Strategy',
      'family': 'Family',
      'party': 'Party',
      'cooperative': 'Cooperative',
      'cardGame': 'Card Game',
      'diceGame': 'Dice Game',
      'thematic': 'Thematic',
      'eurogame': 'Eurogame',
      'ameritrash': 'Ameritrash',
      'wargame': 'Wargame',
      'miniatures': 'Miniatures',
      'rolePlayingGame': 'Role-Playing Game (RPG)',
      'trivia': 'Trivia',
      'tileLaying': 'Tile-Laying',
      'wordGame': 'Word Game',

      // Complexities
      'easy': 'Easy',
      'medium': 'Medium',
      'hard': 'Hard',
      'expert': 'Expert',

      // Play Times
      'under30min': 'Under 30 minutes',
      '30to60min': '30-60 minutes',
      '1to2hours': '1-2 hours',
      'over2hours': 'Over 2 hours',

      // Tags
      'new': 'New',
      'classic': 'Classic',
      'familyFavorite': 'Family Favorite',
      'strategyGame': 'Strategy Game',
      'partyGame': 'Party Game',
      'cooperativeGame': 'Cooperative Game',
      'cardGameTag': 'Card Game',
      'diceGameTag': 'Dice Game',
      'wordGameTag': 'Word Game',
      'drawingGame': 'Drawing Game',
      'forKids': 'For Kids',
      'longHaul': 'Long-Haul',
      'roleplayingGame': 'Roleplaying Game',

      // Availability
      'limitedStock': 'Limited Stock',
      'outOfStock': 'Out of Stock',

      // Booking Status
      'pending': 'Pending',
      'confirmed': 'Confirmed',
      'cancelled': 'Cancelled',

      // Age Groups
      'kids': 'Kids',
      'teens': 'Teens',
      'adults': 'Adults',
      'familyAge': 'Family',

      // Dietary Tags
      'vegan': 'Vegan',
      'vegetarian': 'Vegetarian',
      'glutenFree': 'Gluten-Free',
      'dairyFree': 'Dairy-Free',
      'nutFree': 'Nut-Free',
      'halal': 'Halal',
      'pescatarian': 'Pescatarian',
      'lowCarb': 'Low-Carb',
      'lowFat': 'Low-Fat',
      'lowSugar': 'Low-Sugar',
      'nonAlcoholic': 'Non-Alcoholic',

      // Menu Tags
      'forTheLongHaul': 'For The Long Haul',
      'goesWithEverything': 'Goes With Everything',
      'betterBeforeGame': 'Better Before Game',
      'notJustForKids': 'Not Just For Kids',
      'craft': 'Craft',
      'seasonal': 'Seasonal',
      'lowAbv': 'Low ABV',
      'highAbv': 'High ABV',
      'dessert': 'Dessert',

      // Menu Categories
      'drink': 'Drink',
      'food': 'Food',
      'combo': 'Combo',
      'alcohol': 'Alcohol',
      'cocktail': 'Cocktail',
      'side': 'Side',
      'other': 'Other',
    },
    'es': {
      'voteGOW': 'Votar Juego de la Semana',
      'gameOfWeekResult': 'Resultados Juego de la Semana',
      'boardgames': 'Juegos de Mesa',
      'appTitle': 'TableTurn',
      'settings': 'Configuración',
      'highContrast': 'Alto Contraste',
      'fontSize': 'Tamaño de Fuente',
      'language': 'Idioma',
      'english': 'Inglés',
      'spanish': 'Español',
      'login': 'Iniciar sesión',
      'signup': 'Registrarse',
      'dashboard': 'Panel',
      'profile': 'Perfil',
      'bookings': 'Reservas',
      'menu': 'Menú',
      'gameOfWeek': 'Juego de la Semana',
      'loyalty': 'Fidelidad',
      'qr': 'Código QR',
      'findYourGame': 'Encuentra tu juego',
      'logout': 'Cerrar sesión',
      'save': 'Guardar',
      'cancel': 'Cancelar',
      'email': 'Correo electrónico',
      'password': 'Contraseña',
      'name': 'Nombre',
      'welcome': 'Bienvenido',
      'home': 'Inicio',
      'open': 'Abrir',
      'close': 'Cerrar',
      'available': 'Disponible',
      'notAvailable': 'No disponible',
      'search': 'Buscar',
      'filter': 'Filtrar',
      'apply': 'Aplicar',
      'remove': 'Eliminar',
      'edit': 'Editar',
      'delete': 'Borrar',
      'confirm': 'Confirmar',
      'yes': 'Sí',
      'no': 'No',
      'next': 'Siguiente',
      'previous': 'Anterior',
      'submit': 'Enviar',
      'error': 'Error',
      'success': 'Éxito',
      'retry': 'Reintentar',
      'description': 'Descripción',
      'players': 'Jugadores',
      'playTime': 'Tiempo de juego',
      'category': 'Categoría',
      'tags': 'Etiquetas',
      'price': 'Precio',
      'calories': 'Calorías',
      'points': 'Puntos',
      'details': 'Detalles',
      'walkthrough': 'Guía',
      'instructions': 'Instrucciones',
      'back': 'Atrás',
      'ok': 'OK',
      'welcomeBack': 'Bienvenido de nuevo',
      'forgotPassword': '¿Olvidaste tu contraseña?',
      'dontHaveAccount': '¿No tienes una cuenta?',
      'alreadyHaveAccount': '¿Ya tienes una cuenta?',
      'createAccount': 'Crear cuenta',
      'rememberMe': 'Recuérdame',
      'logoutConfirm': '¿Seguro que quieres cerrar sesión?',
      'cancelBooking': 'Cancelar reserva',
      'confirmBooking': 'Confirmar reserva',
      'bookNow': 'Reservar ahora',
      'mybookings': 'Mis reservas',
      'noResults': 'No se encontraron resultados',
      'loading': 'Cargando...',
      'emptyList': 'Nada para mostrar',
      'chooseLanguage': 'Elige idioma',
      'changeLanguage': 'Cambiar idioma',
      'select': 'Seleccionar',
      'add': 'Agregar',
      'removeFromList': 'Eliminar de la lista',
      'addToList': 'Agregar a la lista',
      'favorite': 'Favorito',
      'favorites': 'Favoritos',
      'share': 'Compartir',
      'copy': 'Copiar',
      'copied': '¡Copiado!',
      'settingsSaved': 'Configuración guardada',
      'settingsNotSaved': 'Configuración no guardada',

      // Game/Filter/Tag/Category/Option values
      // Categories
      'strategy': 'Estrategia',
      'family': 'Familiar',
      'party': 'Fiesta',
      'cooperative': 'Cooperativo',
      'cardGame': 'Juego de cartas',
      'diceGame': 'Juego de dados',
      'thematic': 'Temático',
      'eurogame': 'Eurojuego',
      'ameritrash': 'Ameritrash',
      'wargame': 'Wargame',
      'miniatures': 'Miniaturas',
      'rolePlayingGame': 'Juego de rol',
      'trivia': 'Trivia',
      'tileLaying': 'Colocación de losetas',
      'wordGame': 'Juego de palabras',

      // Complexities
      'easy': 'Fácil',
      'medium': 'Medio',
      'hard': 'Difícil',
      'expert': 'Experto',

      // Play Times
      'under30min': 'Menos de 30 minutos',
      '30to60min': '30-60 minutos',
      '1to2hours': '1-2 horas',
      'over2hours': 'Más de 2 horas',

      // Tags
      'new': 'Nuevo',
      'classic': 'Clásico',
      'familyFavorite': 'Favorito de la familia',
      'strategyGame': 'Juego de estrategia',
      'partyGame': 'Juego de fiesta',
      'cooperativeGame': 'Juego cooperativo',
      'cardGameTag': 'Juego de cartas',
      'diceGameTag': 'Juego de dados',
      'wordGameTag': 'Juego de palabras',
      'drawingGame': 'Juego de dibujo',
      'forKids': 'Para niños',
      'longHaul': 'Larga duración',
      'roleplayingGame': 'Juego de rol',

      // Availability
      'limitedStock': 'Stock limitado',
      'outOfStock': 'Agotado',

      // Booking Status
      'pending': 'Pendiente',
      'confirmed': 'Confirmado',
      'cancelled': 'Cancelado',

      // Age Groups
      'kids': 'Niños',
      'teens': 'Adolescentes',
      'adults': 'Adultos',
      'familyAge': 'Familiar',

      // Dietary Tags
      'vegan': 'Vegano',
      'vegetarian': 'Vegetariano',
      'glutenFree': 'Sin gluten',
      'dairyFree': 'Sin lácteos',
      'nutFree': 'Sin nueces',
      'halal': 'Halal',
      'pescatarian': 'Pescetariano',
      'lowCarb': 'Bajo en carbohidratos',
      'lowFat': 'Bajo en grasa',
      'lowSugar': 'Bajo en azúcar',
      'nonAlcoholic': 'Sin alcohol',

      // Menu Tags
      'forTheLongHaul': 'Para la larga duración',
      'goesWithEverything': 'Va con todo',
      'betterBeforeGame': 'Mejor antes del juego',
      'notJustForKids': 'No solo para niños',
      'craft': 'Artesanal',
      'seasonal': 'De temporada',
      'lowAbv': 'Bajo ABV',
      'highAbv': 'Alto ABV',
      'dessert': 'Postre',

      // Menu Categories
      'drink': 'Bebida',
      'food': 'Comida',
      'combo': 'Combo',
      'alcohol': 'Alcohol',
      'cocktail': 'Cóctel',
      'side': 'Acompañamiento',
      'other': 'Otro',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']![key] ??
        key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
