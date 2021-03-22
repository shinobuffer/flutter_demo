import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/component/image_set.dart';
import 'package:flutter_demo/service/api_service.dart';
import 'package:flutter_demo/utils/style_util.dart';
import 'package:flutter_demo/utils/toast_util.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class ExchangeCard extends StatefulWidget {
  ExchangeCard({Key key}) : super(key: key);

  @override
  _ExchangeCardState createState() => _ExchangeCardState();
}

class _ExchangeCardState extends State<ExchangeCard> {
  final TextEditingController _exValueController = TextEditingController();

  int get exValue => int.tryParse(_exValueController.text) ?? 0;
  int get exSeed => exValue * 100;

  /// 本次兑换结束前禁止再次兑换
  bool isExchanging = false;

  /// 瓜子兑换
  void doExchange() {
    if (exValue == 0) return;
    setState(() {
      isExchanging = true;
    });
    ApiService.exchange(exValue).then((resp) {
      ToastUtil.showText(text: resp.msg);
      if (resp.code == 0) Navigator.pop(context, true);
      setState(() {
        isExchanging = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Container(
        height: 200,
        padding: EdgeInsets.only(top: 15),
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '兑换金瓜子',
              style: TextStyleM.O1_18_B,
            ),
            Text(
              'B币 : 金瓜子 = 1 : 100',
              style: TextStyleM.D4,
            ),
            Container(
              height: 30,
              width: 240,
              child: Row(
                children: [
                  ImageSet(
                    ImageSets.bcoin,
                    height: 24,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                        LengthLimitingTextInputFormatter(6)
                      ],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: ColorM.C1,
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      controller: _exValueController,
                      onChanged: (value) => setState(() {}),
                    ),
                  ),
                  Icon(
                    Icons.arrow_right,
                    size: 30,
                  ),
                  ImageSet(
                    ImageSets.gold_seed,
                    height: 24,
                  ),
                  Expanded(
                    child: Text(
                      '$exSeed',
                      textAlign: TextAlign.center,
                      style: TextStyleM.O1_16,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 40,
              width: double.maxFinite,
              child: FlatButton(
                color: ColorM.O2,
                disabledColor: ColorM.C3,
                textColor: Colors.white,
                child: Text(isExchanging ? '兑换中' : '兑换'),
                onPressed: isExchanging ? null : doExchange,
              ),
            )
          ],
        ),
      );
    });
  }
}
