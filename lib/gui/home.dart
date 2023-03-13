part of main;

class Post {
  String title = "";
  String content = "";
  String userID = "";
  String timeStart = "";
  List groups = [];

  Post(this.title, this.content, this.userID, this.timeStart, this.groups);
}

class HomePage extends StatefulWidget {

  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var filters = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(32, 35, 43, 1),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Colors.black,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.fromLTRB(22, 12, 60, 12),
                          hintText: '🔍  Search task',
                          hintStyle: TextStyle(color: Color.fromRGBO(235, 235, 235, 0.8)),
                          filled: true,
                          fillColor: const Color.fromRGBO(22, 23, 27, 1),
                          isDense: true,
                        ),
                        style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(235, 235, 235, 0.8),
                        ),
                      ),
                    ),
             const SizedBox(height: 15),
             WidgetGroupsFilter(
                     groupsFiltered: (newGroups){
                       filters = newGroups;
                       setState(() {
                       });
                     }
             ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
             const SizedBox(height: 15),
             WidgetPostsBuilder(filters),
            ],
          ),
        ),
      ),
    );
  }
}

class WidgetGroupsFilter extends StatefulWidget {
  final ValueChanged<List> groupsFiltered;
  const WidgetGroupsFilter({super.key, required this.groupsFiltered});
  @override
  State createState() => WidgetGroupsFilterState();
}

class WidgetGroupsFilterState extends State<WidgetGroupsFilter> {
  bool isDoneBuilding = false;
  var groupIDs = [];
  var groupNames = [];
  var filters = [];

  @override
  void initState() {
    super.initState();
    getGroups();
  }

  @override
  Widget build (BuildContext context) {
    return SizedBox(
      height: 30,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              const Icon(Icons.filter_alt_sharp, color: Color.fromRGBO(230, 230, 230, 1), size: 14),
              const SizedBox(width: 5),
              const Text("Filter Class",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color.fromRGBO(230, 230, 230, 1),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: isDoneBuilding ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: groupIDs.length,
                  itemBuilder: (BuildContext context, int i) {
                    return
                        Row(
                          children: [
                            NotificationListener<RemoveGroup>(
                              onNotification: (n) {
                                setState(() {
                                  filters.remove(groupIDs[i]);
                                  widget.groupsFiltered(filters);
                                });
                                return true;
                              },
                              child: NotificationListener<AddGroup>(
                                child: GroupFilter(groupIDs[i], groupNames[i], filters),
                                  onNotification: (n) {
                                    setState(() {
                                      filters.add(groupIDs[i]);
                                      widget.groupsFiltered(filters);
                                    });
                                    return true;
                                  }
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        );
                  },
                ) : const Text("Loading your groups...",
                  style: TextStyle(color: Color.fromRGBO(235, 235, 235, 0.8))
                ),
              ),
            ],
          )
      ),
    );
  }

  void getGroups() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(
        "Users/${getUID()}/groups");
    DataSnapshot snapshot = await ref.get();
    Map value = snapshot.value as Map;
    value.forEach((a, b) => groupIDs.add(a));
    for(var groupID in groupIDs){
      DatabaseReference ref2 = FirebaseDatabase.instance.ref("Groups/$groupID/name");
      DataSnapshot snapshot = await ref2.get();
      groupNames.add("${snapshot.value}");
    }
    setState(() {
      isDoneBuilding = true;
    });
  }
}


class WidgetPostsBuilder extends StatefulWidget {
  DatabaseReference ref = FirebaseDatabase.instance.ref('Posts');
  var filters = [];
  WidgetPostsBuilder(this.filters, {super.key});

  @override
  State createState() => WidgetPostsBuilderState();
}

class WidgetPostsBuilderState extends State<WidgetPostsBuilder> {
  List <Post> posts = [];
  List <Post> postsFiltered = [];

  @override
  void initState() {
    super.initState();
    widget.ref.onChildAdded.listen((event) {
      Map groups = event.snapshot.child('groups').value as Map;
      if (groups != null){
        posts.add(
            Post(
                event.snapshot.child('title').value.toString(),
                event.snapshot.child('content').value.toString(),
                event.snapshot.child('userID').value.toString(),
                event.snapshot.child('timeStart').value.toString(),
                groups.keys.toList()
            )
        );
      }
      if (mounted) {
        setState(() {
        });
      }
    });

  }

  @override
  Widget build (BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int i) {
              bool isPrint = true;
              if (widget.filters.isNotEmpty) {
                for (var filter in widget.filters) {
                  isPrint = posts[i].groups.contains(filter);
                }
              }
              if (isPrint) {
                return CardPost(
                    posts[i].title, posts[i].content, posts[i].userID,
                    posts[i].timeStart
                );
              } else {
                return const SizedBox.shrink();
              }
            },
        )
      )
    );
  }
}

