import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../../services/input_decoration.dart';
import 'custom_appbar.dart';

///TODO: Define toString() method for the model or Pass a data as List of String.
class DropDownKiller<T> extends StatefulWidget {
  const DropDownKiller({Key? key, required this.data, required this.onSelected}) : super(key: key);

  final List<T> data;
  final Function(T result) onSelected;

  @override
  State<DropDownKiller<T>> createState() => _DropDownKillerState<T>();
}

class _DropDownKillerState<T> extends State<DropDownKiller<T>> {
  List<T> searchedList = [];

  TextEditingController textEditingController = TextEditingController();

  onSearched(String key) {
    searchedList.clear();
    for (var element in widget.data) {
      if (element.toString().toLowerCase().contains(key.toLowerCase())) {
        searchedList.add(element);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool searched = textEditingController.text.isNotEmpty;
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Search',
        centerTitle: true,
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.0.w),
        child: Column(
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(vertical: 15.0.h),
              child: TextFormField(
                controller: textEditingController,
                onChanged: onSearched,
                decoration: CustomDecoration.inputDecoration(
                  label: "Search",
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: searched ? searchedList.length : widget.data.length,
                itemBuilder: (context, int index) {
                  return ListTile(
                    leading:  Icon(
                      Icons.circle,
                      size: 12.sp,
                    ),
                    title: Text(
                      searched ? searchedList[index].toString() : widget.data[index].toString(),
                    ),
                    onTap: () {
                      searched ? widget.onSelected(searchedList[index]) : widget.onSelected(widget.data[index]);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
