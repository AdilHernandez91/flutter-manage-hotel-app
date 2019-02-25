import 'package:scoped_model/scoped_model.dart';

import 'auth_model.dart';
import 'hotel_model.dart';
import 'user_model.dart';

class MainModel extends Model with UserModel, AuthModel, HotelModel {}