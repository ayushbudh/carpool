import 'package:carpool_app/screens/drive_screen.dart';
import 'package:carpool_app/services/location_services.dart';
import 'package:flutter/material.dart';

class SearchAutoCompleteScreen extends StatefulWidget {
  final TextEditingController controller;
  SearchAutoCompleteScreen(this.controller);

  _SearchAutoCompleteScreenState createState() =>
      _SearchAutoCompleteScreenState();
}

class _SearchAutoCompleteScreenState extends State<SearchAutoCompleteScreen> {
  int searchResultsLength = 0;
  List<dynamic> searchResultsList = [];

  void setSearchResults(String value) async {
    var results = await LocationService().getSearchResults(value);
    setState(() {
      searchResultsLength = results["length"];
      searchResultsList = results["results"];
    });
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff199EFF),
        // The search area here
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: TextField(
              controller: widget.controller,
              onChanged: (value) {
                setSearchResults(value);
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      widget.controller.clear();
                      setSearchResults(widget.controller.value.text);
                    },
                  ),
                  hintText: 'Search...',
                  border: InputBorder.none),
            ),
          ),
        ),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: searchResultsLength + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index >= searchResultsLength || searchResultsLength == 0) {
              return Column(children: [
                searchResultsLength == 0
                    ? ListTile(
                        leading: Icon(
                          Icons.location_searching,
                          size: 30,
                        ),
                        title: Text('Current Location'),
                        onTap: () async {
                          setState(() {
                            widget.controller.text = "get the location";

                            widget.controller.selection =
                                TextSelection.fromPosition(
                                    TextPosition(offset: 0));
                          });
                          Navigator.of(context).pop();
                        })
                    : Container(),
                ListTile(
                  title: Image.network(
                    'https://developers.google.com/maps/documentation/images/powered_by_google_on_white.png',
                  ),
                )
              ]);
            } else {
              return ListTile(
                  leading: Icon(
                    Icons.location_on,
                    size: 30,
                  ),
                  title: Text(
                      '${searchResultsList[index]["description"]} ${index}'),
                  onTap: () async {
                    setState(() {
                      widget.controller.text =
                          searchResultsList[index]["description"];

                      widget.controller.selection =
                          TextSelection.fromPosition(TextPosition(offset: 0));
                    });
                    Navigator.of(context).pop();
                  });
            }
          }),
    );
  }
}
