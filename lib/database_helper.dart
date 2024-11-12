import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    print('Initializing the database...');
    _database = await _initDB('quizapp.db');
    return _database!;
  }

  Future<Database> _initDB(String dbName) async {
    print('Getting database path...');
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    print('Database path: $path');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    print('Creating the database tables...');
    await db.execute('''
    CREATE TABLE Questions(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      questionText TEXT,
      options TEXT,
      answerIndex INTEGER
    );
    ''');

    // Insert sample data (in case the app needs initial data)
    await _populateDatabase(db);
  }

  Future _populateDatabase(Database db) async {
    print('Populating the database with sample data...');

    // List of 50 questions about Flutter with options
    final flutterQuestions = [
      {
        'questionText': 'What is Flutter?',
        'options': 'A programming language,A UI framework,A database,An IDE',
        'answerIndex': 1,
      },
      {
        'questionText': 'Which language is used to develop Flutter apps?',
        'options': 'Java,Kotlin,Dart,Swift',
        'answerIndex': 2,
      },
      {
        'questionText': 'What is the default widget for the Flutter app?',
        'options': 'MaterialApp,CuppertinoApp,StatelessWidget,StatefulWidget',
        'answerIndex': 0,
      },
      {
        'questionText': 'Which company developed Flutter?',
        'options': 'Facebook,Google,Microsoft,Apple',
        'answerIndex': 1,
      },
      {
        'questionText':
            'Which of the following is not a widget type in Flutter?',
        'options':
            'StatelessWidget,StatefulWidget,ContainerWidget,InheritedWidget',
        'answerIndex': 2,
      },
      {
        'questionText': 'Which Flutter widget is used to create an app bar?',
        'options': 'AppBar,Toolbar,NavBar,Header',
        'answerIndex': 0,
      },
      {
        'questionText': 'Which widget is used to display text in Flutter?',
        'options': 'TextField,Text,Label,Container',
        'answerIndex': 1,
      },
      {
        'questionText': 'What is the method to run a Flutter app?',
        'options': 'startApp(),runApp(),launchApp(),startFlutter()',
        'answerIndex': 1,
      },
      {
        'questionText':
            'Which of the following widgets is used for layout in Flutter?',
        'options': 'Row,Column,Stack,All of the above',
        'answerIndex': 3,
      },
      {
        'questionText':
            'Which of the following is used for navigation in Flutter?',
        'options': 'Navigator,Routing,PageRoute,All of the above',
        'answerIndex': 0,
      },
      {
        'questionText':
            'What is the default layout direction for Flutter’s Row widget?',
        'options': 'Vertical,Horizontal,Flex,Grid',
        'answerIndex': 1,
      },
      {
        'questionText':
            'Which of the following is true about Flutter’s StatelessWidget?',
        'options':
            'It has mutable state,It has immutable state,It has a build method,It has an initState method',
        'answerIndex': 1,
      },
      {
        'questionText':
            'What is the primary purpose of Flutter’s StatefulWidget?',
        'options':
            'To hold static data,To manage state,To handle user input,To define the structure',
        'answerIndex': 1,
      },
      {
        'questionText':
            'Which widget can be used to create a button in Flutter?',
        'options': 'FlatButton,ElevatedButton,TextButton,All of the above',
        'answerIndex': 3,
      },
      {
        'questionText': 'What is the use of Flutter’s pubspec.yaml file?',
        'options':
            'To configure app settings,To manage dependencies,To configure widgets,To manage assets',
        'answerIndex': 1,
      },
      {
        'questionText': 'What is Flutter’s hot reload feature?',
        'options':
            'It reloads the app from scratch,It reloads changes instantly,It restarts the app,It refreshes the code',
        'answerIndex': 1,
      },
      {
        'questionText': 'What is the default font family in Flutter?',
        'options': 'Roboto,Arial,Times New Roman,Verdana',
        'answerIndex': 0,
      },
      {
        'questionText':
            'Which package is used for adding animations in Flutter?',
        'options':
            'flutter_animations,flutter_lottie,flutter_animation,flutter_splash',
        'answerIndex': 0,
      },
      {
        'questionText': 'What is the name of Flutter’s rendering engine?',
        'options': 'Skia,OpenGL,DirectX,Metal',
        'answerIndex': 0,
      },
      {
        'questionText':
            'Which widget is used to create a scrollable list in Flutter?',
        'options': 'ListView,GridView,Column,Row',
        'answerIndex': 0,
      },
      {
        'questionText':
            'Which method is used to get the screen size in Flutter?',
        'options':
            'MediaQuery.of(context).size,ScreenSize.of(context).size,SizeWidget.of(context),Size.context()',
        'answerIndex': 0,
      },
      {
        'questionText':
            'Which widget is used to align child widgets in Flutter?',
        'options': 'Align,Center,Padding,Container',
        'answerIndex': 0,
      },
      {
        'questionText': 'What does the Flutter “pub” command do?',
        'options':
            'Builds the app,Installs packages,Updates packages,All of the above',
        'answerIndex': 1,
      },
      {
        'questionText':
            'Which method is used to display an alert dialog in Flutter?',
        'options': 'showDialog(),alertDialog(),showAlert(),showToast()',
        'answerIndex': 0,
      },
      {
        'questionText': 'What is the name of the Flutter’s testing framework?',
        'options': 'flutter_test,flutter_tester,flutter_mock,flutter_jest',
        'answerIndex': 0,
      },
      {
        'questionText':
            'Which of the following widgets is used to display an image in Flutter?',
        'options': 'ImageContainer,ImageView,Image,Picture',
        'answerIndex': 2,
      },
      {
        'questionText':
            'Which widget is used to create a drawer menu in Flutter?',
        'options': 'Drawer,Menu,Sidebar,NavigationDrawer',
        'answerIndex': 0,
      },
      {
        'questionText':
            'Which package is used for state management in Flutter?',
        'options': 'provider,flutter_state,flutter_bloc,riverpod',
        'answerIndex': 0,
      },
      {
        'questionText': 'What is the name of Flutter’s official IDE?',
        'options': 'Android Studio,Visual Studio Code,Xcode,Flutter IDE',
        'answerIndex': 0,
      },
      {
        'questionText':
            'Which method is used to initialize the state of a widget in Flutter?',
        'options': 'initState(),startState(),onInit(),initializeState()',
        'answerIndex': 0,
      },
      {
        'questionText': 'Which widget is used to create a form in Flutter?',
        'options': 'Form,FormField,Input,TextField',
        'answerIndex': 0,
      },
      {
        'questionText':
            'Which of the following is used for navigation between screens in Flutter?',
        'options': 'Navigator,Routes,PageController,PageRoute',
        'answerIndex': 0,
      },
      {
        'questionText': 'What does the "hot reload" feature in Flutter do?',
        'options':
            'Restarts the app,Changes widgets instantly,Shows logs instantly,Removes UI bugs',
        'answerIndex': 1,
      },
      {
        'questionText':
            'Which of the following is a correct way to declare a variable in Dart?',
        'options': 'var x = 10,int x = 10,x int = 10,double x = 10',
        'answerIndex': 0,
      },
      {
        'questionText':
            'What is the name of the primary widget class in Flutter?',
        'options': 'Widget,Element,StatefulWidget,StatelessWidget',
        'answerIndex': 3,
      },
      {
        'questionText':
            'What is the default font size in Flutter’s Text widget?',
        'options': '14,16,18,12',
        'answerIndex': 1,
      },
      {
        'questionText':
            'Which of the following is used for animation in Flutter?',
        'options':
            'AnimatedContainer,AnimationController,AnimatedWidget,All of the above',
        'answerIndex': 3,
      },
      {
        'questionText':
            'What type of layout is used in Flutter for scrolling content?',
        'options': 'Scrollable,ScrollableList,Column,Container',
        'answerIndex': 0,
      },
      {
        'questionText':
            'Which Flutter widget is used to display a list of items?',
        'options': 'ListView,GridView,Column,Container',
        'answerIndex': 0,
      },
      {
        'questionText':
            'What is the default text alignment for a Text widget in Flutter?',
        'options': 'Center,Left,Right,Justify',
        'answerIndex': 1,
      },
      {
        'questionText':
            'Which method in Flutter is used to make network requests?',
        'options': 'http.get(),urlRequest(),networkRequest(),fetch()',
        'answerIndex': 0,
      },
      {
        'questionText':
            'Which widget is used to create a loading indicator in Flutter?',
        'options':
            'CircularProgressIndicator,LinearProgressIndicator,ProgressBar,LoadingWidget',
        'answerIndex': 0,
      },
      {
        'questionText':
            'What type of widget is used for applying padding in Flutter?',
        'options': 'Padding,EdgeInsets,Container,Align',
        'answerIndex': 0,
      },
      {
        'questionText':
            'Which widget is used to handle gestures like tapping in Flutter?',
        'options': 'GestureDetector,TapDetector,Clickable,TouchDetector',
        'answerIndex': 0,
      },
      {
        'questionText': 'Which function is used to run a Flutter application?',
        'options': 'runApp(),startApp(),initializeApp(),openApp()',
        'answerIndex': 0,
      },
      {
        'questionText':
            'Which of the following is a framework for building UI in Flutter?',
        'options': 'Material,Cupertino,Both,Neither',
        'answerIndex': 2,
      },
      {
        'questionText': 'Which widget is used to display an icon in Flutter?',
        'options': 'Icon,Image,Button,Picture',
        'answerIndex': 0,
      },
      {
        'questionText':
            'Which package is used to make HTTP requests in Flutter?',
        'options': 'http,dio,flutter_http,http_request',
        'answerIndex': 0,
      },
      {
        'questionText': 'What is the purpose of Flutter’s `pubspec.yaml` file?',
        'options':
            'Manage dependencies,Configure app theme,Set environment variables,Configure widgets',
        'answerIndex': 0,
      },
      {
        'questionText':
            'What widget would you use to create a circular progress indicator?',
        'options':
            'CircularProgressIndicator,LinearProgressIndicator,ProgressBar,LoadingCircle',
        'answerIndex': 0,
      },
    ];

    // Insert each question into the database
    for (var question in flutterQuestions) {
      await db.insert('Questions', question);
    }

    print('Inserted 50 questions with options.');
  }

  Future<List<Map<String, dynamic>>> fetchQuestions(
      int batchSize, int currentQuestionIndex) async {
    final db = await database;
    final questions = await db.query('Questions');
    print('Fetched questions: $questions');
    return questions;
  }
}
