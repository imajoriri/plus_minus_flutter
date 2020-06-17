import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:social_share/social_share.dart';
import 'package:screenshot/screenshot.dart';
import 'package:provider/provider.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/services.dart';

import 'package:plus_minus_flutter/app_color.dart';
import 'package:plus_minus_flutter/components/weight_graph.dart';
import 'package:plus_minus_flutter/views/weight_text_field_modal.dart';
import 'package:plus_minus_flutter/store.dart';

class BaseDataView extends StatelessWidget {
  ScreenshotController screenshotController = ScreenshotController();
  final FocusNode weightNode = FocusNode();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('ぷらすまいなす'),
        elevation: 0.0,
        backgroundColor: AppColor.main,
      ),
      body: Screenshot(
        controller: screenshotController,
        child: SingleChildScrollView(
          child: _TargetDataWidget(context),
        ),
      ),
      backgroundColor: Colors.grey[100],
    );
  }

  Widget _TargetDataWidget(BuildContext context) {
    double graphHeight = MediaQuery.of(context).size.height / 2.7;

    return Container(
      child: Column(
        children: <Widget>[
          // 上部のデータとグラフ
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 20, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    Provider.of<ConfigStore>(context).selectedDateToString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _PerDataWidget(),
                    _PerDataWidget(),
                    _PerDataWidget(),
                  ],
                ),
                Container(
                  height: graphHeight,
                  padding: EdgeInsets.only(top: 20),
                  child: WeightGraph(),
                ),
              ],
            ),
          ),

          // 下部の入力部分
          Container(
            padding: EdgeInsets.only(top: 20, left: 16, right: 16),
            child: WeightTextField(context),
          ),
          // シェアボタン
          Container(
            padding: EdgeInsets.only(top: 50),
            child: ShareButtons(),
          )
        ],
      ),
    );
  }

  Widget ShareButtons() {
    return ButtonTheme(
      height: 70,
      child: RaisedButton(
        child: Text("ins"),
        color: Colors.white,
        shape: CircleBorder(
          side: BorderSide(
            color: Colors.white,
            width: 1.0,
            style: BorderStyle.solid,
          ),
        ),
        onPressed: () async {
          await screenshotController.capture().then((image) async {
            SocialShare.shareInstagramStory(
              image.path,
              "#ffffff",
              "#000000",
              "https://deep-link-url",
            ).then((data) {
              print(data);
            });
          });
        },
      ),
    );
  }

  Widget WeightTextField(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          HapticFeedback.lightImpact();
          showCupertinoModalBottomSheet(
              expand: true,
              duration: Duration(milliseconds: 200),
              context: context,
              backgroundColor: Colors.white,
              builder: (context, scrollController) {
                return WeightTextFieldModal();
              });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("体重", style: TextStyle(color: Colors.grey[700], fontSize: 20)),
            Row(
              children: <Widget>[
                Text(
                  Provider.of<ConfigStore>(context).activity == null
                      ? ""
                      : Provider.of<ConfigStore>(context)
                          .activity
                          .weight
                          .toString(),
                  style: TextStyle(color: Colors.grey[700], fontSize: 20),
                ),
                Text("kg", style: TextStyle(fontSize: 20)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget WeightModal(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Modal BottomSheet'),
            RaisedButton(
              child: const Text('Close BottomSheet'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      ),
    );
  }

  Widget _PerDataWidget() {
    return Container(
      // color: Colors.grey[100],
      width: 100,
      height: 70,
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Text("経過日数",
                style: TextStyle(fontSize: 13, color: Colors.green)),
            alignment: Alignment.topLeft,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  "10",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text("日", style: TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
