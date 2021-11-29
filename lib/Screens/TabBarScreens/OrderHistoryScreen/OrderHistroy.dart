import 'package:delivery_boy/BLoC/MainModelBlocClass/OrderHistoryBloC.dart';
import 'package:delivery_boy/Helper/CommonWidgets.dart';
import 'package:delivery_boy/Helper/Constant.dart';
import 'package:delivery_boy/Model/ModelOrderHistory.dart';
import 'package:delivery_boy/Screens/OrderSummary/OrderSummary.dart';
import 'package:delivery_boy/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(new OrderHistroy());

class OrderHistroy extends StatefulWidget {
  @override
  _OrderHistroyState createState() => _OrderHistroyState();
}

class _OrderHistroyState extends State<OrderHistroy> {
  _setOrderList(List<HistoryOrder> orderHistoryList) {
    return new ListView.builder(
        itemCount: orderHistoryList.length,
        itemBuilder: (context, index) {
          return new InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder:(context)=>OrderSummary(orderId: orderHistoryList[index].orderId,resImage: orderHistoryList[index].bannerImage,userId: orderHistoryList[index].userId,orderStatus: orderHistoryList[index].orderStatus,)));
            },
            child: new Container(
              color: AppColor.white,
              height: 180,
              padding:
                  new EdgeInsets.only(left: 15, right: 15, top: 7, bottom: 7),
              child: new Container(
                  decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: new BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 1,
                            spreadRadius: 0,
                            color: AppColor.grey,
                            offset: Offset(0, 0))
                      ]),
                  child: new Column(
                    children: <Widget>[
                      new Expanded(
                          flex: 6,
                          child: new Container(
                            padding: new EdgeInsets.only(
                                left: 10, right: 15, top: 10, bottom: 5),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              orderHistoryList[index]
                                                  .bannerImage),
                                          //  AssetImage(
                                          // 'Assets/RestaurantDetails/RestaurantApp.jpg'),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                SizedBox(width: 8),
                                new Expanded(
                                    child: new Container(
                                  child: new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      setCommonText(
                                          orderHistoryList[index].name,
                                          AppColor.black,
                                          14.0,
                                          FontWeight.w500,
                                          2),
                                      SizedBox(height: 3),
                                      setCommonText(
                                          orderHistoryList[index].address,
                                          AppColor.grey,
                                          12.0,
                                          FontWeight.w400,
                                          2),
                                      // SizedBox(height: 10),
                                      Divider(
                                        color: AppColor.black38,
                                      ),
                                      new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              setCommonText(
                                                  "${S.current.order_ID}: ",
                                                  AppColor.themeColor,
                                                  14.0,
                                                  FontWeight.w500,
                                                  2),
                                              setCommonText(
                                                  "#${orderHistoryList[index].orderId}",
                                                  AppColor.grey[800],
                                                  12.0,
                                                  FontWeight.w400,
                                                  2),
                                            ],
                                          ),
                                          setCommonText(
                                              "\$${orderHistoryList[index].totalPrice}",
                                              AppColor.black,
                                              14.0,
                                              FontWeight.w500,
                                              2),
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                      new Row(
                                        children: <Widget>[
                                          setCommonText(
                                              (orderHistoryList[index]
                                                          .driverStatus ==
                                                      "2")
                                                  ? "${S.current.rejected_on} "
                                                  : "${S.current.delivered_on} ",
                                              AppColor.red,
                                              12.0,
                                              FontWeight.w500,
                                              2),
                                          new Expanded(
                                              child: setCommonText(
                                                  orderHistoryList[index]
                                                      .updated,
                                                  AppColor.grey[500],
                                                  12.0,
                                                  FontWeight.w400,
                                                  2)),
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                              ],
                            ),
                          )),
                      new Expanded(
                          flex: 2,
                          child: new Container(
                            padding: new EdgeInsets.only(left: 15, right: 15),
                            // color: Colors.green
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                new Container(
                                  height: 28,
                                  decoration: BoxDecoration(
                                      color: (orderHistoryList[index]
                                                  .driverStatus ==
                                              "2")
                                          ? AppColor.red
                                          : AppColor.themeColor,
                                      borderRadius: BorderRadius.circular(14)),
                                  child: new Center(
                                      child: (orderHistoryList[index]
                                                  .driverStatus ==
                                              "2")
                                          ? setCommonText(
                                              "   ${S.current.order_rejected}   ",
                                              AppColor.white,
                                              12.0,
                                              FontWeight.w500,
                                              1)
                                          : setCommonText(
                                              "   ${S.current.order_delivered}   ",
                                              AppColor.white,
                                              12.0,
                                              FontWeight.w500,
                                              1)),
                                ),
                              ],
                            ),
                          ))
                    ],
                  )),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(DefaultKeys.userId);

    historyListBloc.getAllHistoryList(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: setCommonAppBar("${S.current.order_history}", true, context),
      body: StreamBuilder(
          stream: historyListBloc.getHistoryList,
          builder: (context, AsyncSnapshot<ResOrderHistory> snapshot) {
            if (snapshot.hasData) {
              final result = snapshot.data.historyOrderList;
              return new Container(
                color: AppColor.white,
                child: result.length > 0
                    ? _setOrderList(result)
                    : Center(
                        child: setCommonText('No Order Found', AppColor.black,
                            15.0, FontWeight.w500, 1),
                      ),
              );
            } else {
              return new Center(
                child: new CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
