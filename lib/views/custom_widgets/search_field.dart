import 'package:flutter/material.dart';
import 'package:test_your_learing/constants/colors.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(80)),
        borderRadius: const BorderRadius.all(
          Radius.circular(
            10.0,
          ),
          
          
        ),
        color: Theme.of(context).colorScheme.secondaryContainer,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12,
        vertical: 8
      ),
      child: Row(
        children: [
          SizedBox(
            width: 8,
          ),
          Text(
            'Search books & quizzes',
            style: TextStyle(
              color: lightgreytext2,
              fontSize: 17.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          Spacer(),
          Image.asset("assets/icons/png_search_black.png",height: 18,width: 18,color: gray,),
          SizedBox(width: 8,)
         
        ],
      ),
    );
  }
}
