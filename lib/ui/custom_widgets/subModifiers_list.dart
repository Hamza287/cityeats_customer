import 'package:city_customer_app/responses/restaurent_cat_reesponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubModifiersList extends StatelessWidget {
  const SubModifiersList({
    super.key,
    required this.subModifers,
  });

  final List<SubModifiers> subModifers;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: subModifers.length,
      padding: EdgeInsets.only(left: 13.w, top: 0, bottom: 10.h),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => Row(
        children: [
          Text(
            " 1 x  ${subModifers[index].name ?? " "}",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            width: 10.w,
          ),
          if (subModifers[index].price != 0)
            Text(
              "£ ${subModifers[index].price}",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 10.sp, fontWeight: FontWeight.w400),
            ),
        ],
      ),
      separatorBuilder: (BuildContext context, int index) => 2.verticalSpace,
    );
  }
}
