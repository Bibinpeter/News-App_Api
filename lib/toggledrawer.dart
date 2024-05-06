import 'package:news/main.dart';

void toggleDrawer(){
  if(scaffoldKey.currentState?.isDrawerOpen?? false){
    scaffoldKey.currentState?.openDrawer();
  }else{
    scaffoldKey.currentState?.openDrawer();
  }
 }