import 'package:flutter/material.dart';
import 'package:teacher_app/widgets/loading_widget.dart';



// ignore: must_be_immutable
abstract class PaginationListWidget<T> extends StatefulWidget {

  final bool reversed;
  final int totalRecord;
  final List<T> items;
  final bool isLoading;
  final Function()? getMoreItems;

  const PaginationListWidget(
      {super.key,
      required this.items,
      this.isLoading = false,
      this.totalRecord = 0,
      this.getMoreItems,
        this.reversed = false
      });

  @override
  State<PaginationListWidget> createState() => _PaginationListWidget();

  Widget getItemWidget(T item, int index);

  Widget getListView(List<dynamic> items, ScrollController controller, int itemsCount ,bool isPageLoading) {
    return ListView.builder(
        itemCount: itemsCount,
        controller: controller,
        reverse: reversed,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder:(context, index) => itemBuilder(context, index , itemsCount , isPageLoading),
    );
  }

  Widget? itemBuilder(BuildContext context, int index, int itemsCount, bool isPageLoading) {
      var item = items[index];
      var itemWidget = getItemWidget(item, index);
      var isLastItemLoading = index == itemsCount-1 && isPageLoading;
      var itemForBuilder = isLastItemLoading ? itemLoading(itemWidget, item) : itemWidget;
      return itemForBuilder;
  }

  progressLoading() => const Padding(padding: EdgeInsets.all(20) ,child: LoadingWidget()) ;

  itemLoading(Widget itemWidget, T item) {
    return Column(children: [itemWidget, progressLoading()]);
  }

}
 class _PaginationListWidget extends State<PaginationListWidget> {
  late ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    var items = widget.items;
    var isPageLoading = isLoading();
    print("isPageLoading :$isPageLoading");
    print("isHasNextPage :${isHasNextPage()}");
    return widget.getListView(items , controller, items.length ,isPageLoading);
  }

  _scrollListener() {
    hideKeyboard();
    var totalRecord = widget.totalRecord;
    var itemsLength = getItemsLength();
    print("_scrollListener totalRecord:$totalRecord, itemsLength:$itemsLength");

    if (widget.totalRecord == itemsLength) {
      return;
    }
    var extentAfter = controller.position.extentAfter;
    var isPageLoading = isLoading();
    print(controller.position.extentAfter);
    print("_scrollListener extentAfter:$extentAfter, isPageLoading:$isPageLoading, isHasNextPage:${isHasNextPage()}");
    if (extentAfter <= 0 &&  !isPageLoading) {
      widget.getMoreItems?.call();
    }
  }

  void hideKeyboard() async{
    FocusScope.of(context).unfocus();
  }


  bool isHasNextPage() => widget.items.length < widget.totalRecord;

  bool isLoading() => widget.isLoading;

  getItemsLength() =>widget.items.length;

}

class PaginationConfig{
  bool isLoading;

  PaginationConfig({
     this.isLoading = false,
  });
}
