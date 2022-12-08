import 'package:filter_list/filter_list.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dbutility.dart';
import 'appState.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _SearchPage createState() => _SearchPage();
}


/// Creating a global list for example purpose.
/// Generally it should be within data class or where ever you want
List<String> tagList = [
  "그할마",
  "커피유야",
  "법원",
  "양덕 주차장",
  "다이소(양덕",

  "원룸",
  "미니투룸",
  "투룸",
  "쉐어하우스",
  "싱크대",

  "Wi-Fi",
  "침대",
  "가스 레인지",
  "냉장고",
  "에어콘",

  "장롱",
  "세탁기",
  "의자",
  "신발장",
  "배란다",

];

class _SearchPage extends State<SearchPage> {

  double _depositSliderStartValue = 0.0;
  double _depositSliderEndValue = 300.0;
  double _monthlySliderStartValue = 0.0;
  double _monthlySliderEndValue = 50.0;

  final double _depositMin = 0.0;
  final double _depositMax = 1000.0;
  final double _monthlyMin = 0.0;
  final double _monthlyMax = 300.0;

  final _depositMinTextFieldController = TextEditingController();
  final _depositMaxTextFieldController = TextEditingController();
  final _monthlyMinTextFieldController = TextEditingController();
  final _monthlyMaxTextFieldController = TextEditingController();

  String? _numVerifier(value) {
    if (value !=  null && int.tryParse(value) != null) {
      return 'Input msut be int';
    } else return null;
  }

  List<String> selectedTagList = [];


