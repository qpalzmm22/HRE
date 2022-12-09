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

  List<String> selectedTagList = ["원룸", "투룸", "미니투룸", "Wi-Fi",]; // default value


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
        if(list!.length <= 10) {
          setState(() {
            selectedTagList = List.from(list!);
          });
          Navigator.pop(context);
        } else {
          const snackBar = SnackBar(
            backgroundColor: Colors.red,
            content: Text('태그를 10개 이하로 선택해주세요.'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // var mytheme = Theme.of(context);


    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.


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

              Navigator.pushNamed(context, '/searchResultList', arguments: houses);
            },
          ),
        ],
      ),
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
                    hintText: '0 ~ 1000',
                    labelText: "최소 보증금"),
                ),
              ),
              Flexible(
                child:TextField(
                  readOnly: true,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: _depositMaxTextFieldController,
                  decoration: InputDecoration(
                    hintText: '0 ~ 1000',
                    labelText: "최대 보증금"),
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
                      labelText: "최대 월세")
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
            child: GridView.builder(
              // crossAxisCount : 4,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5, //1 개의 행에 보여줄 item 개수
                childAspectRatio: 4 / 1, //item 의 가로 1, 세로 2 의 비율
                mainAxisSpacing: 5, //수평 Padding
                crossAxisSpacing: 5, //수직 Padding
              ),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.cyan,
                    borderRadius:
                    BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Center(child: Text(selectedTagList![index])),
                );
              },
              // separatorBuilder: (context, index) => const Divider(),
              itemCount: selectedTagList!.length,
            ),
          ),
        ],
      ),
    );
  }
}