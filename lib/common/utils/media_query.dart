    import 'package:flutter/widgets.dart';

    class MQuery {
      static double getWidth(BuildContext context, double percent) {
        return MediaQuery.of(context).size.width * percent;
      }

      static double getHeight(BuildContext context, double percent) {
        return MediaQuery.of(context).size.height * percent;
      }
    }
    
