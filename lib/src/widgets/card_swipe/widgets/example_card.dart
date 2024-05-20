import 'package:dating_app/imports.dart';
import 'package:dating_app/src/model/dashboard/cardlist_model.dart';
import 'package:dating_app/src/widgets/widget.card.dart';

class ExampleCard extends StatelessWidget {
  const ExampleCard({
    required this.name,
    required this.assetPath,
    required this.cardlist,
    super.key,
  });

  final String name;
  final String assetPath;
  final CardList cardlist;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Stack(
        children: [
          Positioned.fill(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child:
                      // Image.network(
                      //   "${generalSetting?.s3Url}${cardlist.image}",

                      CachedNetworkImage(
                    imageUrl: "${generalSetting?.s3Url}${cardlist.image}",
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(seconds: 0),
                    fadeOutDuration: const Duration(seconds: 0),
                    fadeInCurve: Curves.ease,
                    // fadeInDuration: Duration(seconds: 0),
                    errorWidget: (context, url, error) => Image.asset(
                      ImageConstants.noimage,
                      fit: BoxFit.cover,
                    ),
                  )
                  // ),
                  )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(14),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    ColorConstants().dropshadow.withOpacity(0.0),
                    ColorConstants().dropshadow.withOpacity(1.0),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 16, 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                cardlist.isOnline == "1"
                    ? Align(
                        alignment: Alignment.topRight,
                        child: SizedBox(
                            height: 24,
                            width: 60,
                            child: CustomCard(
                                isGradientCard: false,
                                backgroundColor: ColorConstants().green,
                                bordercolor: ColorConstants().white,
                                borderradius: 28,
                                child: Center(
                                  child: CustomText(
                                    text: cardlist.isOnline == "1" ? toLabelValue(StringConstants.online) : "",
                                    style: TextStyleConfig.regularTextStyle(
                                        styleLineHeight: 1.0, fontSize: 11, color: ColorConstants().white),
                                  ),
                                ))),
                      )
                    : Container(
                        color: Colors.amber,
                      ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                        text: cardlist.name,
                        style: TextStyleConfig.boldTextStyle(
                            fontSize: TextStyleConfig.bodyText24,
                            fontWeight: FontWeight.w700,
                            color: ColorConstants().white)),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(ImageConstants.icon_map_pin),
                        const SizedBox(
                          width: 8,
                        ),
                        Flexible(
                          child: CustomText(
                              text:
                                  "${cardlist.location!}, ${cardlist.awayDistance} ${StringConstants.km}s ${StringConstants.away}",
                              maxlines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyleConfig.regularTextStyle(
                                  fontSize: TextStyleConfig.bodyText12,
                                  fontWeight: FontWeight.w400,
                                  color: ColorConstants().lightgrey)),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
