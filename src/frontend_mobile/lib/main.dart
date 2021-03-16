
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
//import 'package:dropdownfield/dropdownfield.dart';

void main() => runApp(MaterialApp(home: Home()));

const RED_ATTENTION = 0xFFCB1C04;
const GREEN_SUCCESSFUL = 0xFF33AE08;
const BLACK = 0xFF000000;
const DARK_GREY = 0xFF6D6D6D;
const LIGHT_GREY = 0xFFECECEC;
const DARK_GREEN = 0xFF07630B;
const MINT = 0xFF1BD14C;
const OLIVE = 0xFF009A29;
const TEAL = 0xFF0EAD65;

class Home extends StatelessWidget {

  @override Widget build(BuildContext context) {
    return Scaffold(
      body: Center (
          child: SingleChildScrollView(
              child: Container(
                width: 300.0,

                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget> [
                      Padding(
                          padding: EdgeInsets.fromLTRB(50.0, 0, 50.0, 0)
                      ),

                      ShaderMask(
                        child: SvgPicture.asset(
                            'assets/icons/KotaricaLogomark.svg'
                        ),
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                              colors: [
                                Color(MINT),
                                Color(TEAL)
                              ],
                              stops: [0.4, 0.6]
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.srcATop,
                      ),

                      SizedBox(height: 20.0),

                      Text(
                          'Kotarica',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w900,
                              fontSize: 24,
                              color: Color(DARK_GREEN)
                          ),
                          textAlign: TextAlign.center
                      ),

                      SizedBox(height: 40.0),

                      Text(
                        'Kupujte sveže domaće proizvode.',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: Color(DARK_GREY)
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 50.0),

                      TextField(
                          style: TextStyle(
                              color: Color(DARK_GREY),
                              fontFamily: 'Inter',
                              fontSize: 14
                          ),
                          decoration: InputDecoration(
                              hintText: 'Email',
                              filled: true,
                              fillColor: Color(LIGHT_GREY),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(5.0)
                              )
                          )
                      ),

                      SizedBox(height: 20.0),

                      TextField(
                        style: TextStyle(
                            color: Color(DARK_GREY),
                            fontFamily: 'Inter',
                            fontSize: 14
                        ),
                        decoration: InputDecoration(
                          hintText: 'Lozinka',
                          filled: true,
                          fillColor: Color(LIGHT_GREY),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(5.0)
                          ),
                          suffixIcon: IconButton(
                            //onPressed: () => _controller.clear(),
                            icon: SvgPicture.asset(
                                'assets/icons/EyeSlash.svg',
                                color: Color(DARK_GREY)
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.0),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SuccessfulSignUp()),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Color(MINT),
                                    Color(TEAL),
                                  ]
                              ),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: Center(
                            child: Text(
                              'Prijavi se',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.0),

                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ForgottenPassword()),
                            );
                          },
                          child: Text(
                            'Zaboravili ste lozinku?',
                            style: TextStyle(
                                color: Color(TEAL),
                                fontFamily: 'Inter',
                                fontSize: 13
                            ),
                            textAlign: TextAlign.right,
                          )
                      ),

