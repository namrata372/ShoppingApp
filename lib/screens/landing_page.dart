import 'package:shopping_app/data/consts/colors.dart';
import 'package:shopping_app/screens/bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shopping_app/Utils/global_method.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalMethods _globalMethods = GlobalMethods();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 20));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();
            }
          });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _googleSignIn() async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          var date = DateTime.now().toString();
          var dateparse = DateTime.parse(date);
          var formattedDate =
              "${dateparse.day}-${dateparse.month}-${dateparse.year}";
          final authResult = await _auth.signInWithCredential(
              GoogleAuthProvider.credential(
                  idToken: googleAuth.idToken,
                  accessToken: googleAuth.accessToken));
          await FirebaseFirestore.instance
              .collection('users')
              .doc(authResult.user!.uid)
              .set({
            'id': authResult.user!.uid,
            'name': authResult.user!.displayName,
            'email': authResult.user!.email,
            'phoneNumber': authResult.user!.phoneNumber,
            'imageUrl': authResult.user!.photoURL,
            'joinedAt': formattedDate,
            'createdAt': Timestamp.now(),
          });
        } catch (error) {
          _globalMethods.authErrorHandle(error.toString(), context);
        }
      }
    }
  }

  void _loginAnonymosly() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.signInAnonymously();
    } catch (error) {
      _globalMethods.authErrorHandle(error.toString(), context);
      print('error occured ${error.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      CachedNetworkImage(
        imageUrl:
            'https://thumbor.forbes.com/thumbor/fit-in/1200x0/filters%3Aformat%28jpg%29/https%3A%2F%2Fspecials-images.forbesimg.com%2Fdam%2Fimageserve%2F1138257321%2F0x0.jpg%3Ffit%3Dscale',
        errorWidget: (context, url, error) => Icon(Icons.error),
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: FractionalOffset(_animation.value, 0),
      ),
      Container(
        margin: EdgeInsets.only(top: 30),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Welcome to the biggest online store',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          ],
        ),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _googleSignIn,
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.pink.shade400),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side:
                                BorderSide(color: ColorsConsts.backgroundColor),
                          ),
                        )),
                    child: Text('Google'),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    ]));
  }
}
