part of '../home_screen.dart';

class _HomeSales extends StatelessWidget {
  const _HomeSales();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: 170,
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Image.asset('assets/images/sales.png', fit: BoxFit.contain),
    );
  }
}
