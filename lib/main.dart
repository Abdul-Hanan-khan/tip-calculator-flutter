import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primaryColor: Colors.grey),
    home: BillSplitter(),
  ));
}

class BillSplitter extends StatefulWidget {
  @override
  _BillSplitterState createState() => _BillSplitterState();
}

class _BillSplitterState extends State<BillSplitter> {
  // double hei
  int _tipPercentage = 0;
  int _personCounter = 1;
  double _billAmount = 0.0;

  @override
  initState() {
    SystemChrome.setEnabledSystemUIOverlays([]); // remove status bar
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: size.height * 0.1),
        alignment: Alignment.center,
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.all(20.5),
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Container(
              width: 150.0,
              height: 150.0,
              decoration: BoxDecoration(
                color: Colors.blueGrey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Total per person",style: TextStyle(
                    color: Colors.blue,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text("\$ ${calculateTotalPerPerson(_billAmount, _personCounter, _tipPercentage)}",style: TextStyle(
                      color: Colors.blue,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    )),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blueGrey[100],
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(12.0)),
              child: Column(
                children: <Widget>[
                  TextField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(color: Colors.blue),
                    decoration: InputDecoration(
                      // focusColor: Colors.blueGrey,
                      fillColor: Colors.blue,
                      prefixText: "Bill Amount ",
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    onChanged: (String value) {
                      try {
                        _billAmount = double.parse(value);
                      } catch (exception) {
                        _billAmount = 0.0;
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Split",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      Row(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (_personCounter > 1) {
                                  _personCounter--;
                                } else {}
                              });
                            },
                            child: Container(
                              width: 40.0,
                              height: 40.0,
                              margin: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Center(
                                child: Text(
                                  "-",
                                  style: TextStyle(
                                      fontSize: 27,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[300]),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "$_personCounter",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 25,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _personCounter++;
                              });
                            },
                            child: Container(
                              width: 40.0,
                              height: 40.0,
                              margin: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Center(
                                child: Text(
                                  "+",
                                  style: TextStyle(
                                      fontSize: 27,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[300]),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Tip ",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "\$ ${calculateTotalTip(_billAmount, _personCounter, _tipPercentage)}",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        "$_tipPercentage%",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 17.0,
                        ),
                      ),
                      Slider(
                          min: 0.0,
                          max: 100.0,
                          activeColor: Colors.blue[300],
                          inactiveColor: Colors.grey,
                          // divisions: 10,
                          value: _tipPercentage.toDouble(),
                          onChanged: (double newValue) {
                            setState(() {
                              _tipPercentage = newValue.round();
                            });
                          })
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  calculateTotalPerPerson(double billAmount,int splitBy,int tipPercentage){
    var totalPerPerson=(calculateTotalTip(billAmount, splitBy, tipPercentage) +billAmount)/splitBy;
    return totalPerPerson.toStringAsFixed(2);
  }

  calculateTotalTip(double billAmount, int splitBy, int tipPercentage){
    double totalTip=0.0;
    if(billAmount<0 || billAmount.toString().isEmpty || billAmount==null){
      print("Bill Amount is Empty");
    }else{
       totalTip=(billAmount * tipPercentage)/100;
    }
    return totalTip;

  }
}