                      SizedBox(height: 50.0),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              'Nemate nalog?',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: Color(DARK_GREY),
                                  fontSize: 14
                              ),
                              textAlign: TextAlign.center
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SignUp()),
                              );
                            },
                            child: Text(
                                ' Registrujte se. ',
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: Color(TEAL),
                                    fontSize: 14
                                ),
                                textAlign: TextAlign.center
                            ),
                          ),

                          SvgPicture.asset(
                            'assets/icons/ArrowRight.svg',
                            color: Color(TEAL),
                            alignment: Alignment.center,
                            height: 20.0,
                            width: 20.0,
                          ),
                        ],
                      )
                    ]
                ),
              )
          )
      ),

      //resizeToAvoidBottomInset: false
    );
  }
}

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: SingleChildScrollView(
                child: Container(
                    width: 300.0,
                    child: Column(
                        children: <Widget> [
                          Padding(
                            padding: EdgeInsets.fromLTRB(50.0, 50.0, 50.0, 0.0),
                          ),

                          SvgPicture.asset(
                              'assets/icons/KotaricaLogomark.svg',
                              color: Color(TEAL),
                              height: 40.0,
                              width: 40.0
                          ),

                          Row(
                              children: <Widget> [
                                Text(
                                    'Ime:',
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Color(DARK_GREY),
                                        fontSize: 14
                                    )
                                ),
                              ]
                          ),

                          SizedBox(height: 5.0),

                          Container(
                            height: 50.0,
                            child: TextField(
                              style: TextStyle(
                                  color: Color(DARK_GREY),
                                  fontFamily: 'Inter',
                                  fontSize: 14
                              ),
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(LIGHT_GREY),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(5.0)
                                  )
                              ),
                            ),
                          ),

                          SizedBox(height: 15.0),

                          Row(
                              children: <Widget> [
                                Text(
                                    'Prezime:',
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Color(DARK_GREY),
                                        fontSize: 14
                                    )
                                ),
                              ]
                          ),

                          SizedBox(height: 5.0),

                          Container(
                            height: 50.0,
                            child: TextField(
                              style: TextStyle(
                                  color: Color(DARK_GREY),
                                  fontFamily: 'Inter',
                                  fontSize: 14
                              ),
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(LIGHT_GREY),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(5.0)
                                  )
                              ),
                            ),
                          ),

                          SizedBox(height: 15.0),

                          Row(
                            children: [
                              Text(
                                  'Datum rođenja:',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Color(DARK_GREY),
                                      fontSize: 14
                                  )
                              ),
                            ],
                          ),

                          SizedBox(height: 5.0),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget> [

                                Container(
                                    padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.0),
                                        color: Color(LIGHT_GREY)
                                    ),
                                    child: DropdownButtonHideUnderline (
                                        child: DropdownButton(
                                            hint: Text(
                                                ' Dan ',
                                                style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: Color(DARK_GREY),
                                                    fontSize: 14
                                                )
                                            ),
                                            icon: SvgPicture.asset(
                                                'assets/icons/ArrowDown.svg',
                                                color: Color(DARK_GREY)
                                            )
                                        )
                                    )
                                ),

                                Container(
                                    padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.0),
                                        color: Color(LIGHT_GREY)
                                    ),
                                    child: DropdownButtonHideUnderline (
                                        child: DropdownButton(
                                            hint: Text(
                                                ' Mesec ',
                                                style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: Color(DARK_GREY),
                                                    fontSize: 14
                                                )
                                            ),
                                            icon: SvgPicture.asset(
                                                'assets/icons/ArrowDown.svg',
                                                color: Color(DARK_GREY)
                                            )
                                        )
                                    )
                                ),

                                Container(
                                    padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.0),
                                        color: Color(LIGHT_GREY)
                                    ),
                                    child: DropdownButtonHideUnderline (
                                        child: DropdownButton(
                                            hint: Text(
                                                ' Godina ',
                                                style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: Color(DARK_GREY),
                                                    fontSize: 14
                                                )
                                            ),

                                            icon: SvgPicture.asset(
                                                'assets/icons/ArrowDown.svg',
                                                color: Color(DARK_GREY)
                                            )
                                        )
                                    )
                                )

                              ]
                          ),

                          SizedBox(height: 15.0),

                          Row(
                              children: <Widget> [
                                Text(
                                    'Broj telefona:',
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Color(DARK_GREY),
                                        fontSize: 14
                                    )
                                ),
                              ]
                          ),

                          SizedBox(height: 5.0),

                          Container(
                            height: 50.0,
                            child: TextField(
                              style: TextStyle(
                                  color: Color(DARK_GREY),
                                  fontFamily: 'Inter',
                                  fontSize: 14
                              ),
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(LIGHT_GREY),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(5.0)
                                  )
                              ),
                            ),
                          ),

                          SizedBox(height: 15.0),

                          Row(
                              children: <Widget> [
                                Text(
                                    'Email:',
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Color(DARK_GREY),
                                        fontSize: 14
                                    )
                                ),
                              ]
                          ),

                          SizedBox(height: 5.0),

                          Container(
                            height: 50.0,
                            child: TextField(
                              style: TextStyle(
                                  color: Color(DARK_GREY),
                                  fontFamily: 'Inter',
                                  fontSize: 14
                              ),
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(LIGHT_GREY),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(5.0)
                                  )
                              ),
                            ),
                          ),

                          SizedBox(height: 50.0),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SuccessfulRegistration()),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: 55,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        Color(MINT),
                                        Color(TEAL),
                                      ]
                                  ),
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              child: Center(
                                child: Text(
                                  'Registruj se',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 20.0),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                  'assets/icons/ArrowLeft.svg',
                                  color: Color(TEAL),
                                  height: 15.0,
                                  width: 15.0
                              ),

                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Home()),
                                    );
                                  },
                                  child: Text(
                                      ' Prijavite se',
                                      style: TextStyle(
                                          color: Color(TEAL),
                                          fontFamily: 'Inter',
                                          fontSize: 14
                                      )
                                  )
                              ),

                              Text(
                                  ' ukoliko već imate nalog.',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Color(DARK_GREY),
                                      fontSize: 14
                                  )
                              )
                            ],
                          )
                        ]
                    )
                )
            )
        )
    );
  }

}

class ForgottenPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
            'Zaboravljena lozinka',
            style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 24,
                color: Color(RED_ATTENTION)
            )
        ),
      ),
    );
  }
}

class SuccessfulRegistration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Text(
                'Uspešna registracija!',
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24,
                    color: Color(RED_ATTENTION)
                )
            )
        )
    );
  }

}

class SuccessfulSignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Text(
                'Uspešna prijava!',
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24,
                    color: Color(RED_ATTENTION)
                )
            )
        )
    );
  }

}