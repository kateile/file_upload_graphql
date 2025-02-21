import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'app/routes/app_pages.dart';

void main() async {
  await initHiveForFlutter();
  final HttpLink dioLink = HttpLink(
    'http://aqaratikom.com:5000/graphql'
  );

  final AuthLink authLink = AuthLink(
    getToken: () async => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MTA5MjM1MTg3NGE4MTA4NzdkNTIxMjYiLCJpZCI6MSwicm9sZXMiOlsiYWRtaW4iXSwiaWF0IjoxNjI4MzM5NjAwLCJleHAiOjE2MjgzNDMyMDB9.Yl9lM3Ms6lvLzswN5YN64hn2yyff0UyvZDxhNArUzgU',
  );

  final Link link = authLink.concat(dioLink);

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: link,
      // The default store is the InMemoryStore, which does NOT persist to disk
      cache: GraphQLCache(store: HiveStore()),
    ),
  );

  runApp(GraphQLProvider(
    client: client,
    child: GetMaterialApp(
      builder: (context, child) => ResponsiveWrapper.builder(
        child,
        defaultScale: true,
        breakpoints: [
          ResponsiveBreakpoint.resize(790, name: MOBILE),
          ResponsiveBreakpoint.autoScale(800, name: TABLET),
          ResponsiveBreakpoint.autoScale(1200, name: DESKTOP),
        ],
      ),
      title: "عقارتكم",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      defaultTransition: Transition.size,
    ),
  ));
}
