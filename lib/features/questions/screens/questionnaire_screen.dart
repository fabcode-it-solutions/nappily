import 'package:flutter/material.dart';
import 'package:notizen/features/questions/widgets/question_page.dart';
import 'package:notizen/services/questions_service.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({Key? key}) : super(key: key);

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final PageController _pageController = PageController();
  List<dynamic> _allQuestions = [];
  bool _isLoading = true;
  int _currentPageIndex = 0;
  final int _questionsPerPage = 5;
  int _totalPages = 0;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final questions = await QuestionsService().getFieldFromDocument(
        collectionPath: 'app-data',
        documentId: '8ogHvb5M7PX5CXe9lCAE',
        fieldName: 'questions',
      );
      List<dynamic> newList =
          questions.asMap().entries.map((entry) {
            int idx = entry.key;
            String val = entry.value;
            return {'index': idx, 'text': val};
          }).toList();
      setState(() {
        _allQuestions = newList;
        _totalPages = (_allQuestions.length / _questionsPerPage).ceil();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Failed to load questions. Please try again later.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(
              0xFF1A1932,
            ), // Dark blue dialog background
            title: const Text('Error', style: TextStyle(color: Colors.white)),
            content: Text(message, style: const TextStyle(color: Colors.white)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  List<dynamic> _getQuestionsForPage(int pageIndex) {
    final startIndex = pageIndex * _questionsPerPage;
    final endIndex =
        pageIndex == _totalPages - 1
            ? _allQuestions.length
            : startIndex + _questionsPerPage;
    return _allQuestions.sublist(startIndex, endIndex);
  }

  Future<void> _submitAnswers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showSuccessDialog();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Failed to submit answers. Please try again.');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(
              0xFF1A1932,
            ), // Dark blue dialog background
            title: const Text('Success', style: TextStyle(color: Colors.white)),
            content: const Text(
              'Your answers have been submitted successfully.',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QuestionnaireScreen(),
                    ),
                  );
                },
                child: const Text('Start Over'),
              ),
            ],
          ),
    );
  }

  void _goToNextPage() {
    if (_currentPageIndex < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPreviousPage() {
    if (_currentPageIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF14123A), Color(0xFF1E1B4B)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 45),
          child:
              _isLoading
                  ? Center()
                  : _allQuestions.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('No questions available.'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadQuestions,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                  : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Questionnaire Part',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 30,
                                letterSpacing: -0.5,
                                color: Color(0XFFFFFFFF),
                                fontFamily: "Poppins",
                              ),
                            ),
                            Container(
                              width: 60,
                              height: 35,
                              decoration: BoxDecoration(
                                color: const Color(0xFF5CA99F),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  '${_currentPageIndex + 1}/$_totalPages',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 3,
                        margin: EdgeInsets.only(top: 10, bottom: 30),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(0),
                          child: LinearProgressIndicator(
                            value: (_currentPageIndex + 1) / _totalPages,
                            backgroundColor: Colors.grey[800],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF5EBFB0),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          physics:
                              const NeverScrollableScrollPhysics(), // Disable swiping
                          onPageChanged: (index) {
                            setState(() {
                              _currentPageIndex = index;
                            });
                          },
                          itemCount: _totalPages,
                          itemBuilder: (context, index) {
                            return QuestionPage(
                              questions: _getQuestionsForPage(index),
                              onAnswerChanged: (questionId, answer) {
                                setState(() {
                                  final questionIndex = _allQuestions
                                      .indexWhere((q) => q.id == questionId);
                                  if (questionIndex != -1) {
                                    _allQuestions[questionIndex].answer =
                                        answer;
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 64,
                              child: ElevatedButton(
                                onPressed:
                                    _currentPageIndex == _totalPages - 1
                                        ? _submitAnswers
                                        : _goToNextPage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF5CA99F),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                ),
                                child: Text(
                                  _currentPageIndex == _totalPages - 1
                                      ? 'Submit'
                                      : 'Continue',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    height: 1,
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: _goToPreviousPage,
                              child: const Text(
                                'Back',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
