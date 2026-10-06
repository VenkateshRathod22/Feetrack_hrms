import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:vlr/data/repositories/basic_repo.dart';

class BasicController  extends GetxController implements GetxService{
  final BasicRepo basicRepo;

  BasicController({required this.basicRepo});
}