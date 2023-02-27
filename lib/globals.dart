library menu.globals;

import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import 'data.dart';
    bool isLoggedIn = false;
    String userName = '';
    String userEmail = '';
    String userId = '';
    String sessionToken = '';
    String avatar = '';
    Restaurant? thisRestaurant;
    String? thisTableId;
    bool acceptQrScanning = true;

    Future<void> userData() async {
        QueryBuilder<ParseObject> queryUser =
            QueryBuilder<ParseObject>(ParseUser.forQuery())
        ..whereEqualTo('username', userName);
        final ParseResponse apiUserResponse = await queryUser.query();
        if (apiUserResponse.success && apiUserResponse.results != null) {
            final user = (apiUserResponse.results!.first) as ParseObject;
            avatar = user.get('avatar');
            userEmail = user.get('email');
        }
    }