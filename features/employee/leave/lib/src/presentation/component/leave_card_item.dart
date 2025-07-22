import 'package:component/component.dart';
import 'package:flutter/material.dart';
import 'package:l10n/l10n.dart';
import 'package:preferences/preferences.dart';

import '../../../leave.dart';
import '../../utils/utils.dart';

class LeaveCardItem extends StatelessWidget {
  final VoidCallback? onTap;
  final LeaveEntity data;
  const LeaveCardItem({
    Key? key,
    this.onTap,
    required this.data,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Dimens.dp16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.leaveType,
                        style: TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: Dimens.dp8),
                      Row(
                        children: [
                          Text(
                            '${data.startDate}  •  ',
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            data.totalDate.toString(),
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            ' ${S.of(context).days}',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                LeaveUtils.getLeaveBadge(data.status),
              ],
            ),
            const SizedBox(height: Dimens.dp12),
            SubTitle2Text(
              data.label ?? '',
              style: TextStyle(color: data.status.getColor()),
            )
          ],
        ),
      ),
    );
  }
}
