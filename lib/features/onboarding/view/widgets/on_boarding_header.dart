part of '../on_boarding_screen.dart';

class _OnBoardingHeader extends StatelessWidget {
  const _OnBoardingHeader();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: BlocBuilder<OnBoardingCubit, OnBoardingState>(
        buildWhen: (previous, current) {
          return current is! OnBoardingChangeIndexState;
        },
        builder: (context, state) {
          final cubit = context.read<OnBoardingCubit>();

          return PageView.builder(
            controller: cubit.pageController,
            itemCount: 3,
            onPageChanged: (index) {
              cubit.changeIndex(index: index);
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Expanded(
                      child: Image(
                        image: AssetImage(cubit.onBoardImage[index]),
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      cubit.onBoardTitle[index],
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      cubit.onBoardDescreption[index],
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
