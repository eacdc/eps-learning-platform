import 'package:flutter/material.dart';
import 'package:test_your_learing/constants/colors.dart';
import 'package:test_your_learing/theme.dart';
import 'package:test_your_learing/views/custom_widgets/circular_back_button.dart';

class NottificationSettingPage extends StatefulWidget {
  const NottificationSettingPage({super.key});

  @override
  State<NottificationSettingPage> createState() =>
      _NottificationSettingPageState();
}

class _NottificationSettingPageState extends State<NottificationSettingPage> {
  bool _newBookAddAlerts = true;
  bool _popularQuizzesAndBooks = true;
  bool _showBadgeIcon = true;
  bool _includeMutedChat = true;
  bool _countUnreadMessage = true;
  bool _booksRecommendations = true;
  bool _announcementsFromPublisher = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:  Theme.of(context).colorScheme.surface,
        // AppBar with custom layout
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Column(
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                backgroundColor:  Theme.of(context).colorScheme.surface,
                elevation: 0,
                surfaceTintColor: Colors.transparent,
                title: Container(
                  // color: Colors.yellow,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Back Button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CircularBackButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                       Text(
                        'Paramètres de notifications',
                        style: TextStyle(
                          color:  Theme.of(context).colorScheme.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Gray divider
                Divider(color: Theme.of(context).dividerColor, height: 1),

            ],
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            textAlign: TextAlign.start,
                            "Général",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      NotificationSwitchWidget(
                        title: 'Alertes nouveaux livres',
                        value: _newBookAddAlerts,
                        onChanged: (newValue) {
                          setState(() {
                            _newBookAddAlerts = newValue;
                          });
                        },
                      ),
                      NotificationSwitchWidget(
                        title: 'Quiz et livres populaires',
                        value: _popularQuizzesAndBooks,
                        onChanged: (newValue) {
                          setState(() {
                            _popularQuizzesAndBooks = newValue;
                          });
                        },
                      ),
                      Divider(
                        color:   Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(50),
                        height: 48,
                        thickness: 8,
                        indent: 0,
                        endIndent: 0,
                      ),
                   
                     SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            textAlign: TextAlign.start,
                            "Compteur de badge",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                       NotificationSwitchWidget(
                        title: 'Afficher l\'icône de badge',
                        value: _showBadgeIcon,
                        onChanged: (newValue) {
                          setState(() {
                            _showBadgeIcon = newValue;
                          });
                        },
                      ),
                      NotificationSwitchWidget(
                        title: 'Inclure les chats silencieux',
                        value: _includeMutedChat,
                        onChanged: (newValue) {
                          setState(() {
                            _includeMutedChat = newValue;
                          });
                        },
                      ),
                     
                      NotificationSwitchWidget(
                        title: 'Compter les messages non lus',
                        value: _countUnreadMessage,
                        onChanged: (newValue) {
                          setState(() {
                            _countUnreadMessage = newValue;
                          });
                        },
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(50),
                        height: 48,
                        thickness: 8,
                        indent: 0,
                        endIndent: 0,
                      ),
                        SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            textAlign: TextAlign.start,
                            "Notification",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      NotificationSwitchWidget(
                        title: 'Recommandations de livres',
                        value: _booksRecommendations,
                        onChanged: (newValue) {
                          setState(() {
                            _booksRecommendations = newValue;
                          });
                        },
                      ),
                      NotificationSwitchWidget(
                        title: 'Annonces de l\'éditeur',
                        value: _announcementsFromPublisher,
                        onChanged: (newValue) {
                          setState(() {
                            _announcementsFromPublisher = newValue;
                          });
                        },
                      ),
                     
                    
                    
                   
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationSwitchWidget extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const NotificationSwitchWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          Transform.scale(scale: 0.8,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: whitecolor,
              activeTrackColor: primarycolor,
              inactiveThumbColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
