/* import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

void main() {
  // 1. Check FTextField params
  // error: The named parameter 'controller' isn't defined
  const t = FTextField(controller: null); // Expect error

  // Try checking what IS defined by passing nothing
  const t2 = FTextField();

  // 2. Check FButton params
  FButton(style: FButtonStyle.ghost, child: Text('t'), onPress: () {});

  // 3. Check FToast
  FToast(title: Text('t'), style: null);
}
 */
