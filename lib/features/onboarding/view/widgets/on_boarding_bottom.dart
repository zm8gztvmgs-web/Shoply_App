part of '../on_boarding_screen.dart';

class _OnBoardingBottom extends StatelessWidget {
  const _OnBoardingBottom();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: BlocBuilder<OnBoardingCubit, OnBoardingState>(
          buildWhen: (previous, current) {
            return current is OnBoardingChangeIndexState;
          },
          builder: (context, state) {
            final cubit = context.read<OnBoardingCubit>();

            return Column(
              children: [
                CustomSmoothIndicator(
                  pageController: cubit.pageController,
                  count: 3,
                ),
                const SizedBox(height: 25),
                CustomButton(
                  buttonText: cubit.index != 2 ? 'Next' : 'Get Started',
                  onPressed: cubit.index != 2
                      ? () {
                          cubit.nextPageController();
                        }
                      : () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppPages.loginScreen,
                            (route) => false,
                          );
                          cubit.setShowOnBoard();
                        },
                ),
                const SizedBox(height: 12),
                if (cubit.index != 2)
                  CustomTextButton(
                    onTap: () {
                      cubit.skipOnBoard();
                    },
                    textButton: 'Skip',
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
