import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/utils/app_colors.dart';
import 'package:test_your_learing/views/custom_widgets/search_field.dart';
import 'package:test_your_learing/views/screen/dashboard/homepage/notificationpage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                Container(
                  // height: 200,
                  decoration: BoxDecoration(
                    gradient: homeGradient,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width:
                                  50, // Adjust the width to accommodate the border
                              height:
                                  50, // Adjust the height to accommodate the border
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: lightwhite1, // Border color
                                  width: 1.0, // Border width
                                ),
                              ),
                              child: const CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(
                                  "assets/images/logo.png",
                                ),
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                 Get.to(NotificationPage());
                              },
                              child: Container(
                                width:
                                    45, // Adjust the width to accommodate the border
                                height:
                                    45, // Adjust the height to accommodate the border
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: lightwhite1, // Border color
                                    width: 1.0, // Border width
                                  ),
                                ),
                                child: Image.asset(
                                  "assets/icons/png_notification.png",
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        Row(
                          children: [
                            Container(
                              width:
                                  32, // Adjust the width to accommodate the border
                              height:
                                  32, // Adjust the height to accommodate the border
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: whitecolor.withAlpha(40),
                              ),
                              child: Image.asset("assets/icons/png_user.png"),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Hello, user!",
                              style: TextStyle(
                                color: lightwhite1,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Let’s learn something new today!",
                          style: TextStyle(
                            color: lightwhite1,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
        
                        SizedBox(height: 24),
        
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          child: InkWell(
                            onTap: () {
                              // _showModal(context, serviceController);
                            },
                            child: SearchField(),
                          ),
                        ),
        
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                Image.asset(
                  "assets/images/png_vector_wave.png",
                  //width: 120,
                  height: 120,
                ),
              ],
            ),
        
            /*   GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              padding: const EdgeInsets.all(16),
              children: [
                buildDashboardItem(
                  topColor: const Color(0xff0B7ED7),
                  bottomColor: const Color(0xff069CDD),
                  value: 'n/a',
                  iconPath: 'assets/icons/png_dash_progressquiz.png',
                  description: 'Quizzes In progress',
                  onTap: () => print('Tapped Total Sales'),
                ),
                buildDashboardItem(
                  topColor: const Color(0xff5C9602),
                  bottomColor: const Color(0xff8DC900),
                  value: 'n/a',
                  iconPath: 'assets/icons/png_dash_compltedquiz.png',
                  description: 'Completed Quizzes',
                  onTap: () => print('Tapped New Users'),
                ),
                buildDashboardItem(
                  topColor: const Color(0xff9962DE),
                  bottomColor: const Color(0xff948DFF),
                  value: 'n/a',
                  iconPath: 'assets/icons/png_dash_totalhour.png',
                  description: 'Total Hours spent',
                  onTap: () => print('Tapped New Users'),
                ),
                buildDashboardItem(
                  topColor: const Color(0xff3A9F9F),
                  bottomColor: const Color(0xff00D5AA),
                  value: 'n/a',
                  iconPath: 'assets/icons/png_dash_pointearn.png',
                  description: 'Points earned',
                  onTap: () => print('Tapped New Users'),
                ),
              ],
            ),
           */
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio:1.5,
              ),
              children: [
                buildDashboardItem(
                  topColor: const Color(0xff0B7ED7),
                  bottomColor: const Color(0xff069CDD),
                  value: 'n/a',
                  iconPath: 'assets/icons/png_dash_progressquiz.png',
                  description: 'Quizzes In progress',
                  onTap: () => print('Tapped Total Sales'),
                ),
                buildDashboardItem(
                  topColor: const Color(0xff5C9602),
                  bottomColor: const Color(0xff8DC900),
                  value: 'n/a',
                  iconPath: 'assets/icons/png_dash_compltedquiz.png',
                  description: 'Completed Quizzes',
                  onTap: () => print('Tapped New Users'),
                ),
                buildDashboardItem(
                  topColor: const Color(0xff9962DE),
                  bottomColor: const Color(0xff948DFF),
                  value: 'n/a',
                  iconPath: 'assets/icons/png_dash_totalhour.png',
                  description: 'Total Hours spent',
                  onTap: () => print('Tapped New Users'),
                ),
                buildDashboardItem(
                  topColor: const Color(0xff3A9F9F),
                  bottomColor: const Color(0xff00D5AA),
                  value: 'n/a',
                  iconPath: 'assets/icons/png_dash_pointearn.png',
                  description: 'Points earned',
                  onTap: () => print('Tapped New Users'),
                ),
              ],
            ),
          
        
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text("Recent Activity",
                        style:
                            TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                                        // Text("View all", style: TextStyle(color: Colors.blue)),
                                      ],
                                    ),
                      ),
              const SizedBox(height: 12),
            
              SizedBox(
                height: 110,
        
                child: Image.asset("assets/images/png_no_recentactivity.png"),
               
        
                /* child: (serviceController.serviceCategories.value ?? [])
                        .isNotEmpty
                    ? ListView.builder(
                        //physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        shrinkWrap: true,
                        itemCount:
                            serviceController.serviceCategories.value.length,
                        itemBuilder: (context, index) {
                          final category =
                              serviceController.serviceCategories.value[index];
                          return Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  // When the image is clicked, call API and open bottom sheet
                                  await showModalBottomSheet(
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16)),
                                    ),
                                    isScrollControlled: true,
                                    builder: (context) => SubCategoryBottomSheet(
                                      categoryId: category.categoryId!,
                                      categoryName: category.name ?? "",
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 70,
                                  width: 70,
                                  margin: EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: primarycolor.withAlpha(15)),
                                  padding: EdgeInsets.all(18),
                                  child: Image.network(
                                    category.icon ?? "",
                                    height: 32,
                                    width: 32,
                                    color: primarycolor,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Center(
                                  child: Text(
                                category.name ?? "",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: primarycolor),
                              ))
                            ],
                          );
                        },
                      )
                    : Center(
                        child: Container(
                            //margin: EdgeInsets.only(top: 30),
                            padding: EdgeInsets.all(5),
                            child: Center(child: Text("No Category Found"))),
                      ), */
        
        
              ),
          
          
          ],
        ),
      );
   }
}

Widget buildDashboardItem({
  required Color topColor,
  required Color bottomColor,
  required String value,
  required String iconPath,
  required String description,
  VoidCallback? onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft ,
          end: Alignment.centerRight,
          colors: [topColor, bottomColor],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Value Text
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              // Icon
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(color: whitecolor,borderRadius: BorderRadius.circular(5)),
                child: Image.asset(
                  iconPath,
                  width: 16,
                  height: 16,
                  //color: Colors.white,
                ),
              ),
            ],
          ),

          // Description
          Text(
            description,
            style: const TextStyle(fontSize: 13, color: Colors.white,fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
