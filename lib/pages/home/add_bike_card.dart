import 'package:flutter/material.dart';
import '../../helpers/app_localizations.dart';

class AddBikeCard extends StatelessWidget {
  final VoidCallback? onPressed;

  const AddBikeCard({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Center(
      child: Container(
        width: double.infinity,
        height: 220,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage("assets/images/card-bg.jpg"),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 16.0,
              left: 16.0,
              right: 16.0,
              bottom: 48.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: IconButton(
                      iconSize: 80,
                      icon: const Icon(
                        Icons.add_circle,
                        color: Colors.white,
                      ),
                      onPressed: onPressed,
                    ),
                  ),
                  Text(
                    localizations.translate('add_bike_card_title'),
                    style: const TextStyle(
                      color: Color(0xFF37175C),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: const BoxDecoration(
                  color: Color(0xFFBBB2CF),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  ),
                ),
                child: Text(
                  localizations.translate('add_bike_card_message'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF2C0061),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
