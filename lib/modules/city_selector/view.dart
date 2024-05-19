import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'logic.dart';

class CitySelectorPage extends StatefulWidget {
  const CitySelectorPage({super.key});

  @override
  State<CitySelectorPage> createState() => _CitySelectorPageState();
}

class _CitySelectorPageState extends State<CitySelectorPage> {
  final logic = Get.find<CitySelectorLogic>();

  final _editorController = TextEditingController();

  final _scrollerController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('选择城市'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
            child: TextField(
              controller: _editorController,
              onChanged: logic.onSearch,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: '请输入城市名称',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8.w),
                ),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _editorController.clear();
                    logic.onSearch('');
                  },
                ),
              ),
            ),
          ),
          Expanded(
              child: Obx(() => logic.showItems.isNotEmpty
                  ? ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 20.w),
                      controller: _scrollerController,
                      itemBuilder: (context, index) => ListTile(
                            key: ValueKey(logic.showItems[index].name),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 22.w),
                            onTap: () =>
                                logic.onSelectItem(logic.showItems[index]),
                            title: Text(logic.showItems[index].name ?? ""),
                            subtitle: Text(
                                "经度:${logic.showItems[index].log}°,纬度:${logic.showItems[index].lat}°"),
                          ),
                      separatorBuilder: (context, index) =>
                          Divider(color: Colors.grey[200], height: 1.w),
                      itemCount: logic.showItems.length)
                  : const Center(
                      child: CircularProgressIndicator(),
                    ))),
        ],
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<CitySelectorLogic>();
    _editorController.dispose();
    super.dispose();
  }
}
