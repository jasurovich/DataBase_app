import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading/dbHelper/db_helper.dart';
import 'package:loading/model/user_model.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with TickerProviderStateMixin {
  DatabaseHelper? _databaseHelper;
  List<User>? allUsers;
  TabController? _tabController;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var level;
  final TextEditingController _nameController = TextEditingController();
  String? picturePath;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
    allUsers = [];
    _databaseHelper = DatabaseHelper();
    _databaseHelper!.getAllUsers().then((allUsersFromDb) {
      for (var item in allUsersFromDb) {
        allUsers!.add(User.fromMapFromDb(item));
      }
      debugPrint(allUsers!.length.toString());
    }).catchError((err) {
      debugPrint(err.toString());
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _safeArea(),
    );
  }

  Widget _safeArea() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: 40.0),
            _today(),
            SizedBox(height: 10.0),
            _searchSection(),
            SizedBox(height: 10.0),
            _tabbarSection(),
            SizedBox(height: 5.0),
            allUsers!.isNotEmpty
                ? _mainSection()
                : Center(
                    child: CupertinoActivityIndicator(
                      radius: 20,
                    ),
                  ),
            InkWell(
              onTap: () {
                showModalBottomSheet<void>(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return _singleChildScrollView();
                  },
                );
              },
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_circle,
                      color: Colors.white,
                      size: 40.0,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      "Add New Follower",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    )
                  ],
                ),
                width: double.infinity,
                height: 80.0,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _today() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today",
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Icons.calendar_today,
              color: Colors.grey,
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "18 Jun 2019, Tuesday",
              style: TextStyle(color: Colors.grey, fontSize: 15.0),
            ),
            Container()
          ],
        ),
      ],
    );
  }

  Widget _searchSection() {
    return Container(
      alignment: Alignment.center,
      width: 350.0,
      height: 45.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              const Color(0xFF00CCFF),
              const Color(0xFF3366FF),
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
        borderRadius: BorderRadius.circular(
          25.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            color: Colors.white,
            size: 30.0,
          ),
          Text(
            "Search",
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          )
        ],
      ),
    );
  }

  Widget _tabbarSection() {
    return Container(
      child: TabBar(
        indicator: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(
            20.0,
          ),
        ),
        controller: _tabController,
        labelColor: Colors.blue,
        unselectedLabelColor: Colors.black,
        isScrollable: false,
        tabs: [
          Tab(
            child: Text("Undone"),
          ),
          Tab(
            child: Text("Meetings"),
          ),
          Tab(
            child: Text("Consumation"),
          ),
        ],
      ),
    );
  }

  Widget _mainSection() {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        height: 385.0,
        child: _listViewBuilder(),
      ),
    );
  }

  Widget _listViewBuilder() {
    return ListView.builder(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      shrinkWrap: true,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.only(bottom: 20.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.3),
              spreadRadius: 3,
              blurRadius: 4,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            20.0,
          ),
        ),
        child: ListTile(
          onTap: () {},
          leading: CircleAvatar(
            radius: 5.0,
            backgroundColor: Colors.brown[200],
          ),
          title: Text(
            "${allUsers![index].name}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
          ),
          subtitle: Text(
            "Something typed on subtite",
            style: TextStyle(fontSize: 15.0),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${allUsers![index].radioValue}',
              ),
              CircleAvatar(
                radius: 18.0,
                backgroundColor: Colors.grey,
                backgroundImage: AssetImage(
                  "${allUsers![index].picture}",
                ),
              ),
            ],
          ),
        ),
      ),
      itemCount: allUsers!.length,
    );
  }

  Widget _singleChildScrollView() {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
          color: Colors.blue[700],
        ),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(height: 10.0),
                Container(
                  width: 50.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: _textFieldSection(),
                ),
                Wrap(
                  spacing: 20,
                  children: [
                    _elevatedButton(Colors.green.shade100, "Meeting"),
                    _elevatedButton(Colors.yellow.shade100, "review"),
                    _elevatedButton(Colors.pink.shade100, "Marketing"),
                    _elevatedButton(Colors.orange.shade100, "Design Project"),
                    _elevatedButton(Colors.blue.shade200, "+")
                  ],
                ),
                Divider(color: Colors.white, thickness: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Priority",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18.0),
                      ),
                      Container()
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Expanded(
                    child: _radioButtonSection(),
                  ),
                ),
                Divider(color: Colors.white, thickness: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Invite",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18.0),
                      ),
                      Container()
                    ],
                  ),
                ),
                _imageSection(),
                SizedBox(
                  height: 50.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.transparent, elevation: 0),
                        child: const Text(
                          'Close',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(width: 20.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.white),
                        child: const Text(
                          'Save',
                          style: TextStyle(color: Colors.black, fontSize: 18.0),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _addUser(
                              User(_nameController.text, level, picturePath),
                            );
                            _nameController.clear();
                            level = "";
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _elevatedButton(Color c, String s) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(elevation: 0, primary: c),
      onPressed: () {},
      child: Text(
        "$s",
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
    );
  }

  Widget _textFieldSection() {
    return TextFormField(
      controller: _nameController,
      cursorColor: Colors.white54,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "What do you need to do?",
        hintStyle: TextStyle(color: Colors.white54, fontSize: 25.0),
      ),
      validator: (v) {
        if (v!.isEmpty) {
          return 'So\'z kiriting';
        }
      },
    );
  }

  Widget _radioButtonSection() {
    return Row(
      children: [
        Row(
          children: [
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) => Radio(
                activeColor: Colors.white,
                fillColor: MaterialStateProperty.all(Colors.white),
                value: 'high',
                groupValue: level,
                onChanged: (value) {
                  setState(() {
                    level = value.toString();
                  });
                },
              ),
            ),
            Text('High !!!', style: TextStyle(color: Colors.white)),
          ],
        ),
        Row(
          children: [
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) => Radio(
                activeColor: Colors.white,
                fillColor: MaterialStateProperty.all(Colors.white),
                value: 'Medium',
                groupValue: level,
                onChanged: (value) {
                  setState(() {
                    level = value.toString();
                  });
                },
              ),
            ),
            Text('Medium !!', style: TextStyle(color: Colors.white)),
          ],
        ),
        Row(
          children: [
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) => Radio(
                activeColor: Colors.white,
                fillColor: MaterialStateProperty.all(Colors.white),
                value: 'Low',
                groupValue: level,
                onChanged: (value) {
                  setState(() {
                    level = value.toString();
                  });
                },
              ),
            ),
            Text('Low !', style: TextStyle(color: Colors.white)),
          ],
        ),
        Row(
          children: [
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) => Radio(
                activeColor: Colors.white,
                fillColor: MaterialStateProperty.all(Colors.white),
                value: 'None',
                groupValue: level,
                onChanged: (value) {
                  setState(() {
                    level = value.toString();
                  });
                },
              ),
            ),
            Text(
              'None',
              style: TextStyle(color: Colors.white),
            ),
          ],
        )
      ],
    );
  }

  Widget _imageSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              picturePath = "assets/images/avatar_image_1.png";
            });
          },
          child: Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/images/avatar_image_1.png",
                  ),
                  fit: BoxFit.cover),
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              picturePath = "assets/images/avatar_image_2.png";
            });
          },
          child: Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/images/avatar_image_2.png",
                  ),
                  fit: BoxFit.cover),
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            picturePath = "assets/images/avatar_image_3.png";
          },
          child: Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/images/avatar_image_3.png",
                  ),
                  fit: BoxFit.cover),
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              picturePath = "assets/images/avatar_image_4.png";
            });
          },
          child: Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/images/avatar_image_4.png",
                  ),
                  fit: BoxFit.cover),
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ],
    );
  }

  _addUser(User u) async {
    try {
      var addUser = await _databaseHelper!.addUser(u);
      if (addUser > 0) {
        setState(() {
          allUsers!.insert(0, u);
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
