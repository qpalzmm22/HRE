// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import 'appState.dart';
import 'app.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  FlutterFireUIAuth.configureProviders([
    const EmailProviderConfiguration(),
    GoogleProviderConfiguration(clientId: DefaultFirebaseOptions.currentPlatform.iosClientId.toString()),
  ]);
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const  HreApp(),
    ),
  );
  //runApp(const ShrineApp());


}
