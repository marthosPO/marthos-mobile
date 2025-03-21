import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    print('로그인 화면 초기화됨');
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      print('구글 로그인 시작');

      // 구글 로그인 진행
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print('구글 로그인 결과: $googleUser');

      if (googleUser == null) {
        print('사용자가 로그인을 취소함');
        setState(() {
          _isLoading = false;
          _errorMessage = '로그인이 취소되었습니다.';
        });
        return;
      }

      // 구글 인증 정보 가져오기
      print('구글 인증 정보 요청 중...');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      print(
        '구글 인증 정보 받음: accessToken=${googleAuth.accessToken != null}, idToken=${googleAuth.idToken != null}',
      );

      // Firebase 인증 정보 생성
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print('Firebase 인증 정보 생성됨');

      // Firebase에 로그인
      print('Firebase 로그인 시작');
      await _auth.signInWithCredential(credential);
      print('Firebase 로그인 성공');

      // 로그인 성공 시 메인 화면으로 이동
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } catch (e) {
      print('로그인 오류 발생: $e');
      // 에러 처리
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = '로그인 실패: ${e.toString()}';
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('로그인 실패: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton.icon(
                onPressed: _handleGoogleSignIn,
                icon: Image.network(
                  'https://developers.google.com/identity/images/g-logo.png',
                  height: 24.0,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          const Icon(Icons.login, size: 24),
                ),
                label: const Text('Google로 로그인'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