  Future<void> _openFilterDialog() async {
    await FilterListDialog.display<String>(
      context,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData(context),
      headlineText: 'Select Tags',
      height: 500,
      listData: tagList,
      selectedListData: selectedTagList,
      choiceChipLabel: (item) => item,//item!.name,
      validateSelectedItem: (list, val) => list!.contains(val),
      controlButtons: [ControlButtonType.All, ControlButtonType.Reset],
      onItemSearch: (tag, query) {
        /// When search query change in search bar then this method will be called
        ///
        /// Check if items contains query
        return tag.toLowerCase().contains(query.toLowerCase());
      },

      onApplyButtonClick: (list) {
        setState(() {
          selectedTagList = List.from(list!);
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // var mytheme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Filter"),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.blue,),
            onPressed: () async {


              // SEARCH QUERY
              List<House> houses = await getQueriedHouses(
                  _depositSliderStartValue,
                  _depositSliderEndValue,
                  _monthlySliderStartValue,
                  _monthlySliderEndValue,
                  selectedTagList);


              // double _depositSliderStartValue = 0.0;
              // double _depositSliderEndValue = 300.0;
              // double _monthlySliderStartValue = 0.0;
              // double _monthlySliderEndValue = 50.0;

              Navigator.pushNamed(context, '/queryList');
            },
          ),
        ],
      ),
      // body : ,
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.only(bottom: 30),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     children: <Widget>[
      //       TextButton(
      //         onPressed: () async {
      //           final list = await Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => FilterPage(
      //                 allTextList: userList,
      //                 selectedUserList: selectedUserList,
      //               ),
      //             ),
      //           );
      //           if (list != null) {
      //             setState(() {
      //               selectedUserList = List.from(list);
      //             });
      //           }
      //         },
      //         style: ButtonStyle(
      //           backgroundColor: MaterialStateProperty.all(Colors.blue),
      //         ),
      //         child: const Text(
      //           "Filter Page",
      //           style: TextStyle(color: Colors.white),
      //         ),
      //       ),
      //       TextButton(
      //         onPressed: openFilterDelegate,
      //         style: ButtonStyle(
      //           backgroundColor: MaterialStateProperty.all(Colors.blue),
      //         ),
      //         child: const Text(
      //           "Filter Delegate",
      //           style: TextStyle(color: Colors.white),
      //         ),
      //         // color: Colors.blue,
      //       ),
      //     ],
      //   ),
      // ),
      body: Column(
        children: <Widget>[
          SizedBox(height : 10),
          Text("보증금",
            style: Theme.of(context).textTheme.headline5,
          ),
          RangeSlider(
            min: _depositMin,
            max: _depositMax,
            values: RangeValues(_depositSliderStartValue, _depositSliderEndValue),
            labels: RangeLabels(
              _depositSliderStartValue.toString(),
              _depositSliderEndValue.toString(),
            ),
            divisions: (_depositMax - _depositMin)~/10,
            // values: RangeValues(double.tryParse((_depositMinTextFieldController.text), double.parse(_depositMaxTextFieldController.text)),
            onChanged: (values) {
              setState(() {
                _depositSliderStartValue = values.start;
                _depositSliderEndValue = values.end;
                _depositMinTextFieldController.text = values.start.toInt().toString();
                _depositMaxTextFieldController.text = values.end.toInt().toString();
              });
            },
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
            child : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_depositMin.toString()),
              Text(_depositMax.toString()),
            ],
            ),
          ),
          Row(
            children :[
              Flexible(
                child: TextField(
                  readOnly: true,
                  // inputFormatters: [FilteringTextInputFormatter.allow('')],
                  controller: _depositMinTextFieldController,
                  decoration: InputDecoration(
                    // bor  der: InputBorder.none,
                      hintText: '0 ~ 1000',
                      labelText: "최소 보증금"),
                  // onChanged: (value){
                  //   setState((){
                  //     double newVal = double.parse(_depositMinTextFieldController.text);
                  //     // if(newVal >= _depositMin && newVal <= _depositMax && newVal >= double.parse(_depositMinTextFieldController.text)) {
                  //       _depositMinTextFieldController.text = newVal.toString();
                  //       _depositSliderStartValue = newVal;
                  //     // }
                  //   });
                  // },
                ),
              ),
              Flexible(
                child:TextField(
                  readOnly: true,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: _depositMaxTextFieldController,
                  decoration: InputDecoration(
                    // border: InputBorder.none,
                      hintText: '0 ~ 1000',
                      labelText: "최대 보증금"),
                  // onChanged: (value){
                  //   setState((){
                  //     double newVal = double.parse(_depositMaxTextFieldController.text);
                  //     // if(newVal >= _depositMin && newVal <= _depositMax && newVal <= double.parse(_depositMaxTextFieldController.text)) {
                  //       _depositMaxTextFieldController.text = newVal.toString();
                  //       _depositSliderEndValue = newVal;
                  //     // }
                  //     // _depositSliderEndValue = int.parse(_depositMaxTextFieldController.text);
                  //   });
                  // },
                ),
              ),
            ],
          ),
          SizedBox(height : 10),
          Text("월세",
            style: Theme.of(context).textTheme.headline5,
          ),
          RangeSlider(
            min: _monthlyMin.toDouble(),
            max: _monthlyMax.toDouble(),
            values: RangeValues(_monthlySliderStartValue, _monthlySliderEndValue),
            labels: RangeLabels(
              _monthlySliderStartValue.toString(),
              _monthlySliderEndValue.toString(),
            ),
            divisions: (_monthlyMax - _monthlyMin)~/10,
            // values: RangeValues(double.parse(_monthlyMinTextFieldController.text), double.parse(_monthlyMinTextFieldController.text)),
            onChanged: (values) {
              setState(() {
                _monthlySliderStartValue = values.start;
                _monthlySliderEndValue = values.end;
                _monthlyMinTextFieldController.text = values.start.toInt().toString();
                _monthlyMaxTextFieldController.text = values.end.toInt().toString();
              });
            },
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
            child : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_monthlyMin.toString()),
                Text(_monthlyMax.toString())
              ],
            ),
          ),

          Row(
            children :[
              Flexible(
                child: TextField(
                  readOnly: true,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: _monthlyMinTextFieldController,
                  decoration: InputDecoration(
                    // border: InputBorder.none,
                      hintText: '0 ~ 300',
                      labelText: "최소 월세"),
                  // onChanged: (value){
                  //   setState((){
                  //     double newVal = double.parse(_monthlyMinTextFieldController.text);
                  //     if(newVal >= _monthlyMin && newVal <= _monthlyMax && newVal >= double.parse(_monthlyMinTextFieldController.text)) {
                  //       _monthlyMinTextFieldController.text = newVal.toString();
                  //       _monthlySliderStartValue = newVal;
                  //     }
                  //   });
                  // },
                ),
              ),
              Flexible(
                child : TextField(
                  readOnly: true,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: _monthlyMaxTextFieldController,
                  decoration: InputDecoration(
                    // border: InputBorder.none,
                      hintText: '0 ~ 300',
                      labelText: "최대 월세"),
                  // onChanged: (value){
                  //   setState((){
                  //     double newVal = double.parse(_monthlyMaxTextFieldController.text);
                  //     if(newVal >= _monthlyMin && newVal <= _monthlyMax && newVal <= double.parse(_monthlyMaxTextFieldController.text)) {
                  //       _monthlyMaxTextFieldController.text = newVal.toString();
                  //       _monthlySliderEndValue = newVal;
                  //     }
                  //   });
                  // },
                ),
              ),
            ],
          ),
          SizedBox(height : 10),
          Text("태그 필터",
            style: Theme.of(context).textTheme.headline5,
          ),
          IconButton(
            color: Colors.blue,
            onPressed: _openFilterDialog,
            // style: ButtonStyle(
            //   backgroundColor: MaterialStateProperty.all(Colors.blue),
            // ),
            icon: Icon(Icons.add,
              color: Colors.blue,
            ), // TODO : better looking
          ),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(selectedTagList![index]),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: selectedTagList!.length,
            ),
          ),
        ],
      ),
    );
  }
}