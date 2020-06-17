import 'package:flutter/material.dart';
import 'package:plus_minus_flutter/models/activity.dart';
import 'package:provider/provider.dart';
import 'package:plus_minus_flutter/store.dart';

class WeightTextFieldModal extends StatefulWidget {
  @override
  WeightTextFieldModalState createState() => WeightTextFieldModalState();
}

class WeightTextFieldModalState extends State<WeightTextFieldModal> {
  final controller = TextEditingController();
  Activity activity;
  DateTime selectedDate;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void didChangeDependencies() async {
    super.didChangeDependencies();
    selectedDate = Provider.of<ConfigStore>(context).selectedDate;

    activity = await Activity.findByDate(selectedDate);
    if (activity == null) {
      controller.text = "";
    } else {
      controller.text = activity.weight.toString();
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          MaterialButton(
            onPressed: () async {
              double weight;
              try {
                weight = double.parse(controller.text);
                if (activity == null) {
                  await Activity.create(weight: weight, createdAt: selectedDate);
                } else {
                  activity.weight = weight;
                  await activity.update();
                }
                
                Navigator.of(context)
                    .popUntil((route) => route.settings.name == '/');
              } catch (e) {
                print(e);
              }
            },
            child: Text('save'),
          ),
          Container(
            child: TextField(
              controller: controller,
              autofocus: true,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          )
        ],
      ),
    );
  }
}
