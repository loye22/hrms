import 'package:flutter/material.dart';

class ProfileWidget extends StatefulWidget {
  final String name;
  final String occupation;
  final String photoUrl;

  const ProfileWidget({required this.name, required this.occupation, required this.photoUrl});

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 650,
      height: MediaQuery.of(context).size.height - 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white.withOpacity(0.13)),
        color: Colors.grey.shade200.withOpacity(0.13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(widget.photoUrl),
          ),
          SizedBox(height: 20),
          Text(
            widget.name,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            widget.occupation,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 30),
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.black,
            tabs: [
              Tab(text: 'Personal'),
              Tab(text: 'Attendance'),
              Tab(text: 'Documents'),
              Tab(text: 'Time Off'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Personal Tab
                Center(
                  child: Text('Personal Tab'),
                ),

                // Attendance Tab
                Center(
                  child: Text('Attendance Tab'),
                ),

                // Documents Tab
                Center(
                  child: Text('Documents Tab'),
                ),

                // Time Off Tab
                Center(
                  child: Text('Time Off Tab'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
