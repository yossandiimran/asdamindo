// ignore_for_file: no_logic_in_create_state, prefer_typing_uninitialized_variables

import 'package:asdamindo/formTambahBarang.dart';
import 'package:asdamindo/helper/global.dart';
import 'package:asdamindo/listBatangPribadi.dart';
import 'package:asdamindo/profilePengaturan.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key, required this.title});
  final String title;
  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    page({required Widget child}) => Styled.widget(child: child)
        .padding(vertical: 30, horizontal: 20)
        .constrained(minHeight: MediaQuery.of(context).size.height - (2 * 30))
        .scrollable();

    return <Widget>[
      UserCard(),
      ActionsRow(),
      Settings(),
    ].toColumn().parent(page);
  }
}

class UserCard extends StatelessWidget {
  const UserCard({super.key});

  Widget _buildUserRow() {
    return <Widget>[
      Icon(Icons.account_circle)
          .decorated(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          )
          .constrained(height: 50, width: 50)
          .padding(right: 10),
      <Widget>[
        Text(
          preference.getData("nama"),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ).padding(bottom: 5),
        Text(
          preference.getData("sk"),
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
    ].toRow();
  }

  Widget _buildUserStats() {
    return <Widget>[
      _buildUserStatsItem('3', 'Produk'),
      _buildUserStatsItem('51', 'Transaksi'),
      _buildUserStatsItem('21', 'Followers'),
      _buildUserStatsItem('33', 'Following'),
    ].toRow(mainAxisAlignment: MainAxisAlignment.spaceAround).padding(vertical: 10);
  }

  Widget _buildUserStatsItem(String value, String text) => <Widget>[
        Text(value).fontSize(20).textColor(Colors.white).padding(bottom: 5),
        Text(text).textColor(Colors.white.withOpacity(0.6)).fontSize(12),
      ].toColumn();

  @override
  Widget build(BuildContext context) {
    return <Widget>[_buildUserRow(), _buildUserStats()]
        .toColumn(mainAxisAlignment: MainAxisAlignment.spaceAround)
        .padding(horizontal: 20, vertical: 10)
        .decorated(color: Color(0xff3977ff), borderRadius: BorderRadius.circular(20))
        .elevation(
          5,
          shadowColor: Color(0xff3977ff),
          borderRadius: BorderRadius.circular(20),
        )
        .height(175)
        .alignment(Alignment.center);
  }
}

class ActionsRow extends StatelessWidget {
  const ActionsRow({super.key});

  Widget _buildActionItem(String name, IconData icon) {
    final Widget actionIcon = Icon(icon, size: 20, color: Color(0xFF42526F))
        .alignment(Alignment.center)
        .ripple()
        .constrained(width: 50, height: 50)
        .backgroundColor(Color(0xfff6f5f8))
        .clipOval()
        .padding(bottom: 5);

    final Widget actionText = Text(
      name,
      style: TextStyle(
        color: Colors.black.withOpacity(0.8),
        fontSize: 12,
      ),
    );

    return <Widget>[
      actionIcon,
      actionText,
    ].toColumn().padding(vertical: 20);
  }

  @override
  Widget build(BuildContext context) => <Widget>[
        _buildActionItem('Saldo', Icons.attach_money),
        _buildActionItem('Transaksi', Icons.card_giftcard),
        _buildActionItem('Pesan', Icons.message),
        _buildActionItem('Notifikasi', Icons.notifications),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceAround);
}

class SettingsItemModel {
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final onTapEvent;
  const SettingsItemModel({
    required this.color,
    required this.description,
    required this.icon,
    required this.title,
    required this.onTapEvent,
  });
}

const List<SettingsItemModel> settingsItems = [
  SettingsItemModel(
    icon: Icons.dashboard,
    color: Color(0xffF468B7),
    title: 'Produk',
    description: 'Daftar Produk Anda',
    onTapEvent: "Produk",
  ),
  SettingsItemModel(
    icon: Icons.settings,
    color: Color(0xff8D7AEE),
    title: 'Pengaturan',
    description: 'Ubah pengaturan alamat, profile, dll',
    onTapEvent: "Pengaturan",
  ),
  SettingsItemModel(
    icon: Icons.logout_rounded,
    color: Color.fromARGB(255, 228, 43, 22),
    title: 'Logout',
    description: 'Keluar dari akun anda',
    onTapEvent: "Logout",
  ),
  SettingsItemModel(
    icon: Icons.question_answer,
    color: Color(0xffBFACAA),
    title: 'Support',
    description: 'Hubungi admin asdamindo',
    onTapEvent: "Support",
  ),
];

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) => settingsItems
      .map((settingsItem) => SettingsItem(
            settingsItem.icon,
            settingsItem.color,
            settingsItem.title,
            settingsItem.description,
            settingsItem.onTapEvent,
          ))
      .toList()
      .toColumn();
}

class SettingsItem extends StatefulWidget {
  SettingsItem(this.icon, this.iconBgColor, this.title, this.description, this.onTapEvent, {super.key});

  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String description;
  final onTapEvent;

  @override
  _SettingsItemState createState() => _SettingsItemState(onTapEvent);
}

class _SettingsItemState extends State<SettingsItem> {
  bool pressed = false;
  final onTapEvent;

  _SettingsItemState(this.onTapEvent);

  @override
  Widget build(BuildContext context) {
    settingsItem({required Widget child}) => Styled.widget(child: child)
        .alignment(Alignment.center)
        .borderRadius(all: 15)
        .ripple()
        .backgroundColor(Colors.white, animate: true)
        .clipRRect(all: 25) // clip ripple
        .borderRadius(all: 25, animate: true)
        .elevation(
          pressed ? 0 : 20,
          borderRadius: BorderRadius.circular(25),
          shadowColor: Color(0x30000000),
        ) // shadow borderRadius
        .constrained(height: 80)
        .padding(vertical: 12) // margin
        .gestures(
            onTapChange: (tapStatus) => setState(() => pressed = tapStatus),
            onTapDown: (details) => print('tapDown'),
            onTap: () {
              if (onTapEvent == "Logout") global.alertLogout(context);
              if (onTapEvent == "Produk") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctx) {
                    return ProductListScreen();
                  }),
                );
              }
              if (onTapEvent == "Pengaturan") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctx) {
                    return PengaturanProfile(title: 'Pengaturan');
                  }),
                );
              }
            })
        .animate(Duration(milliseconds: 150), Curves.easeOut);

    final Widget icon = Icon(widget.icon, size: 20, color: Colors.white)
        .padding(all: 12)
        .decorated(
          color: widget.iconBgColor,
          borderRadius: BorderRadius.circular(30),
        )
        .padding(left: 15, right: 10);

    final Widget title = Text(
      widget.title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ).padding(bottom: 5);

    final Widget description = Text(
      widget.description,
      style: TextStyle(
        color: Colors.black26,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );

    return settingsItem(
      child: <Widget>[
        icon,
        <Widget>[
          title,
          description,
        ].toColumn(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ].toRow(),
    );
  }
}
