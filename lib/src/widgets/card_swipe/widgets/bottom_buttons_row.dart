import 'package:dating_app/imports.dart';
import 'package:dating_app/src/screen/dashboard/home/card_swip/controller_card_swipe.dart';
import 'package:dating_app/src/widgets/card_swipe/swipable_stack.dart';
import 'package:flutter/foundation.dart';

class BottomButtonsRow extends StatelessWidget {
  const BottomButtonsRow({
    this.isFromUserdetail = false,
    required this.onRewindTap,
    required this.onSwipe,
    required this.canRewind,
    required this.planSwipCount,
    required this.countRightSwipe,
    required this.isMatchedUser,
    required this.isFromCardList,
    this.likeIcon = ImageConstants.icon_like,
    this.dislikeIcon = ImageConstants.icon_dislike,
    super.key,
  });

  final String? likeIcon;
  final String? dislikeIcon;
  final bool canRewind;
  final bool isFromUserdetail;
  final bool isFromCardList;
  final bool isMatchedUser;
  final VoidCallback onRewindTap;
  final ValueChanged<SwipeDirection> onSwipe;
  final int planSwipCount;
  final int countRightSwipe;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!isMatchedUser)
            InkWell(
                onTap: () {
                  onSwipe(SwipeDirection.left);
                },
                child: Container(
                  width: 52,
                  height: 52,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 2),
                        blurRadius: 12,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ],
                  ),
                  child: SvgPicture.asset(
                    dislikeIcon!,
                  ),
                )),

          if (isFromCardList || (!isMatchedUser && isFromCardList))
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: InkWell(
                  onTap: () {
                    isClickFromButtonView.value = true;
                    if (kDebugMode) {
                      print("==== count ${Get.find<ControllerCard>().countSwipeLimit.value},++ ");
                    }

                    onSwipe(SwipeDirection.right);
                  },
                  child: isFromUserdetail
                      ? Container(
                          width: 64,
                          height: 64,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            gradient: LinearGradient(
                                colors: [ColorConstants().secondaryGradient, ColorConstants().primaryGradient],
                                tileMode: TileMode.clamp),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 2),
                                blurRadius: 12,
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ],
                          ),
                          child: SvgPicture.asset(
                            likeIcon!,
                          ),
                        )
                      : Container(
                          width: 64,
                          height: 64,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 2),
                                blurRadius: 12,
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ],
                          ),
                          child: SvgPicture.asset(
                            likeIcon!,
                          ),
                        )),
            ),

          //Consider for second phase
          // InkWell(
          //     onTap: isUserSubscribe.value
          //         ? onRewindTap
          //         : () => Get.toNamed(Routes.subscription),
          //     child: SvgPicture.asset(ImageConstants.icon_rewind)),
        ],
      ),
    );
  }
}

class _BottomButton extends StatelessWidget {
  const _BottomButton({
    required this.onPressed,
    required this.child,
  });

  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      width: 64,
      child: InkWell(onTap: onPressed, child: child),
    );
  }
}
