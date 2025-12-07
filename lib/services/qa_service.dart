import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class QAService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Local knowledge base for offline use
  static final Map<String, List<String>> _knowledgeBase = {
    'astronomy': [
      'Our solar system has 8 planets.',
      'The Sun is a star at the center of our solar system.',
      'Mars is known as the Red Planet.',
      'Jupiter is the largest planet in our solar system.',
      'Earth is the only planet known to support life.',
      'Saturn has rings made of ice particles.',
      'The Moon is Earth\'s only natural satellite.',
      'Asteroids are rocky objects orbiting the Sun.',
      'Comets are icy bodies that release gas when near the Sun.',
      'The Milky Way is our home galaxy.',
    ],
    'biology': [
      'The human body has 206 bones.',
      'DNA carries genetic information.',
      'Mitochondria are the powerhouse of the cell.',
      'Plants produce oxygen through photosynthesis.',
      'The heart pumps blood throughout the body.',
      'Neurons transmit signals in the nervous system.',
      'Enzymes speed up chemical reactions in the body.',
      'Photosynthesis converts sunlight into energy.',
      'Human blood has four main components: plasma, red cells, white cells, and platelets.',
      'The brain is the control center of the body.',
    ],
    'chemistry': [
      'Water is H2O - two hydrogen atoms and one oxygen atom.',
      'The periodic table organizes chemical elements.',
      'Acids have a pH less than 7.',
      'Bases have a pH greater than 7.',
      'Chemical reactions involve bond breaking and forming.',
      'Atoms are the basic building blocks of matter.',
      'Molecules are groups of atoms bonded together.',
      'Elements are substances made of only one type of atom.',
      'Compounds are substances made of two or more elements.',
      'Chemical bonds hold atoms together in molecules.',
    ],
    'physics': [
      'Force equals mass times acceleration (F=ma).',
      'Energy cannot be created or destroyed, only transformed.',
      'Gravity is the force that attracts objects toward each other.',
      'Light travels at 299,792,458 meters per second.',
      'Electricity is the flow of electric charge.',
      'Magnetism is a force that can attract or repel materials.',
      'Heat is the transfer of thermal energy.',
      'Sound travels as waves through a medium.',
      'Newton\'s laws describe motion and forces.',
      'Einstein\'s theory of relativity relates space and time.',
    ],
    'mathematics': [
      'Pi (π) is approximately 3.14159.',
      'The Pythagorean theorem relates sides of a right triangle.',
      'Algebra uses symbols to represent numbers.',
      'Geometry studies shapes and their properties.',
      'Calculus deals with rates of change and accumulation.',
      'Statistics involves collecting and analyzing data.',
      'Probability measures likelihood of events.',
      'Trigonometry studies triangles and angles.',
      'Fractions represent parts of a whole.',
      'Decimals are another way to represent fractions.',
    ],
  };

  // Get answer from local knowledge base
  static String getLocalAnswer(String question) {
    final lowerQuestion = question.toLowerCase();

    // Check each category
    for (final category in _knowledgeBase.keys) {
      if (lowerQuestion.contains(category) ||
          lowerQuestion.contains(category.substring(0, 3))) {
        final answers = _knowledgeBase[category]!;
        return answers[DateTime.now().millisecond % answers.length];
      }
    }

    // Check for specific keywords
    if (lowerQuestion.contains('planet') || lowerQuestion.contains('solar')) {
      return _knowledgeBase['astronomy']![DateTime.now().millisecond % _knowledgeBase['astronomy']!.length];
    } else if (lowerQuestion.contains('cell') || lowerQuestion.contains('body')) {
      return _knowledgeBase['biology']![DateTime.now().millisecond % _knowledgeBase['biology']!.length];
    } else if (lowerQuestion.contains('element') || lowerQuestion.contains('chemical')) {
      return _knowledgeBase['chemistry']![DateTime.now().millisecond % _knowledgeBase['chemistry']!.length];
    } else if (lowerQuestion.contains('force') || lowerQuestion.contains('energy')) {
      return _knowledgeBase['physics']![DateTime.now().millisecond % _knowledgeBase['physics']!.length];
    } else if (lowerQuestion.contains('math') || lowerQuestion.contains('calculate')) {
      return _knowledgeBase['mathematics']![DateTime.now().millisecond % _knowledgeBase['mathematics']!.length];
    }

    // Default answer
    return 'I understand you\'re asking: "$question". This is a great question! I recommend checking our AR models or quiz section for more detailed information on this topic. You can also try rephrasing your question.';
  }

  // Get AI answer (simulated for now)
  static Future<String> getAIAnswer(String question) async {
    try {
      // Simulate API delay
      await Future.delayed(Duration(seconds: 1));

      // For assessment, we'll use local knowledge base
      // In production, you could integrate with OpenAI API
      return getLocalAnswer(question);

    } catch (e) {
      return getLocalAnswer(question);
    }
  }

  // Save question to Firestore (for analytics)
  static Future<void> saveQuestion(String question, String answer) async {
    try {
      await _firestore.collection('qa_history').add({
        'question': question,
        'answer': answer,
        'timestamp': FieldValue.serverTimestamp(),
        'source': 'local_knowledge_base',
      });
    } catch (e) {
      // Silently fail - analytics only
      print('Failed to save question: $e');
    }
  }

  // Get answer with analytics
  static Future<String> getAnswer(String question) async {
    final answer = await getAIAnswer(question);
    await saveQuestion(question, answer);
    return answer;
  }

  // Get popular questions from Firestore
  static Stream<List<Map<String, dynamic>>> getPopularQuestions() {
    return _firestore
        .collection('qa_history')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => doc.data())
        .toList());
  }

  // Get question suggestions based on category
  static List<String> getQuestionSuggestions(String category) {
    final suggestions = {
      'astronomy': [
        'How many planets are in our solar system?',
        'What is the largest planet?',
        'How far is the Sun from Earth?',
        'What causes seasons on Earth?',
        'What are black holes?',
      ],
      'biology': [
        'How many bones are in the human body?',
        'What is DNA?',
        'How does photosynthesis work?',
        'What is the function of mitochondria?',
        'How does the heart work?',
      ],
      'chemistry': [
        'What is the chemical formula for water?',
        'What is the periodic table?',
        'What is an acid?',
        'How do chemical bonds form?',
        'What is a chemical reaction?',
      ],
      'physics': [
        'What is Newton\'s first law?',
        'How fast does light travel?',
        'What is gravity?',
        'What is electricity?',
        'What is the theory of relativity?',
      ],
      'mathematics': [
        'What is Pi?',
        'What is the Pythagorean theorem?',
        'What is algebra?',
        'How does calculus work?',
        'What is probability?',
      ],
    };

    return suggestions[category.toLowerCase()] ?? [
      'Tell me about our solar system',
      'Explain human biology basics',
      'What are chemical elements?',
      'Explain basic physics concepts',
      'What are mathematical operations?',
    ];
  }
}