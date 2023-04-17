import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:plugyourev/login_page.dart';

class OnBoardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SafeArea(
        child: IntroductionScreen(
            pages: [
              PageViewModel(
                title: "Find your nearest charging stations",
                body: "",
                image: const Center(
                  child: Image(image: AssetImage('assets/intro_image1.jpg')),
                ),
                decoration: const PageDecoration(
                  titleTextStyle: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                  bodyTextStyle: TextStyle(fontSize: 20, color: Colors.blue),
                  //  descriptionPadding: EdgeInsets.all(16).copyWith(bottom: 0),
                  imagePadding: EdgeInsets.all(24),
                  pageColor: Colors.white,
                ),
              ),
              PageViewModel(
                title: "Book your car slot",
                body: "",
                image: const Center(
                  child: Image(image: AssetImage('assets/onb_img3.jpg')),
                ),
                decoration: const PageDecoration(
                  titleTextStyle: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                  bodyTextStyle: TextStyle(fontSize: 20, color: Colors.blue),
                  //descriptionPadding: EdgeInsets.all(16).copyWith(bottom: 0),
                  imagePadding: EdgeInsets.all(24),
                  pageColor: Colors.white,
                ),
              ),
              PageViewModel(
                title: "Charge your car easily",
                body: "",
                image: const Center(
                  child: Image(image: AssetImage('assets/onb_img2.png')),
                ),
                decoration: const PageDecoration(
                  titleTextStyle: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                  bodyTextStyle: TextStyle(fontSize: 20, color: Colors.blue),
                  bodyPadding: EdgeInsets.all(16),
                  imagePadding: EdgeInsets.all(24),
                  pageColor: Colors.white,
                ),
              )
            ],
            showDoneButton: true,
            done: const Text('Start',
                style: TextStyle(fontWeight: FontWeight.w600)),
            onDone: () => goToHome(context),
            showSkipButton: true,
            skip: const Text('Skip'),
            onSkip: () => goToHome(context),
            showNextButton: true,
            next: const Icon(Icons.arrow_forward),
            dotsDecorator: DotsDecorator(
              size: const Size.square(10.0),
              activeSize: const Size(20.0, 10.0),
              activeColor: Theme.of(context).colorScheme.secondary,
              color: Colors.blue,
              spacing: const EdgeInsets.symmetric(horizontal: 3.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)),
            ),
            onChange: (index) => print('Page $index selected'),
            globalBackgroundColor: Colors.white,
            skipOrBackFlex: 0,
            nextFlex: 0,
            isBottomSafeArea: true
            // isProgressTap: false,
            // isProgress: false,
            // showNextButton: false,
            // freeze: true,
            // animationDuration: 1000,
            ),
      );

  void goToHome(context) => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => MyLogin()),
      );

  Widget buildImage(String path) =>
      Center(child: Image.asset(path, width: 350));
}
